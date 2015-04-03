//
//  AboutViewController.h
//  CustomNewProject
//
//  Created by soulnear on 15-1-21.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

/**
 *  关于我们 页面
 */

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AboutViewController : BaseViewController


@property (strong, nonatomic) IBOutlet UIImageView *logo_imageView;

@property (strong, nonatomic) IBOutlet UILabel *version_label;
///公司信息
@property (strong, nonatomic) IBOutlet UILabel *description_label;
///文字简介
@property (strong, nonatomic) IBOutlet UIImageView *bottom_imageView;

///拨打电话按钮
@property (strong, nonatomic) IBOutlet UIButton *telphone_button;

///聊天按钮
@property (strong, nonatomic) IBOutlet UIButton *talk_button;

///旗下产品按钮
@property (strong, nonatomic) IBOutlet UIButton *more_button;



///打电话
- (IBAction)telphoneTap:(id)sender;
///聊天
- (IBAction)talkTap:(id)sender;
///旗下产品
- (IBAction)moreTap:(id)sender;

@end
