//
//  FBMapViewController.h
//  越野e族
//
//  Created by soulnear on 13-12-18.
//  Copyright (c) 2013年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface FBMapViewController : UIViewController<MKMapViewDelegate,UIActionSheetDelegate>
{
   double userLatitude;
   double userlongitude;
}


@property(nonatomic,strong)MKMapView * myMapView;

///纬度
@property(nonatomic,assign)double address_latitude;
///经度
@property(nonatomic,assign)double address_longitude;
///标题
@property(nonatomic,strong)NSString * address_title;
///简介
@property(nonatomic,strong)NSString * address_content;

@end
