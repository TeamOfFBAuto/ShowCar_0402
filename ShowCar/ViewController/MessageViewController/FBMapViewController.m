//
//  FBMapViewController.m
//  越野e族
//
//  Created by soulnear on 13-12-18.
//  Copyright (c) 2013年 soulnear. All rights reserved.
//

#import "FBMapViewController.h"
#import <AddressBook/AddressBook.h>
#import <CoreLocation/CoreLocation.h>

@interface FBMapViewController ()<CLLocationManagerDelegate>
{
    CLLocationManager * locationManager;
}

@end

@implementation FBMapViewController
@synthesize myMapView = _myMapView;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}


-(void)backto
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightButtonTap:(UIButton *)sender
{
    [self ToMapView:sender];
}

-(void)ToMapView:(UIButton *)button
{//跳转到地图
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"使用百度地图导航",@"使用手机自带地图导航",nil];
    [actionSheet showInView:self.view];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex -----  %ld",(long)buttonIndex);
    switch (buttonIndex) {
        case 2:
        {//取消
            
        }
            break;
        case 0:
        {//百度
//            NSString * string = [NSString stringWithFormat:@"baidumap://map/marker?location=%f,%f&title=%@&content=%@",_address_latitude,_address_longitude,[_address_title stringByAddingPercentEscapesUsingEncoding:  NSUTF8StringEncoding],[_address_content stringByAddingPercentEscapesUsingEncoding:  NSUTF8StringEncoding]];
            
            ///name:起始位置
            NSString * string = [NSString stringWithFormat:@"baidumap://map/direction?origin=%f,%f&destination=%f,%f&mode=driving&src=gaizhuang",userLatitude,userlongitude,_address_latitude,_address_longitude];
            
            NSLog(@"我我我我我我我我我我我我我我我我我我我哦我我我我我 ---  %@",string);
            
            UIApplication *app = [UIApplication sharedApplication];
            
            if ([app canOpenURL:[NSURL URLWithString:string]])
            {
                [app openURL:[NSURL URLWithString:string]];
            }else
            {
                [LTools showMBProgressWithText:@"您还没有安转百度地图" addToView:self.view];
            }
        }
            break;
        case 1:
        {//手机
            /*
            if (IOS_VERSION>=6.0)
            {
                
                NSDictionary *dicOfAddress = [NSDictionary dictionaryWithObjectsAndKeys:_address_title,(NSString *)kABPersonAddressStreetKey,nil];
                
                CLLocationCoordinate2D coords =
                CLLocationCoordinate2DMake(_address_latitude,_address_longitude);
                
                MKPlacemark *place = [[MKPlacemark alloc] initWithCoordinate:coords addressDictionary:dicOfAddress];
                
                MKMapItem *mapItem = [[MKMapItem alloc]initWithPlacemark:place];
                
                [mapItem openInMapsWithLaunchOptions:nil];
                
            }else
            {
                NSString *string = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f",userLatitude,userlongitude];
                
                [[UIApplication sharedApplication]  openURL:[NSURL URLWithString:string]];
            }
            
            
            
            */
            
            
            
            CLLocationCoordinate2D from = CLLocationCoordinate2DMake(userLatitude,userlongitude);
            MKPlacemark * fromMark = [[MKPlacemark alloc] initWithCoordinate:from
                                                            addressDictionary:nil];
            MKMapItem * fromLocation = [[MKMapItem alloc] initWithPlacemark:fromMark];
            fromLocation.name = @"我的位置";
            
            
            CLLocationCoordinate2D to = CLLocationCoordinate2DMake(_address_latitude,_address_longitude);
            MKPlacemark * toMark = [[MKPlacemark alloc] initWithCoordinate:to
                                                          addressDictionary:nil];
            MKMapItem * toLocation = [[MKMapItem alloc] initWithPlacemark:toMark];
            toLocation.name = _address_title;
            
            NSArray  * values = [NSArray arrayWithObjects:
                                 MKLaunchOptionsDirectionsModeDriving,
                                 [NSNumber numberWithBool:YES],
                                 [NSNumber numberWithInt:2],
                                 nil];
            NSArray * keys = [NSArray arrayWithObjects:
                              MKLaunchOptionsDirectionsModeKey,
                              MKLaunchOptionsShowsTrafficKey,
                              MKLaunchOptionsMapTypeKey,nil];
            
            [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:fromLocation, toLocation, nil]
                           launchOptions:[NSDictionary dictionaryWithObjects:values
                                                                     forKeys:keys]];

            
            
        }
            break;
            
        default:
            break;
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    if (MY_MACRO_NAME) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    }
    
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    if (self.navigationController.isNavigationBarHidden) {
        
        self.navigationController.navigationBarHidden = NO;
        
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (MY_MACRO_NAME) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    }

    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] )
    {
        //iOS 5 new UINavigationBar custom background
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7DAOHANGLANBEIJING_PUSH] forBarMetrics: UIBarMetricsDefault];
    }
    
    
    
    UILabel *_myTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,44)];
    _myTitleLabel.textAlignment = NSTextAlignmentCenter;
    _myTitleLabel.text = @"地图";
    _myTitleLabel.textColor = [UIColor blackColor];
    _myTitleLabel.font = [UIFont systemFontOfSize:17];
    self.navigationItem.titleView = _myTitleLabel;
    
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton.width = MY_MACRO_NAME?-5:5;
    
    self.navigationController.navigationBarHidden=NO;
    
    
    UIBarButtonItem * spaceButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton1.width = MY_MACRO_NAME?-13:5;
    
    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(MY_MACRO_NAME? -5:5,8,40,44)];
    [button_back addTarget:self action:@selector(clickToBack:) forControlEvents:UIControlEventTouchUpInside];
    [button_back setImage:DEFAULT_IMAGE_BACK forState:UIControlStateNormal];
    UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:button_back];
    self.navigationItem.leftBarButtonItems=@[spaceButton1,back_item];
    
    
    UIButton *_my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _my_right_button.frame = CGRectMake(0,0,30,44);
    
    _my_right_button.titleLabel.textAlignment = NSTextAlignmentRight;
    
    [_my_right_button setTitle:@"导航" forState:UIControlStateNormal];
    
    _my_right_button.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [_my_right_button setTitleColor:RGBCOLOR(80,80,80) forState:UIControlStateNormal];
    
    [_my_right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = @[spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
    
    
    
//    self.myTitle = @"地图";
//
//    self.rightString = @"导航";
//    
//    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
//    [self.my_right_button setTitleColor:RGBCOLOR(80,80,80) forState:UIControlStateNormal];
    
    _myMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT-64)];
    _myMapView.mapType=MKMapTypeStandard;
    _myMapView.delegate=self;
    _myMapView.showsUserLocation=NO;
    [self.view addSubview:_myMapView];
    
    
    MKCoordinateSpan span;
    MKCoordinateRegion region;
    
    span.latitudeDelta=0.05;
    span.longitudeDelta=0.05;
    region.span=span;
    region.center=CLLocationCoordinate2DMake(_address_latitude,_address_longitude);//[userLocation coordinate];
    
    [_myMapView setRegion:region animated:YES];
    
    MKPointAnnotation *ann = [[MKPointAnnotation alloc] init];
    ann.coordinate = region.center;
    [ann setTitle:_address_title];
    [ann setSubtitle:_address_content];
    //触发viewForAnnotation
    [_myMapView addAnnotation:ann];
    
    
    
    UIButton * center_button = [UIButton buttonWithType:UIButtonTypeCustom];
    center_button.frame = CGRectMake(DEVICE_WIDTH-40-12,DEVICE_HEIGHT-56-12-64,40,40);
    center_button.backgroundColor = [UIColor whiteColor];
//    center_button.layer.masksToBounds = YES;
    center_button.layer.cornerRadius = 3;
    center_button.layer.shadowColor = [UIColor blackColor].CGColor;
    center_button.layer.shadowOffset = CGSizeMake(-0.1,-0.1);
    center_button.layer.shadowOpacity = 0.3;
    center_button.layer.shadowRadius = 1;
    [center_button setImage:[UIImage imageNamed:@"map_icon_mine"] forState:UIControlStateNormal];
    [center_button addTarget:self action:@selector(centerButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:center_button];
    
    
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:@"applicationWillEnterForeground" object:nil];
}
#pragma mark - 从后台切换到程序通知
-(void)applicationWillEnterForeground
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];

}
- (void)clickToBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 回到获取到的位置
-(void)centerButtonTap:(UIButton *)button
{
    [_myMapView setCenterCoordinate:CLLocationCoordinate2DMake(_address_latitude,_address_longitude) animated:YES];
}


#pragma mark-MapViewDelegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    userLatitude=userLocation.coordinate.latitude;
    userlongitude=userLocation.coordinate.longitude;
    
    MKCoordinateSpan span;
    MKCoordinateRegion region;
    
    span.latitudeDelta=0.010;
    span.longitudeDelta=0.010;
    region.span=span;
    region.center=[userLocation coordinate];
    
    [_myMapView setRegion:[_myMapView regionThatFits:region] animated:YES];
}





#pragma mark - 定位
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error)
     {
         userLatitude = newLocation.coordinate.latitude;
         userlongitude =  newLocation.coordinate.longitude;
     }];
}














- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
