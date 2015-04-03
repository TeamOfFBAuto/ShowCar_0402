//
//  PersonalViewController.h
//  ShowCar
//
//  Created by lichaowei on 15/3/31.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

/**
 *  个人中心
 */
#import "BaseViewController.h"

@interface PersonalViewController : BaseViewController

@property(nonatomic,assign)BOOL isOther;//是否是push过来得
@property(nonatomic,retain)NSString *userId;//进入此页用户id

@end
