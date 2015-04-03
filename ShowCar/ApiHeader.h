//
//  ApiHeader.h
//  ShowCar
//
//  Created by lichaowei on 15/3/27.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#ifndef ShowCar_ApiHeader_h
#define ShowCar_ApiHeader_h

#pragma mark - 自定义的宏，方便调动
///颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]

//随机颜色
#define RGBCOLOR_ONE RGBCOLOR(arc4random()%255, arc4random()%255, arc4random()%255)


//app当前版本
#define NOW_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//=============== 标识宏定义 =======================

#define MY_MACRO_NAME ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)


#define USER_IN @"user_in" //0是未登陆  1是已登陆
#define USER_NAME @"username"
#define USER_PW @"userPw"
#define USER_UID @"useruid"
#define USER_AUTHOD @"user_authod"
#define USER_AUTHKEY_GBK @"authkey_gbk"

#define DEVICETOKEN @"pushdevicetoken"


#define NOTIFICATION_LOGIN_SUCCESS @"login_success"//登录成功通知

#define NOTIFICATION_LOGOUT @"logout"//退出登录通知

#define RONGCLOUD_LOGIN_STATE @"rongcloudLoginState"
#define RONGCLOUD_TOKEN @"rongcloudToken"//融云token

//token
#define RONCLOUD_GET_TOKEN @"http://cool.fblife.com/gettoken.php?uid=%@&name=%@&photo=%@"//获取融云 token


//接口======

//案例列表
#define ANLI_LIST @"http://cool.fblife.com/index.php?c=interface&a=getCase&fbtype=json"

//获取收藏案例 &uid=%@&page=%d&ps=%d
#define ANLI_LIST_SHOUCANG @"http://cool.fblife.com/index.php?c=interface&a=getFavCase&fbtype=json"

//获取个人信息 &uid=%@
#define USERINFO @"http://cool.fblife.com/index.php?c=interface&a=getUser&fbtype=json"


//登录
#define LOGIN @"http://cool.fblife.com/index.php?c=interface&a=dologin&fbtype=json"

//注册
#define SENDPHONENUMBER @"http://bbs.fblife.com/bbsapinew/register.php?type=phone&step=1&telphone=%@&keycode=e2e3420683&datatype=json"
#define SENDERVerification @"http://bbs.fblife.com/bbsapinew/register.php?type=phone&step=2&telphone=%@&telcode=%@&datatype=json"
#define SENDUSERINFO @"http://bbs.fblife.com/bbsapinew/register.php?type=phone&step=3&telphone=%@&telcode=%@&username=%@&password=%@&email=%@&datatype=json"

#define REGISTER @"http://bbs.fblife.com/bbsapinew/register.php?type=phone&step=3&datatype=json"


#endif
