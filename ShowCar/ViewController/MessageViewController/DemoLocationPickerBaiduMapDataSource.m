
//
//  DemoDataPickerBaiduMapDataSource.m
//  iOS-IMKit-demo
//
//  Created by YangZigang on 14/11/7.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//
#import "DemoLocationPickerBaiduMapDataSource.h"

@interface DemoLocationPickerBaiduMapDataSource ()

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, copy) OnPoiSearchResult onComplete;
@property (nonatomic, strong) BMKLocationService *locationService;
@property (nonatomic, strong) NSDate *firstTimeUserLocationUpdated;
@property (nonatomic, strong) CALayer *annotationLayer;
@property (nonatomic, strong) BMKPoiSearch *poiSearch;
@property (nonatomic, strong) BMKNearbySearchOption *nearBySearchOption;

@property (nonatomic, strong) BMKCloudSearch *cloudSearch;
@property (nonatomic, strong) BMKCloudNearbySearchInfo *cloudNearBySearchInfo;

@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic, strong) BMKReverseGeoCodeOption *geoCodeSearchOption;

@property (nonatomic, assign) BOOL userHasJumpToLocation;
@end

@implementation DemoLocationPickerBaiduMapDataSource

- (instancetype)init {
    if (self = [super init]) {
        self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.mapView.delegate = self;
        self.locationService = [[BMKLocationService alloc] init];
        self.locationService.delegate = self;
        [self.locationService startUserLocationService];
        
        NSString *filePath = [[NSBundle mainBundle].bundlePath stringByAppendingString:@"/RongCloud.bundle/map_annotation.png"];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];
        self.annotationLayer = [CALayer layer];
        self.annotationLayer.contents = (id)image.CGImage;
        self.annotationLayer.frame = CGRectMake(0, 0, 35, 35);

    }
    return self;
}

- (UIView*)mapView {
    return _mapView;
}

- (CALayer*)annotationLayer {
    return _annotationLayer;
}

- (void)setOnPoiSearchResult:(OnPoiSearchResult)poiSearchResult {
    self.onComplete = poiSearchResult;
}

- (NSString*)titleOfPlaceMark:(id)placeMark {
    BMKPoiInfo *poiInfo = (BMKPoiInfo*)placeMark;
    return poiInfo.name;
}

- (CLLocationCoordinate2D)locationCoordinate2DOfPlaceMark:(id)placeMark {
    BMKPoiInfo *poiInfo = (BMKPoiInfo*)placeMark;
    return poiInfo.pt;
}

- (CLLocationCoordinate2D)mapViewCenter {
    return self.mapView.centerCoordinate;
}

- (void)setMapViewCenter:(CLLocationCoordinate2D)location animated:(BOOL)animated {
    
}

- (void)setMapViewCoordinateRegion:(MKCoordinateRegion)coordinateRegion animated:(BOOL)animated {
    BMKCoordinateRegion region;
    region.center = coordinateRegion.center;
    region.span.longitudeDelta = coordinateRegion.span.longitudeDelta;
    region.span.latitudeDelta = coordinateRegion.span.latitudeDelta;
    self.mapView.region = region;
}

- (void)userSelectPlaceMark:(id)placeMark {
    BMKPoiInfo *poiInfo = (BMKPoiInfo*)placeMark;
    self.userHasJumpToLocation = YES;
    [self.mapView setCenterCoordinate:poiInfo.pt];
}

- (void)beginFetchPoisOfCurrentLocation {
    [self fetchGeocoderPoi];
}

- (UIImage*)mapViewScreenShot {
    UIImage *mapScreenShot = [self.mapView takeSnapshot];
    UIGraphicsBeginImageContextWithOptions(self.mapView.frame.size, NO, 0.0);
    CGAffineTransform flipVertical = CGAffineTransformMake(
                                                           1, 0, 0, -1, 0, mapScreenShot.size.height
                                                           );
    CGContextConcatCTM(UIGraphicsGetCurrentContext(), flipVertical);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, mapScreenShot.size.width, mapScreenShot.size.height), mapScreenShot.CGImage);
    
    NSString *filePath = [[NSBundle mainBundle].bundlePath stringByAppendingString:@"/RongCloud.bundle/map_annotation.png"];
    UIImage *imageAnnotation = [[UIImage alloc] initWithContentsOfFile:filePath];
    CGRect imageAnnotationFrame = CGRectMake(0, 0, 32, 32);
    imageAnnotationFrame.origin.y = mapScreenShot.size.height / 2;
    imageAnnotationFrame.origin.x = mapScreenShot.size.width / 2 - 16;
    CGContextDrawImage(UIGraphicsGetCurrentContext(), imageAnnotationFrame, imageAnnotation.CGImage);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGRect rect;
    rect.origin = CGPointZero;
    rect.size = image.size;
    rect.size.height *= image.scale;
    rect.size.width *= image.scale;
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

- (void)dealloc {
    [self.locationService stopUserLocationService];
    self.locationService.delegate = nil;
}

/** 由于百度地图搜索周边的接口必须提供keyword，没用keyword就不会有结果，所以我们使用了BMKGeoCodeSearch做为示例。开发者可以根据自己的应用场景自主选择使用哪个接口进行搜索。
 */
- (void)fetchPoi {
    if (!self.poiSearch) {
        self.poiSearch = [[BMKPoiSearch alloc] init];
        self.nearBySearchOption = [[BMKNearbySearchOption alloc] init];
        self.nearBySearchOption.location = self.mapView.centerCoordinate;
        self.nearBySearchOption.radius = 10;
        self.nearBySearchOption.pageIndex = 0;
        self.nearBySearchOption.pageCapacity = 10;
        self.nearBySearchOption.keyword = @"北苑";
    }
    self.nearBySearchOption.pageIndex += 1;
    self.poiSearch.delegate = self;
    BOOL result = [self.poiSearch poiSearchNearBy:self.nearBySearchOption];
    if (!result) {
        NSLog(@"search fail");
    }
}

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    self.onComplete(poiResult.poiInfoList, NO, poiResult.pageNum < poiResult.pageIndex + 1 ? NO : YES, nil);
}

- (void)onGetPoiDetailResult:(BMKPoiSearch *)searcher result:(BMKPoiDetailResult *)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode {
}

/** 由于百度地图云搜索的接口必须提供keyword，没用keyword就不会有结果，所以我们使用了BMKGeoCodeSearch做为示例。开发者可以根据自己的应用场景自主选择使用哪个接口进行搜索。
 */
- (void)fetchCloudPoi {
    if (!self.cloudSearch) {
        self.cloudSearch = [[BMKCloudSearch alloc] init];
        self.cloudSearch.delegate = self;
        self.cloudNearBySearchInfo = [[BMKCloudNearbySearchInfo alloc] init];
        self.cloudNearBySearchInfo.location = [NSString stringWithFormat:@"(%lf,%lf)", self.mapView.centerCoordinate.longitude, self.mapView.centerCoordinate.latitude];
        self.cloudNearBySearchInfo.radius = 10;
        self.cloudNearBySearchInfo.pageIndex = 0;
        self.cloudNearBySearchInfo.keyword = @"北苑";
    
    }
    self.cloudNearBySearchInfo.pageIndex += 1;
    BOOL result = [self.cloudSearch nearbySearchWithSearchInfo:self.cloudNearBySearchInfo];
    if (result) {
        
    }
    
}

- (void)onGetCloudPoiResult:(NSArray *)poiResultList searchType:(int)type errorCode:(int)error {
    self.onComplete(poiResultList.lastObject, NO, YES, nil);
    
}

- (void)fetchGeocoderPoi {
    if (!self.geoCodeSearch) {
        self.geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
        self.geoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    }
    self.geoCodeSearch.delegate = self;
    self.geoCodeSearchOption.reverseGeoPoint = self.mapView.centerCoordinate;
    [self.geoCodeSearch reverseGeoCode:self.geoCodeSearchOption];
    
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    self.onComplete(result.poiList, YES, NO, nil);
}

#pragma mark -
#pragma mark BMKLocationServiceDelegate
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation {
    if (!self.firstTimeUserLocationUpdated) {
        self.firstTimeUserLocationUpdated = [NSDate date];
    }
    if ([self.firstTimeUserLocationUpdated timeIntervalSinceNow] < -1.5) {
        [self.locationService stopUserLocationService];
        return;
    }
    
    MKCoordinateRegion coordinateRegion;
    coordinateRegion.center = userLocation.location.coordinate;
    coordinateRegion.span.latitudeDelta = 0.01;
    coordinateRegion.span.longitudeDelta = 0.01 * self.mapView.frame.size.width / self.mapView.frame.size.height;
    [self setMapViewCoordinateRegion:coordinateRegion animated:NO];
    [self.mapView updateLocationData:userLocation];
    [self.mapView setShowsUserLocation:YES];
}

#pragma mark -
#pragma mark BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if (self.userHasJumpToLocation) {
        self.userHasJumpToLocation = NO;
        return;
    }
    [self fetchGeocoderPoi];
}

@end
