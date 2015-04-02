//
//  GMAPI.m
//  FBAuto
//
//  Created by gaomeng on 14-7-3.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GMAPI.h"

@implementation GMAPI




//获取用户的devicetoken

+(NSString *)getDeviceToken{
    
    NSString *str_devicetoken=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:DEVICETOKEN]];
    return str_devicetoken;
    
    
}

//获取用户名
+(NSString *)getUsername{
    
    NSString *str_devicetoken=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USER_NAME]];
    if ([str_devicetoken isEqualToString:@"(null)"]) {
        str_devicetoken=@"";
    }
    return str_devicetoken;
    
    
}

//获取authkey
+(NSString *)getAuthkey{
    
    NSString *str_authkey=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHOD]];
    return str_authkey;
    
}

+(NSString *)getAuthkey_GBK{
    NSString *str_authkey=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHKEY_GBK]];
    return str_authkey;
}


//获取用户id
+(NSString *)getUid{
    
    NSString *str_uid=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USER_UID]];
    return str_uid;
    
}


//获取用户密码
+(NSString *)getUserPassWord{
    NSString *str_password = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USER_PW]];
    return str_password;
}


#pragma mark - 弹出提示框
+ (MBProgressHUD *)showMBProgressWithText:(NSString *)text addToView:(UIView *)aView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 15.f;
    hud.yOffset = 0.0f;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}


//把用户bannerImage写到本地
+(BOOL)setUserBannerImageWithData:(NSData *)data{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathD = paths[0];
    
    NSString *userBannerName = @"/guserBannerImage.png";
    
    NSString *path = [pathD stringByAppendingString:userBannerName];
    
    NSLog(@"%@",path);
    
    
    BOOL is = [data writeToFile:path atomically:YES];
    
    NSLog(@"%d",is);
    
    if (is) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"chagePersonalInformation" object:nil];
        
    }
    
    return is;
}

//把用户头像image写到本地
+(BOOL)setUserFaceImageWithData:(NSData *)data{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathD = paths[0];
    
    NSString *userFaceName = @"/guserFaceImage.png";
    
    NSString *path = [pathD stringByAppendingString:userFaceName];
    
    NSLog(@"%@",path);
    
    BOOL is = [data writeToFile:path atomically:YES];
    NSLog(@"%d",is);
    
    if (is) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"chagePersonalInformation" object:nil];
    }
    
    
    return is;
}

//读数据=============================================


//获取banner
+(UIImage *)getUserBannerImage{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathD = paths[0];
    NSString *userBannerName = @"/guserBannerImage.png";
    NSString *path = [pathD stringByAppendingString:userBannerName];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

//获取faceImage
+(UIImage *)getUserFaceImage{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathD = paths[0];
    NSString *userFaceName = @"/guserFaceImage.png";
    NSString *path = [pathD stringByAppendingString:userFaceName];
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}



+(BOOL)cleanUserFaceAndBanner{
    //上传标志位
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"gIsUpBanner"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"gIsUpFace"];
    
    
    
    //document路径
    NSString *documentPathStr = [GMAPI documentFolder];
    NSString *userFace = @"/guserFaceImage.png";
    NSString *userBanner = @"/guserBannerImage.png";
    
    
    //文件管理器
    NSFileManager *fileM = [NSFileManager defaultManager];
    
    //清除 头像和 banner
    
    BOOL isCleanUserFaceSuccess = NO;
    BOOL isCleanUserBannerSuccess = NO;
    BOOL isSuccess = NO;
    isCleanUserFaceSuccess = [fileM removeItemAtPath:[documentPathStr stringByAppendingString:userFace] error:nil];
    isCleanUserBannerSuccess = [fileM removeItemAtPath:[documentPathStr stringByAppendingString:userBanner] error:nil];
    if (isCleanUserFaceSuccess && isCleanUserBannerSuccess) {
        isSuccess = YES;
    }
    
    return isSuccess;
}


+ (NSString *)documentFolder{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}




#pragma mark - NSUserDefault缓存
//存
+ (void)cache:(id)dataInfo ForKey:(NSString *)key
{
    NSLog(@"key===%@",key);
    @try {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:dataInfo forKey:key];
        [defaults synchronize];
    }
    @catch (NSException *exception) {
        NSLog(@"exception %@",exception);
    }
    @finally {
    }
}

//取
+ (id)cacheForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}


+ (void)showAutoHiddenMBProgressWithText:(NSString *)text addToView:(UIView *)aView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 15.f;
    hud.yOffset = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

@end
