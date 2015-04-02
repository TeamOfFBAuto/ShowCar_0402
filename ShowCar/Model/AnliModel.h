//
//  AnliModel.h
//  CustomNewProject
//
//  Created by lichaowei on 14/12/2.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "BaseModel.h"

@interface AnliModel : BaseModel

@property (nonatomic,retain)NSString *id;
@property (nonatomic,retain)NSString *uid;
@property (nonatomic,retain)NSString *title;//案例名称
@property (nonatomic,retain)NSString *pichead;//图片路径
@property (nonatomic,retain)NSString *province;
@property (nonatomic,retain)NSString *city;
@property (nonatomic,retain)NSString *brand;
@property (nonatomic,retain)NSString *models;
@property (nonatomic,retain)NSString *dateline;
@property (nonatomic,retain)NSString *sname;//关联店铺名称
@property (nonatomic,retain)NSString *spichead;//关联店铺logo

@property (nonatomic,retain)NSString *com_num;
@property (nonatomic,retain)NSString *content;
@property (nonatomic,retain)NSString *isdel;
@property (nonatomic,retain)NSString *tpltype;//案例类型
@property (nonatomic,retain)NSString *username;


//返回数据(
//id : 案例ID；province:省;city:市;brand:品牌;models:车系; dateline：发布时间；


@end
