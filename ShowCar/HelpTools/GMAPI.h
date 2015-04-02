//
//  GMAPI.h
//  FBAuto
//
//  Created by gaomeng on 14-7-3.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"



#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
//代码屏幕适配（设计图为320*568）
#define GscreenRatio_320 DEVICE_WIDTH/320.00
#define GscreenRatio_568 DEVICE_HEIGHT/568.00

@interface GMAPI : NSObject

+(NSString *)getUsername;


+(NSString *)getDeviceToken;

+(NSString *)getAuthkey;

+(NSString *)getAuthkey_GBK;

+(NSString *)getUid;

+(NSString *)getUserPassWord;



+ (MBProgressHUD *)showMBProgressWithText:(NSString *)text addToView:(UIView *)aView;





//写数据=========================

//保存用户banner到本地
+(BOOL)setUserBannerImageWithData:(NSData *)data;

//保存用户头像到本地
+(BOOL)setUserFaceImageWithData:(NSData *)data;



//获取document路径
+ (NSString *)documentFolder;


//读数据=========================

//获取用户bannerImage
+(UIImage *)getUserBannerImage;

//获取用户头像Image
+(UIImage *)getUserFaceImage;


//获取document路径
+ (NSString *)documentFolder;

//清除banner和头像
+(BOOL)cleanUserFaceAndBanner;



//NSUserDefault 缓存
//存
+ (void)cache:(id)dataInfo ForKey:(NSString *)key;
//取
+ (id)cacheForKey:(NSString *)key;



+ (void)showAutoHiddenMBProgressWithText:(NSString *)text addToView:(UIView *)aView;

@end
