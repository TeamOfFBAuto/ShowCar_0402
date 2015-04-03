//
//  RCLocationViewController.h
//  iOS-IMKit
//
//  Created by YangZigang on 14/11/4.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import "RCBasicViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface RCLocationViewController : RCBasicViewController <MKMapViewDelegate>

/** @name 属性 */

/** 需要显示的位置坐标 */
@property (nonatomic, assign) CLLocationCoordinate2D location;
/** 需要显示的位置名称 */
@property (nonatomic, strong) NSString *locationName;

/** 设置NavigationBar */
- (void)configureNavigationBar;

/** 返回按钮按下  [self.navigationController popViewControllerAnimated:YES] */
- (void)leftBarButtonItemPressed:(id)sender;

@end
