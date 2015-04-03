//
//  DemoDataPickerBaiduMapDataSource.h
//  iOS-IMKit-demo
//
//  Created by YangZigang on 14/11/7.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCLocationPickerViewController.h"
#import "BMapKit.h"
/**
 如果开发者需要使用第三方地图，可以把DemoDataPickerBaiduMapDataSource当作一个参考，目前第三方地图提供的接口大同小异。
 */
@interface DemoLocationPickerBaiduMapDataSource : NSObject <RCLocationPickerViewControllerDataSource, BMKLocationServiceDelegate, BMKMapViewDelegate, BMKPoiSearchDelegate, BMKCloudSearchDelegate, BMKGeoCodeSearchDelegate>

@end
