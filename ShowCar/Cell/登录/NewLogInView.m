//
//  NewLogInView.m
//  CustomNewProject
//
//  Created by soulnear on 15-1-26.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import "NewLogInView.h"
//#import "RCIM.h"
#import "PrivacyPolicyView.h"
///输入手机号码提示介绍
#define INPUT_PHONE_NUM_TEXT @"如果您要注册,我们通过验证手机号码为您发一个清晰的编码"
///输入验证码提示介绍
#define INPUT_CODE_NUM_TEXT @"我们通过以下手机号码发送了短信请输入完成验证。"

///颜色
#define TEXT_COLOR RGBCOLOR(127,127,127)
///线的颜色
#define LINE_BACKGROUND_COLOR RGBCOLOR(146,146,146)
///输入框高度
#define TEXTFIELD_HEIGHT 57
///按钮高度
#define BUTTON_HEIGHT 38

///数据统计该类代表的数字
///登陆：12 注册：13 获取验证码：14 完善个人信息：15


@implementation NewLogInView
{
    PrivacyPolicyView * ppv;
}



-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIView * aView = [[UIView alloc] initWithFrame:self.bounds];
        aView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self addSubview:aView];
        
        [self setup];
        
        [self createLoginView];
    }
    return self;
}

///创建视图
-(void)setup
{
    float main_view_width = 300*DEVICE_WIDTH/414;
    ///背景图
    main_view = [[UIView alloc] initWithFrame:CGRectMake((DEVICE_WIDTH-main_view_width)/2.0f,0,main_view_width,290)];
    main_view.backgroundColor = [UIColor clearColor];
    main_view.clipsToBounds = YES;
    main_view.center = CGPointMake(main_view.center.x,DEVICE_HEIGHT/2.0f);
    [self addSubview:main_view];
    
    ///顶部logo
    up_background_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,main_view.width,71)];
    up_background_imageView.image = [[UIImage imageNamed:@"Loginview_up_background_image"] stretchableImageWithLeftCapWidth:413/2.0/2.0 topCapHeight:71/2.0];
    up_background_imageView.userInteractionEnabled = YES;
    [main_view addSubview:up_background_imageView];
    
    UIImageView * logo_imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginview_logo_image"]];
    logo_imageView.center = CGPointMake(up_background_imageView.width/2.0f,up_background_imageView.height/2.0f);
    [up_background_imageView addSubview:logo_imageView];
    
    ///关闭按钮
    UIButton * close_button = [UIButton buttonWithType:UIButtonTypeCustom];
    close_button.frame = CGRectMake(main_view.width-40,0,40,40);
    [close_button setImage:[UIImage imageNamed:@"LogInView_close"] forState:UIControlStateNormal];
    [close_button addTarget:self action:@selector(closeTap:) forControlEvents:UIControlEventTouchUpInside];
    [main_view addSubview:close_button];
    
    ///底部视图
    bottom_background_view = [[UIImageView alloc] initWithFrame:CGRectMake(0,up_background_imageView.bottom,main_view.width,[self returnAdaptHeightWithPlusHeight:103])];
    bottom_background_view.image = [UIImage imageNamed:@"loginview_bottom_background_image"];
    bottom_background_view.userInteractionEnabled = YES;
    [main_view addSubview:bottom_background_view];
}

#pragma mark - 创建登陆视图
-(void)createLoginView
{
    if (_info_username_tf)
    {
        _info_username_tf.left = -_info_username_tf.width;
        _info_password_tf.left = -_info_password_tf.width;
        line_view.left = -line_view.width;
        line_view1.left = -line_view1.width;
        line_view2.left = -line_view2.width;
        xieyi_button.left = -xieyi_button.width;
        _email_tf.left = -_email_tf.width;
        content_label.left = -content_label.width;
        info_done_button.left = -info_done_button.width;
        phone_jieshao_view.left = -phone_jieshao_view.width;
        
        [UIView beginAnimations:@"animation" context:@"context"];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:main_view cache:YES];
        [UIView commitAnimations];
    }
    
    
    
    if (!loginButton)
    {
        ///登陆按钮
        loginButton = [self createButtonWithFrame:CGRectMake(10,13,main_view.width-20,BUTTON_HEIGHT) WithTitle:@"登录" WithTag:100];
        [bottom_background_view addSubview:loginButton];
        
        ///注册按钮
        zhuce_button = [UIButton buttonWithType:UIButtonTypeCustom];
        zhuce_button.frame = loginButton.frame;
        zhuce_button.tag = 99;
        zhuce_button.top = loginButton.bottom + 10;
        zhuce_button.height = 20;
        zhuce_button.backgroundColor = [UIColor clearColor];
        [zhuce_button setTitle:@"创建一个新账号>>" forState:UIControlStateNormal];
        [zhuce_button setTitleColor:RGBCOLOR(142,142,142) forState:UIControlStateNormal];
        zhuce_button.titleLabel.font = [UIFont systemFontOfSize:13];
        [zhuce_button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        [bottom_background_view addSubview:zhuce_button];
        
        
        _username_tf = [self createTextFieldWithPlaceHolder:@"用户名" WithFrame:CGRectMake(0,up_background_imageView.bottom,main_view.width,TEXTFIELD_HEIGHT)];
        _username_tf.leftView.width = 45;
        
        line_view = [[UIView alloc] initWithFrame:CGRectMake(0,_username_tf.bottom-0.5,main_view.width,0.5)];
        line_view.backgroundColor = LINE_BACKGROUND_COLOR;
        
        _password_tf = [self createTextFieldWithPlaceHolder:@"密码" WithFrame:CGRectMake(0,line_view.bottom,main_view.width,TEXTFIELD_HEIGHT)];
        _password_tf.secureTextEntry = YES;
        _password_tf.leftView.width = 45;
        
        
        
        UIImageView * userName_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginView_username_image"]];
        userName_image.center = CGPointMake(userName_image.image.size.width/2.0+10,_username_tf.height/2.0f);
        [_username_tf addSubview:userName_image];
        
        UIImageView * password_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginView_password_image"]];
        password_image.center = CGPointMake(password_image.image.size.width/2.0+10,_password_tf.height/2.0f);
        [_password_tf addSubview:password_image];
        
        
        [main_view addSubview:_username_tf];
        [main_view addSubview:line_view];
        [main_view addSubview:_password_tf];
    }
    
    
    _username_tf.text = _info_username_tf.text;
    _password_tf.text = _info_password_tf.text;
   
    loginButton.left = 10;
    zhuce_button.left = loginButton.left;
    zhuce_button.top = loginButton.bottom + 10;
    zhuce_button.height = 20;
    _username_tf.left = 0;
    line_view.left = 0;
    _password_tf.left = 0;
    
    
    bottom_background_view.top = _password_tf.bottom-1;
    bottom_background_view.height = zhuce_button.bottom + 10;
    main_view.height = bottom_background_view.bottom;
    [UIView animateWithDuration:0.3 animations:^{
        main_view.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 创建输入手机号码界面
-(void)createPhoneView
{
    if (!_phone_tf) {
        phone_jieshao_view = [[UIView alloc] initWithFrame:CGRectMake(up_background_imageView.width,up_background_imageView.bottom,up_background_imageView.width,50)];
        phone_jieshao_view.backgroundColor = [UIColor whiteColor];
        [main_view addSubview:phone_jieshao_view];
        
        phone_jieshao_label = [[UILabel alloc] initWithFrame:CGRectMake(15,0,phone_jieshao_view.width-30,50)];
        phone_jieshao_label.numberOfLines = 0;
        phone_jieshao_label.text = INPUT_PHONE_NUM_TEXT;
        phone_jieshao_label.textAlignment = NSTextAlignmentLeft;
        phone_jieshao_label.textColor = RGBCOLOR(90, 90, 90);
        phone_jieshao_label.font = [UIFont systemFontOfSize:12];
        [phone_jieshao_view  addSubview:phone_jieshao_label];
        
        _phone_tf = [self createTextFieldWithPlaceHolder:@"手机号码" WithFrame:CGRectMake(up_background_imageView.width,phone_jieshao_view.bottom,main_view.width,TEXTFIELD_HEIGHT)];
        _phone_tf.leftView.width = 80;
        [main_view addSubview:_phone_tf];
        
        ///前边介绍“中国 +86”
        UILabel * font_label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,80,_phone_tf.height)];
        font_label.text = @"中国 +86";
        font_label.textAlignment = NSTextAlignmentCenter;
        font_label.textColor = RGBCOLOR(3,3,3);
        font_label.font = [UIFont systemFontOfSize:16];
        [_phone_tf addSubview:font_label];
        
        
        
        get_code_button = [self createButtonWithFrame:CGRectMake(10,main_view.height,main_view.width-20,29) WithTitle:@"获取验证码" WithTag:101];
        [bottom_background_view addSubview:get_code_button];

    }
    
    
    get_code_button.left = 10;
    
//    [UIView animateWithDuration:0.3 animations:^{
        _username_tf.left = -_username_tf.width;
        _password_tf.left = -_password_tf.width;
        loginButton.left = -loginButton.width;
        zhuce_button.alpha = -zhuce_button.width;
        bottom_background_view.top = _phone_tf.bottom-1;
        bottom_background_view.height = 54;
        phone_jieshao_view.left = 0;
        _phone_tf.left = 0;
        get_code_button.top = 12.5;
        line_view.left = - line_view.width;
        bottom_background_view.height = get_code_button.bottom + 10;
        main_view.height = bottom_background_view.bottom;
//    } completion:^(BOOL finished) {
//        
//    }];
    
    [self animationForRotation];
}

#pragma mark - 创建输入手机验证码界面
-(void)createCodeView
{
    if (!_code_tf)
    {
        code_phone_label = [[UILabel alloc] initWithFrame:CGRectMake(main_view.width,phone_jieshao_view.bottom,main_view.width,TEXTFIELD_HEIGHT)];
        code_phone_label.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        code_phone_label.text = [NSString stringWithFormat:@"+86%@",_phone_tf.text];
        code_phone_label.textAlignment = NSTextAlignmentCenter;
        code_phone_label.textColor = TEXT_COLOR;
        code_phone_label.font = [UIFont systemFontOfSize:14];
        [main_view addSubview:code_phone_label];
        
        code_line_view = [[UIView alloc] initWithFrame:CGRectMake(0,code_phone_label.bottom-0.5,main_view.width,0.5)];
        code_line_view.backgroundColor = LINE_BACKGROUND_COLOR;
        [main_view addSubview:code_line_view];
        
        _code_tf = [self createTextFieldWithPlaceHolder:@"请输入验证码" WithFrame:CGRectMake(main_view.width,code_line_view.bottom,main_view.width,TEXTFIELD_HEIGHT)];
        _code_tf.textAlignment = NSTextAlignmentCenter;
        [main_view addSubview:_code_tf];
        
        
        code_done_button = [self createButtonWithFrame:CGRectMake(main_view.width,10,main_view.width-20,29) WithTitle:@"完成" WithTag:102];
        [bottom_background_view addSubview:code_done_button];
        
        send_code_again_button = [UIButton buttonWithType:UIButtonTypeCustom];
        send_code_again_button.frame = code_done_button.frame;
        send_code_again_button.tag = 103;
        send_code_again_button.top = code_done_button.bottom + 5;
        [send_code_again_button setTitle:@"再次发送编码" forState:UIControlStateNormal];
        send_code_again_button.titleLabel.font = [UIFont systemFontOfSize:12];
        [send_code_again_button setTitleColor:RGBCOLOR(255,180,0) forState:UIControlStateNormal];
        [send_code_again_button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        [bottom_background_view addSubview:send_code_again_button];
    }
    
    code_line_view.left = 0;
    _code_tf.left = 0;
    
    
    
//    [UIView animateWithDuration:0.3 animations:^{
        _phone_tf.left = -_phone_tf.width;
        bottom_background_view.height = send_code_again_button.bottom + 10;
        bottom_background_view.top = _code_tf.bottom-1;
        get_code_button.left = -get_code_button.width;
        
        code_done_button.left = 10;
        send_code_again_button.left = 10;
        code_phone_label.left = 0;
        _code_tf.left = 0;
        
        main_view.height = bottom_background_view.bottom;
        
        
//    } completion:^(BOOL finished) {
//        
//    }];
    
    [self animationForRotation];
}


#pragma mark - 创建完善资料界面
-(void)createInfomationView
{
    phone_jieshao_view.height = 32;
    phone_jieshao_label.height = 32;
    
    _code_tf.left = -_code_tf.width;
    code_phone_label.left = -code_phone_label.width;
    code_done_button.left = -code_done_button.width;
    send_code_again_button.left = -send_code_again_button.width;
    code_line_view.left = -code_line_view.width;
    phone_jieshao_label.text = @"请完善好个人资料";
    phone_jieshao_label.textAlignment = NSTextAlignmentCenter;
    
    
    if (!_info_username_tf) {
        _info_username_tf = [self createTextFieldWithPlaceHolder:@"用户名" WithFrame:CGRectMake(0,phone_jieshao_view.bottom,main_view.width,TEXTFIELD_HEIGHT)];
        [main_view addSubview:_info_username_tf];
        
        line_view1 = [[UIView alloc] initWithFrame:CGRectMake(0,_info_username_tf.bottom-0.5,main_view.width,0.5)];
        line_view1.backgroundColor = LINE_BACKGROUND_COLOR;
        [main_view addSubview:line_view1];
        
        _info_password_tf = [self createTextFieldWithPlaceHolder:@"密码" WithFrame:CGRectMake(0,line_view1.bottom,main_view.width,TEXTFIELD_HEIGHT)];
        _info_password_tf.secureTextEntry = YES;
        [main_view addSubview:_info_password_tf];
        
        line_view2 = [[UIView alloc] initWithFrame:CGRectMake(0,_info_password_tf.bottom-0.5,main_view.width,0.5)];
        line_view2.backgroundColor = LINE_BACKGROUND_COLOR;
        [main_view addSubview:line_view2];
        
        _email_tf = [self createTextFieldWithPlaceHolder:@"电子邮箱" WithFrame:CGRectMake(0,line_view2.bottom,main_view.width,TEXTFIELD_HEIGHT)];
        [main_view addSubview:_email_tf];
        
        info_done_button = [self createButtonWithFrame:CGRectMake(10,50,main_view.width-20,29) WithTitle:@"完成" WithTag:104];
        [bottom_background_view addSubview:info_done_button];
        
        
        xieyi_button = [UIButton buttonWithType:UIButtonTypeCustom];
        xieyi_button.frame = CGRectMake(10,5,28,30);
        [xieyi_button setImage:[UIImage imageNamed:@"login_agree_xieyi_image"] forState:UIControlStateNormal];
        [xieyi_button setImage:[UIImage imageNamed:@"login_unagree_xieyi_image"] forState:UIControlStateSelected];
        [xieyi_button addTarget:self action:@selector(xieyibuttonTap:) forControlEvents:UIControlEventTouchUpInside];
        [bottom_background_view addSubview:xieyi_button];
        
        
        CGRect content_frame = CGRectMake(40,12,200,30);
        content_label = [[OHAttributedLabel alloc] initWithFrame:content_frame];
        content_label.textColor = [UIColor blackColor];
        content_label.font = [UIFont systemFontOfSize:14];
        [bottom_background_view addSubview:content_label];
        
        NSString * content_string = @"我接受\n用户协议并且隐私政策的条件";
        [OHLableHelper creatAttributedText:content_string Label:content_label OHDelegate:self WithWidht:16 WithHeight:18 WithLineBreak:NO];
        
        [content_label addCustomLink:[NSURL URLWithString:@"用户协议"] inRange:[content_string rangeOfString:@"用户协议"]];
        [content_label addCustomLink:[NSURL URLWithString:@"隐私政策的条件的条件"] inRange:[content_string rangeOfString:@"隐私政策"]];
    }
    
    _info_username_tf.left = 0;
    _info_password_tf.left = 0;
    _email_tf.left = 0;
    line_view1.left = 0;
    line_view2.left = 0;
    xieyi_button.left = 10;
    content_label.left = 40;
    info_done_button.left = 10;
    
    
    
    bottom_background_view.top = _email_tf.bottom-1;
    bottom_background_view.height = info_done_button.bottom + 10;
    
    main_view.height = bottom_background_view.bottom + 10;
    
    [self animationForRotation];
}



///创建输入框
-(UITextField *)createTextFieldWithPlaceHolder:(NSString *)placeHolder WithFrame:(CGRect)frame
{
    UITextField * textField = [[UITextField alloc] initWithFrame:frame];
    textField.height = [self returnAdaptHeightWithPlusHeight:TEXTFIELD_HEIGHT];
    textField.textColor = TEXT_COLOR;
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:16];
    textField.placeholder = placeHolder;
    textField.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    
    UIView *userNameview = [[UIView alloc] initWithFrame:CGRectMake(0, 0,8,8)];
    userNameview.userInteractionEnabled = NO;
    textField.leftView = userNameview;
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
}
///创建确认按钮
-(UIButton *)createButtonWithFrame:(CGRect)frame WithTitle:(NSString *)aTitle WithTag:(int)aTag
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = aTag;
    button.height = [self returnAdaptHeightWithPlusHeight:BUTTON_HEIGHT];
    button.backgroundColor = RGBCOLOR(255,180,0);
    [button setTitle:aTitle forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.layer.cornerRadius = 3;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (main_view.bottom > DEVICE_HEIGHT - 250)
    {
        [self setMainViewUp:YES];
    }
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self setMainViewUp:NO];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - OHAttributeDelegate
-(BOOL)attributedLabel:(OHAttributedLabel*)attributedLabel shouldFollowLink:(NSTextCheckingResult*)linkInfo
{
    [self setMainViewUp:NO];
    [self endEditing:YES];
    
    ppv = [[PrivacyPolicyView alloc] initWithFrame:CGRectMake(10,20,DEVICE_WIDTH-20,DEVICE_HEIGHT-40)];
    ppv.alpha = 0;
    ppv.backgroundColor = [UIColor whiteColor];
    ppv.layer.cornerRadius = 3;
    ppv.layer.masksToBounds = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:ppv];
    
    [UIView animateWithDuration:0.4 animations:^{
        ppv.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    return YES;
}



-(UIColor*)colorForLink:(NSTextCheckingResult*)linkInfo underlineStyle:(int32_t*)underlineStyle
{
    return RGBCOLOR(255,180,0);
}

#pragma mark - 点击协议按钮
-(void)xieyibuttonTap:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected)
    {
        info_done_button.userInteractionEnabled = NO;
        info_done_button.backgroundColor = RGBCOLOR(230,230,230);
    }else
    {
        info_done_button.userInteractionEnabled = YES;
        info_done_button.backgroundColor = RGBCOLOR(255,180,0);
    }
}

#pragma mark - 完成按钮
-(void)buttonTap:(UIButton *)button
{
    switch (button.tag) {
        case 99:///注册按钮
        {
            [self createPhoneView];
        }
            break;
        case 100:///登陆按钮
        {
            [self endEditing:YES];
            [self setMainViewUp:NO];
            [self networkForLogIn];
        }
            break;
        case 101:///获取验证码
        {
//            [self createCodeView];
            [self networkSendCode];
        }
            break;
        case 102:///验证验证码是否正确
        {
            
//            [self createInfomationView];
            if (_code_tf.text.length != 0) {
                [self networkYanZhengCode];
            }else
            {
                [LTools showMBProgressWithText:@"请输入验证码"  addToView:self];
            }
        }
            break;
        case 103:///再次获取验证码
        {
            [self networkSendCode];
        }
            break;
        case 104:///提交注册信息进行注册
        {
            [self endEditing:YES];
            [self setMainViewUp:NO];
            [self networkZhuCe];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 旋转动画
-(void)animationForRotation
{
    [UIView beginAnimations:@"animation" context:@"context"];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:main_view cache:YES];
    [UIView commitAnimations];
}

#pragma mark - 左右抖动动画
- (void)shakeAction
{
    // 晃动次数
    static int numberOfShakes = 4;
    // 晃动幅度（相对于总宽度）
    static float vigourOfShake = 0.04f;
    // 晃动延续时常（秒）
    static float durationOfShake = 0.5f;
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    // 方法一：绘制路径
    CGRect frame = main_view.frame;
    // 创建路径
    CGMutablePathRef shakePath = CGPathCreateMutable();
    // 起始点
    CGPathMoveToPoint(shakePath, NULL, CGRectGetMidX(frame), CGRectGetMidY(frame));
    for (int index = 0; index < numberOfShakes; index++)
    {
        // 添加晃动路径 幅度由大变小
        CGPathAddLineToPoint(shakePath, NULL, CGRectGetMidX(frame) - frame.size.width * vigourOfShake*(1-(float)index/numberOfShakes),CGRectGetMidY(frame));
        CGPathAddLineToPoint(shakePath, NULL,  CGRectGetMidX(frame) + frame.size.width * vigourOfShake*(1-(float)index/numberOfShakes),CGRectGetMidY(frame));
    }
    // 闭合
    CGPathCloseSubpath(shakePath);
    shakeAnimation.path = shakePath;
    shakeAnimation.duration = durationOfShake;
    // 释放
    CFRelease(shakePath);

    [main_view.layer addAnimation:shakeAnimation forKey:kCATransition];
}


#pragma mark - 关闭按钮操作
-(void)closeTap:(UIButton *)button
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 弹出键盘上移视图
-(void)setMainViewUp:(BOOL)isUp
{
    [UIView animateWithDuration:0.3 animations:^{
        main_view.top = isUp?(DEVICE_HEIGHT-250-main_view.height):(DEVICE_HEIGHT/2.0-(main_view.height/2.0));
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark - 返回适配后的高度
-(CGFloat)returnAdaptHeightWithPlusHeight:(CGFloat)aHeight
{
    return aHeight*DEVICE_HEIGHT/736;
}
#pragma mark - 返回适配后的宽度
-(CGFloat)returnAdaptWidthWithPlusWidth:(CGFloat)aWidht
{
    return aWidht*DEVICE_WIDTH/414;
}

#pragma mark - 网络请求
///获取验证码
-(void)networkSendCode
{
    if (_phone_tf.text.length != 11) {
        [LTools showMBProgressWithText:@"请输入正确的手机号码" addToView:self];
        return;
    }
    
    MBProgressHUD * code_hud = [LTools MBProgressWithText:@"正在发送..." addToView:self];
    
    NSString * fullUrl = [NSString stringWithFormat:SENDPHONENUMBER,_phone_tf.text];
    
    AFHTTPRequestOperation * request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]]];
    __weak typeof(self)bself = self;
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * data_dic = [operation.responseData objectFromJSONData];
        
        NSString * errcode = [NSString stringWithFormat:@"%@",[data_dic objectForKey:@"errcode"]];
        
        NSString * bbsinfo = [NSString stringWithFormat:@"%@",[data_dic objectForKey:@"bbsinfo"]];
        
        NSLog(@"bbsinfo -----  %@",bbsinfo);
        [code_hud hide:YES];
        if ([errcode intValue] == 0)
        {
            [bself createCodeView];
//            VerificationViewController * verification = [[VerificationViewController alloc] init];
//            verification.MyPhoneNumber = phone_textField.text;
//            [self.navigationController pushViewController:verification animated:YES];
        }else
        {
//            [LTools showAutoHiddenMBProgressWithText:bbsinfo addToView:self];
            [LTools MBProgressWithText:bbsinfo addToView:self];
            
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:bbsinfo message:@"" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
//            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [request start];

}

///验证验证码是否正确
-(void)networkYanZhengCode
{
    if (_code_tf.text.length == 0) {
        [LTools MBProgressWithText:@"请输入验证码" addToView:self];
        return;
    }
    
    MBProgressHUD * aHud = [LTools MBProgressWithText:@"正在验证..." addToView:self];
    
    NSString * fullUrl = [NSString stringWithFormat:SENDERVerification,_phone_tf.text,_code_tf.text];

    AFHTTPRequestOperation * request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]]];
    __weak typeof(self) bself = self;
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [aHud hide:YES];
        
        NSDictionary * data_dic = [operation.responseData objectFromJSONData];
        
        NSString * errcode = [NSString stringWithFormat:@"%@",[data_dic objectForKey:@"errcode"]]
        ;
        
        NSString * bbsinfo = [NSString stringWithFormat:@"%@",[data_dic objectForKey:@"bbsinfo"]];

        if ([errcode intValue] == 0)
        {
            [bself createInfomationView];
            
//            ZhuCeViewController * zhuce = [[ZhuCeViewController alloc] init];
//            zhuce.PhoneNumber = self.MyPhoneNumber;
//            zhuce.verification = verification_tf.text;
//            [self.navigationController pushViewController:zhuce animated:YES];
        }else
        {
            [LTools MBProgressWithText:bbsinfo addToView:self];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [aHud hide:YES];
        [LTools showMBProgressWithText:@"验证失败，请检查您当前网络" addToView:self];
    }];
    
    [request start];
}


- (void)networkForAnliList:(int)pageNum
{
    
    NSString *baseurl = ANLI_LIST;
    
    NSDictionary *params = @{
                             @"page":[NSNumber numberWithInt:pageNum],
                             @"ps":[NSNumber numberWithInt:10],
                             @"ordertype":[NSNumber numberWithInt:1],
                             @"id":[NSNumber numberWithInt:0]
                             };
    
    [LTools getRequestWithBaseUrl:baseurl parameters:params completion:^(NSDictionary *result, NSError *erro){
        
        
        
    } failBlock:^(NSDictionary *result, NSError *erro) {
        
    }];
    
    
}

///完善个人资料完成，去注册
-(void)networkZhuCe
{
    if (_info_username_tf.text.length == 0) {
        [LTools showMBProgressWithText:@"用户名不能为空" addToView:self];
        return;
    }
    
    if (_info_password_tf.text.length == 0) {
        [LTools showMBProgressWithText:@"密码不能为空" addToView:self];
        return;
    }
    
    if (_email_tf.text.length == 0 || ![LTools isValidateEmail:_email_tf.text]) {
        [LTools showMBProgressWithText:@"请输入正确的邮箱地址" addToView:self];
        return;
    }
    
    hud = [LTools MBProgressWithText:@"正在注册..." addToView:self];

    
    NSString *baseurl = REGISTER;
    
    NSDictionary *params = @{
                             @"telphone":self.phone_tf.text,
                             @"telcode":self.code_tf.text,
                             @"username":_info_username_tf.text,
                             @"password":_info_password_tf.text,
                             @"":_email_tf.text
                             };
    
    __weak typeof(self)weakSelf = self;
    [LTools getRequestWithBaseUrl:baseurl parameters:params completion:^(NSDictionary *result, NSError *erro){
        [weakSelf requestFinishedWithResultDic:result];
        
        
    } failBlock:^(NSDictionary *result, NSError *erro) {
        
        [hud hide:YES];
        
        [LTools showMBProgressWithText:@"注册失败,请检查当前网络" addToView:self];
    }];
    
}


-(void)requestFinishedWithResultDic:(NSDictionary *)data_dic
{
    [hud hide:YES];
    
    NSString * errcode = [NSString stringWithFormat:@"%@",[data_dic objectForKey:@"errcode"]]
    ;
    
    NSString * bbsinfo = [NSString stringWithFormat:@"%@",[data_dic objectForKey:@"bbsinfo"]];
    
    if ([errcode intValue] == 0)
    {
        [LTools showMBProgressWithText:@"注册成功" addToView:self];
        
        _username_tf.text = _info_username_tf.text;
        _password_tf.text = _info_password_tf.text;
        
        [self endEditing:YES];
        [self setMainViewUp:NO];
        
        [self createLoginView];
        [self networkForLogIn];
        
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:bbsinfo message:@"" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
        [alert show];
    }
}



///登陆
-(void)networkForLogIn
{
    
    if (_username_tf.text.length == 0) {
        [LTools showMBProgressWithText:@"用户名不能为空" addToView:self];
        return;
    }else if (_password_tf.text.length == 0)
    {
        [LTools showMBProgressWithText:@"密码不能为空" addToView:self];
        return;
    }
    
    loginButton.userInteractionEnabled = NO;
    
    hud = [LTools MBProgressWithText:@"登录中..." addToView:self];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    //登录接口
    
    NSString *deviceToken = [GMAPI getDeviceToken] ? [GMAPI getDeviceToken] : @"testToken";
    
    NSString *post = [NSString stringWithFormat:@"&username=%@&password=%@&token=%@",_username_tf.text,_password_tf.text,deviceToken];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    LTools *tool = [[LTools alloc]initWithUrl:LOGIN isPost:YES postData:postData];
    
    __weak typeof(self)bself = self;
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"登录成功:%@",result);
        
        if ([[result objectForKey:@"errcode"] intValue] == 0) {//登录成功
            
            
            NSDictionary *datainfo = [result objectForKey:@"datainfo"];
            NSString *userid = [datainfo objectForKey:@"uid"];
            NSString *username = [datainfo objectForKey:@"username"];
            NSString *authkey = [datainfo objectForKey:@"authkey"];
            NSString *authkey_gbk = [datainfo objectForKey:@"authkey_gbk"];
            [GMAPI cache:userid ForKey:USER_UID];
            [GMAPI cache:username ForKey:USER_NAME];
            [GMAPI cache:authkey ForKey:USER_AUTHOD];
            [GMAPI cache:authkey_gbk ForKey:USER_AUTHKEY_GBK];
            userInfo_dic = [NSDictionary dictionaryWithDictionary:result];
            
            ///验证是否开通fb
//            [bself checkFBState];
            
            [bself getRoncloudLoginToken];
            
        }else
        {
            loginButton.userInteractionEnabled = YES;
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"登陆失败";
            [hud hide:YES afterDelay:2.0f];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:USER_IN];
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro)
    {
        [hud hide:YES];
        loginButton.userInteractionEnabled = YES;
        [LTools showMBProgressWithText:[failDic objectForKey:@"ERRO_INFO"] addToView:self];
        
        if ([[failDic objectForKey:@"ERRO_INFO"] isEqualToString:@"用户名或密码错误"]) {
            [bself shakeAction];
        }
        
        NSLog(@"登录失败:%@",[failDic objectForKey:@"ERRO_INFO"]);
    }];

}

#pragma mark - 获取融云loginToken

- (void)getRoncloudLoginToken
{
//    NSString *userId = [GMAPI getUid];
//    NSString *userName = [GMAPI getUsername];
//    NSString *headImage = [LTools returnMiddleUrl:[GMAPI getUid]];
//    
//    NSString *url = [NSString stringWithFormat:RONCLOUD_GET_TOKEN,userId,userName,headImage];
//    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
//    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
//        
//        NSLog(@"result %@",result);
//        
//        [LTools cache:result[@"token"] ForKey:RONGCLOUD_TOKEN];
//        
//        [self rongCloudDefaultLoginWithToken:result[@"token"]];
//        
//        
//    } failBlock:^(NSDictionary *result, NSError *erro) {
//        [hud hide:YES];
//        loginButton.userInteractionEnabled = YES;
//        NSLog(@"获取融云token失败 %@",result);
//        
//        [LTools showMBProgressWithText:result[ERROR_INFO] addToView:self];
//    }];
}

- (void)rongCloudDefaultLoginWithToken:(NSString *)loginToken
{
    
    //默认测试
    
//    if (loginToken.length > 0) {
//        
//        
//        __weak typeof(self)weakSelf = self;
//        [RCIM connectWithToken:loginToken completion:^(NSString *userId) {
//            [hud hide:YES];
//            loginButton.userInteractionEnabled = YES;
//            NSLog(@"------> rongCloud 登陆成功 %@",userId);
//            
//            [weakSelf saveUserInfomation];
//            
//        } error:^(RCConnectErrorCode status) {
//            [hud hide:YES];
//            NSLog(@"------> rongCloud 登陆失败 %d",(int)status);
//            loginButton.userInteractionEnabled = YES;
//            [LTools showMBProgressWithText:@"rongCloud登录失败" addToView:self];
//        }];
//    }
}


#pragma mark - 登陆成功保存用户信息
-(void)saveUserInfomation
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USER_IN];
    
    NSDictionary *datainfo = [userInfo_dic objectForKey:@"datainfo"];
    NSString *userid = [datainfo objectForKey:@"uid"];
    NSString *username = [datainfo objectForKey:@"username"];
    NSString *authkey = [datainfo objectForKey:@"authkey"];
    [LTools cache:userid ForKey:USER_UID];
    [LTools cache:username ForKey:USER_NAME];
    [LTools cache:authkey ForKey:USER_AUTHOD];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"gdengluchenggong" object:nil];
    
    [self closeTap:nil];
}





@end




















