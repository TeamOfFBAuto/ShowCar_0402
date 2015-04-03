//
//  ChatViewController.m
//  CustomNewProject
//
//  Created by lichaowei on 15/1/23.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import "ChatViewController.h"
#import "LocationViewController.h"

#import "DemoLocationPickerBaiduMapDataSource.h"
#import "DemoLocationViewController.h"

#import "FBMapViewController.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "PreviewImageController.h"

//#import "RCLocationPickerViewControllerDataSource"

@interface ChatViewController ()<UINavigationControllerDelegate>

@end

@implementation ChatViewController

- (void)dealloc
{
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
        self.edgesForExtendedLayout = UIRectEdgeAll;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] )
    {
        //iOS 5 new UINavigationBar custom background
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7DAOHANGLANBEIJING_PUSH] forBarMetrics: UIBarMetricsDefault];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
        self.edgesForExtendedLayout = UIRectEdgeAll;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] )
    {
        //iOS 5 new UINavigationBar custom background
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7DAOHANGLANBEIJING_PUSH] forBarMetrics: UIBarMetricsDefault];
    }
    
    UILabel *_myTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,44)];
    _myTitleLabel.textAlignment = NSTextAlignmentCenter;
    _myTitleLabel.text = self.currentTargetName;
    _myTitleLabel.textColor = [UIColor blackColor];
    _myTitleLabel.font = [UIFont systemFontOfSize:17];
    self.navigationItem.titleView = _myTitleLabel;
    
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton.width = -5;
    
    self.navigationController.navigationBarHidden=NO;
    
    
    UIBarButtonItem * spaceButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton1.width = -13;
    
    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(-5,8,40,44)];
    [button_back addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [button_back setImage:DEFAULT_IMAGE_BACK forState:UIControlStateNormal];
    UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:button_back];
    self.navigationItem.leftBarButtonItems=@[spaceButton1,back_item];
    
    self.enablePOI = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 事件处理

- (void)leftButtonTap:(UIButton *)sender
{
    self.navigationController.delegate = nil;

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)openLocationPicker:(id)sender
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"black"] forBarMetrics: UIBarMetricsDefault];
    
    self.navigationController.delegate = self;
    
    [super openLocationPicker:sender];
    
//    LocationViewController *location = [[LocationViewController alloc]initWithDataSource:self];
//    [self.navigationController pushViewController:location animated:YES];
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    NSLog(@"viewController %@",NSStringFromClass([viewController class]));
    
//    UIBarButtonItem * spaceButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    spaceButton1.width = MY_MACRO_NAME?-13:5;
//    
//    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(MY_MACRO_NAME? -5:5,8,40,44)];
//    [button_back addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
//    [button_back setImage:[UIImage imageNamed:BACK_DEFAULT_IMAGE_GRAY] forState:UIControlStateNormal];
//    UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:button_back];
//    viewController.navigationItem.leftBarButtonItems=@[spaceButton1,back_item];
    
//    if( [NSStringFromClass([viewController class]) isEqualToString:@"PUUIAlbumListViewController"]) {
//        
//        button_back.hidden = YES;
//    }else
//    {
//        button_back.hidden = NO;
//    }
}

//- (id<RCLocationPickerViewControllerDataSource>)locationPickerDataSource {
//    return [[DemoLocationPickerBaiduMapDataSource alloc] init];
//}

- (void)openLocation:(CLLocationCoordinate2D)location locationName:(NSString *)locationName {
    
    FBMapViewController * mapViewController = [[FBMapViewController alloc] init];
    mapViewController.address_title = locationName;
    mapViewController.address_latitude = location.latitude;
    mapViewController.address_longitude = location.longitude;
    
    [self.navigationController pushViewController:mapViewController animated:YES];
}

#pragma mark - 调用看大图

-(void)showPreviewPictureController:(RCMessage*)rcMessage
{
    RCImageMessage *image = (RCImageMessage *)rcMessage.content;
    
    NSLog(@"image %@ %@ %@",image.thumbnailImage,image.imageUrl,image.originalImage
          );
    PreviewImageController *preview = [[PreviewImageController alloc]init];
//    preview.rcMessage = rcMessage;
    preview.imageUrl = image.imageUrl;
    preview.thumImage = image.thumbnailImage;
    UINavigationController *unvc = [[UINavigationController alloc]initWithRootViewController:preview];
    
    [self presentViewController:unvc animated:YES completion:^{
        
    }];
}

@end
