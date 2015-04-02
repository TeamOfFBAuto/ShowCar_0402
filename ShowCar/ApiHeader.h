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


//测试用户数据

//    code = 200;
//    token = "lyFRunzs3PaA3CISZS0aaBnqT+dTwf/fgmwmoyWNvQlL4qjs1QOcHf1ot6Dvp8DF7RDf6L/sLQ3Aw1VNNAi6SQ==";
//    userId = 1102017;


//接口======

//案例列表
#define ANLI_LIST @"http://cool.fblife.com/index.php?c=interface&a=getCase&fbtype=json"

//获取收藏案例 &uid=%@&page=%d&ps=%d
#define ANLI_LIST_SHOUCANG @"http://cool.fblife.com/index.php?c=interface&a=getFavCase&fbtype=json"

//获取个人信息 &uid=%@
#define USERINFO @"http://cool.fblife.com/index.php?c=interface&a=getUser&fbtype=json"




#endif
