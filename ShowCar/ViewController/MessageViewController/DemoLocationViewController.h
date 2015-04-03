//
//  DemoLocationViewController.h
//  iOS-IMKit-demo
//
//  Created by YangZigang on 14/11/7.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DemoLocationViewController : UIViewController
- (instancetype)initWithLocation:(CLLocationCoordinate2D)location locationName:(NSString*)locationName;
@end
