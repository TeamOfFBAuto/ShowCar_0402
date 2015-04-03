//
//  DemoLocationViewController.m
//  iOS-IMKit-demo
//
//  Created by YangZigang on 14/11/7.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import "DemoLocationViewController.h"
#import "BMapKit.h"

@interface DemoAnnotationForBaidu : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;


@end

@implementation DemoAnnotationForBaidu


@end

@interface DemoLocationViewController ()
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, strong) NSString *locationName;
@end

@implementation DemoLocationViewController

- (instancetype)initWithLocation:(CLLocationCoordinate2D)location locationName:(NSString*)locationName {
    if (self = [super init]) {
        self.location = location;
        self.locationName = locationName;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
        self.edgesForExtendedLayout = UIRectEdgeAll;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
    BMKCoordinateRegion region;
    region.center = self.location;
    region.span.longitudeDelta = 0.001;
    region.span.latitudeDelta = self.mapView.frame.size.height / self.mapView.frame.size.width * 0.001;
    [self.mapView setRegion:region];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.title = self.locationName;
    DemoAnnotationForBaidu *annotation = [[DemoAnnotationForBaidu alloc] init];
    annotation.title = self.locationName;
    [annotation setCoordinate:self.location];
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:NO];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    if (!self.title) {
        self.title = @"位置信息";
    }
    [self configureNavigationBar];
}


- (void)clickToDo:(UIButton *)sender
{
    
}

- (void)configureNavigationBar
{
    UILabel *_myTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,44)];
    _myTitleLabel.textAlignment = NSTextAlignmentCenter;
    _myTitleLabel.text = @"选取位置";
    _myTitleLabel.textColor = [UIColor blackColor];
    _myTitleLabel.font = [UIFont systemFontOfSize:17];
    self.navigationItem.titleView = _myTitleLabel;
    
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton.width = -5;
    
    self.navigationController.navigationBarHidden=NO;
    
    
    UIBarButtonItem * spaceButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton1.width = -13;
    
    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(-5,8,40,44)];
    //    [button_back addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [button_back setImage:DEFAULT_IMAGE_BACK forState:UIControlStateNormal];
    UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:button_back];
    self.navigationItem.leftBarButtonItems=@[spaceButton1,back_item];
    
    
    UIButton * left_button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    left_button.frame = CGRectMake(0,0,30,44);
    
    left_button.titleLabel.textAlignment = NSTextAlignmentRight;
    
    [left_button setTitle:@"返回" forState:UIControlStateNormal];
    
    left_button.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [left_button setTitleColor:RGBCOLOR(80,80,80) forState:UIControlStateNormal];
    
    [left_button addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItems = @[spaceButton,[[UIBarButtonItem alloc] initWithCustomView:left_button]];
}

-(void)leftBarButtonItemPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
