//
//  NewLogInView.h
//  CustomNewProject
//
//  Created by soulnear on 15-1-26.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"
#import "OHLableHelper.h"
//#import "ASIFormDataRequest.h"


@interface NewLogInView : UIView<UITextFieldDelegate,OHAttributedLabelDelegate>
{
    ///登陆返回数据
    NSDictionary * userInfo_dic;
    
    ///提示框
    MBProgressHUD * hud;
    
    ///一成不变的view
    UIView * main_view;
    UIImageView * up_background_imageView;
    UIImageView * bottom_background_view;
    ///登陆界面
    UIButton * loginButton;
    UIButton * zhuce_button;
    UIView * line_view;
    ///输入手机号界面
        //简介
    UIView * phone_jieshao_view;
    UILabel * phone_jieshao_label;
        //获取验证码
    UIButton * get_code_button;
    
    ///输入验证码界面
    UILabel * code_phone_label;
        //完成按钮
    UIButton * code_done_button;
        //再次发送验证码
    UIButton * send_code_again_button;
    UIView * code_line_view;
    
    ///完善个人信息界面
    UIButton * info_done_button;
    UIView * line_view1;
    UIView * line_view2;
    UIButton * xieyi_button;
    OHAttributedLabel * content_label;
    
}

///用户名
@property(nonatomic,strong)UITextField * username_tf;
///密码
@property(nonatomic,strong)UITextField * password_tf;
///邮箱
@property(nonatomic,strong)UITextField * email_tf;
///电话号码
@property(nonatomic,strong)UITextField * phone_tf;
///验证码
@property(nonatomic,strong)UITextField * code_tf;
///完善个人信息
//用户名
@property(nonatomic,strong)UITextField * info_username_tf;
//密码
@property(nonatomic,strong)UITextField * info_password_tf;

+ (id)loginShareInstance;

- (void)showLogin;//显示登录


@end
