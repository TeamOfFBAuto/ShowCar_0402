//
//  RCLocationPickerViewController.h
//  iOS-IMKit
//
//  Created by YangZigang on 14/10/31.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import "RCBasicViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

/** POI搜索结束后用于回调的block 
 
 参数： pois 需要显示的POI列表
 
 参数： clearPreviousResult 如果地图位置已经发生变化，需要清空之前的POI数据
 
 参数： hasMore 如果POI数据很多，可以进行“更多”显示
 
 参数： error  搜索POI出现错误时，返回错误信息
 */
typedef void (^OnPoiSearchResult)(NSArray *pois, BOOL clearPreviousResult, BOOL hasMore, NSError *error);

@protocol RCLocationPickerViewControllerDelegate;
@protocol RCLocationPickerViewControllerDataSource;
/**   位置选取视图控制器
 
 这个类的实现比较简单：一个地图控件以及一个UITableView。
 
 UITableView显示从RCLocationPickerViewControllerDataSource获取的poi列表，用户可以点击poi列表选中某个poi。用户点击“完成”时，则将这个选中的poi的title传递给delegate，同时还有地图控件的截图，以及地图空间中心点的位置。
 
 这个类还会在地图控件的中心始终显示一个图片，这个图片来自于RCLocationPickerViewControllerDataSource的annotationLayer。地图控件放置于mapViewContainer, annotationLayer放置于mapViewContainer的layer之上。
 
 开发者可以实现自己的LocationPickerViewController(不必继承自RCLocationPickerViewController)，为了调用开发者自己的LocationPickerViewController，需要实现<RCChatViewController>的- (void)openLocation:(CLLocationCoordinate2D)location locationName:(NSString*)locationName函数，开发者可以在这个函数中跳到自定义的视图控制器，等自定义的视图控制器选取位置完毕后，调用<RCChatViewController>的- (void)sendLBSMessage:(UIImage*)mapScreenShot location:(CLLocationCoordinate2D)location locationName:(NSString*)locationName来发送地理位置消息。
 */
@interface RCLocationPickerViewController : RCBasicViewController <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<RCLocationPickerViewControllerDelegate> delegate;
@property (nonatomic, strong) id<RCLocationPickerViewControllerDataSource> dataSource;
@property (nonatomic, strong) IBOutlet UIView* mapViewContainer;

/** @name 初始化函数 */

/** 初始化
 
 @param dataSource 详见<RCLocationPickerViewControllerDataSource>
 */
- (instancetype)initWithDataSource:(id<RCLocationPickerViewControllerDataSource>)dataSource;
/** 设置UINavigationController的NavigationBar
 
 设置返回按钮、标题、完成按钮。用户可以根据情况编写自己的configureNavigationBar。
 */
- (void)configureNavigationBar;
/** “返回”按钮按下后，会调用本函数。本函数默认执行     [self.navigationController popViewControllerAnimated:YES]; */
- (void)leftBarButtonItemPressed:(id)sender;
/** 完成按钮动作。
 
 
 “完成”按钮按下后，会调用本函数。 本函数会调用RCLocationPickerViewControllerDelegate的locationPicker:didSelectLocation:locationName:mapScreenShot:方法。
 
 传给locationPicker:didSelectLocation:locationName:mapScreenShot:的参数分别为
 
 - self
 - [self.dataSource mapViewCenter];//取地图中心点的坐标
 - [self currentLocationName];//这个函数取选中的poi点的title
 - [self.dataSource mapViewScreenShot];//地图截图
 
 */
- (void)onFinishButtonClicked:(id)sender;
@end

/**
 
 RCLocationPickerViewControllerDataSource必须实现下面方法
 
 -  \- (UIView*)mapView;
 -  \- (CLLocationCoordinate2d)mapViewCenter;
 -  \- (void)setOnPoiSearchResult:(OnPoiSearchResul)poiSearchResult
 -  \- (void)beginFetchPoisOfCurrentLocation;
 -  \- (UIImage*)mapViewScreenShot;
 
 */
@protocol RCLocationPickerViewControllerDataSource <NSObject>

/**
 @return 在界面上显示的地图控件
 */
- (UIView*)mapView;

/**
 @return 界面上显示的中心点标记。如不想显示中心点标记，可以返回nil。
 */
- (CALayer*)annotationLayer;

/**
 @retrun 返回地图标注的名称。
 
 <OnPoiSearchResult>的参数pois包含若干地图标注，SDK不关心地图标注的类型，SDK会调用本函数获取地图标注的具体名称。
 */
- (NSString*)titleOfPlaceMark:(id)placeMark;

/**
 @return 返回地图标注的坐标。
 
<OnPoiSearchResult>的参数pois包含若干地图标注，SDK不关心地图标注的类型，SDK会调用本函数获取地图标注的具体位置坐标。
 */
- (CLLocationCoordinate2D)locationCoordinate2DOfPlaceMark:(id)placeMark;

/**
 @param location 地图中心点
 @param animated 是否开启动画效果
 */
- (void)setMapViewCenter:(CLLocationCoordinate2D)location animated:(BOOL)animated;

/**
 @param coordinateRegion 地图显示区域
 @param animated 是否开启动画效果
 */
- (void)setMapViewCoordinateRegion:(MKCoordinateRegion)coordinateRegion animated:(BOOL)animated;

/**
 开发者自己实现的 RCLocationPickerViewControllerDataSource 可以据此进行特定处理。当有新的POI列表时，默认选中第一个。
 
 @param placeMark 用户选择了某一个位置标注。
 */
- (void)userSelectPlaceMark:(id)placeMark;

/**
 @return 当前地图中心点，发送给好友的位置消息中会包含该中心点的坐标。
 */
 - (CLLocationCoordinate2D)mapViewCenter;

/** 设置POI搜索完毕后的回调block
 
 @param poiSearchResult <OnPoiSearchResult>
 */
- (void)setOnPoiSearchResult:(OnPoiSearchResult)poiSearchResult;

/**
 获取当前视野中POI
 */
- (void)beginFetchPoisOfCurrentLocation;

/**
 @return 对当前地图进行截图，该截图的缩略图会包含在发送给好友的位置消息中。
 */
- (UIImage*)mapViewScreenShot;

@end

/**
 当位置选择界面选择完毕后，通知delegate以便进行下一步的地理位置消息发送。
 */
@protocol RCLocationPickerViewControllerDelegate <NSObject>
/**
 通知delegate，已经获取到相关的地理位置信息
 */
- (void)locationPicker:(RCLocationPickerViewController*)locationPicker didSelectLocation:(CLLocationCoordinate2D)location locationName:(NSString*)locationName mapScreenShot:(UIImage*)mapScreenShot;


@end
