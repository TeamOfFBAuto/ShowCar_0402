//
//  AboutViewController.m
//  CustomNewProject
//
//  Created by soulnear on 15-1-21.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()<UIAlertViewDelegate>

@end

@implementation AboutViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    self.navigationController.navigationBarHidden = NO;
}

-(void)back:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setNavgationView
{
    //    UIImageView * navigation_view = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,64)];
    //    navigation_view.image = [UIImage imageNamed:@"default_navigation_clear_image"];
    //    [self.view addSubview:navigation_view];
    //    navigation_view.userInteractionEnabled = YES;
    //    [self.view bringSubviewToFront:navigation_view];
    
    
    UIButton * back_button = [UIButton buttonWithType:UIButtonTypeCustom];
    back_button.frame = CGRectMake(2,0,38.5,39.5);
    [back_button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [back_button setImage:DEFAULT_IMAGE_BACK forState:UIControlStateNormal];
    [self.view addSubview:back_button];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTitle = @"关于";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _logo_imageView.top = 80*DEVICE_HEIGHT/736;
    _logo_imageView.width = 150*DEVICE_HEIGHT/736;
    _logo_imageView.height = _logo_imageView.width;
    _logo_imageView.center = CGPointMake(DEVICE_WIDTH/2,_logo_imageView.center.y);
    
    _version_label.top = _logo_imageView.bottom + 5;
    _version_label.center = CGPointMake(DEVICE_WIDTH/2.0,_version_label.center.y);
    
    
    UIImage * jiajie_image = [UIImage imageNamed:@"about_jieshao_image.png"];
    _bottom_imageView.image = jiajie_image;
    
    _bottom_imageView.top = _version_label.bottom + (30*DEVICE_HEIGHT/736);
    _bottom_imageView.width = jiajie_image.size.width*DEVICE_HEIGHT/736;
    _bottom_imageView.height = jiajie_image.size.height*DEVICE_HEIGHT/736;
    _bottom_imageView.center = CGPointMake(DEVICE_WIDTH/2.0f,_bottom_imageView.center.y);
    
    
    _more_button.top = DEVICE_HEIGHT-40;
    _more_button.center = CGPointMake(DEVICE_WIDTH/2,_more_button.centerY);
    
    _description_label.top = _more_button.bottom;
    _description_label.center = CGPointMake(DEVICE_WIDTH/2.0,_description_label.center.y);
    
    
    _telphone_button.width = 70*DEVICE_HEIGHT/736;
    _telphone_button.height = _telphone_button.width;
    
    _talk_button.width = _telphone_button.width;
    _talk_button.height = _telphone_button.width;
    
    _telphone_button.left = _bottom_imageView.left;
    _telphone_button.center = CGPointMake(_telphone_button.centerX,(_more_button.top - _bottom_imageView.bottom)/2 + _bottom_imageView.bottom);
    
    _talk_button.right = _bottom_imageView.right;
    _talk_button.center = CGPointMake(_talk_button.centerX,_telphone_button.centerY);
    
    
    
    NSString * string = [_description_label.text stringByReplacingOccurrencesOfString:@"2012" withString:[self returnCurrentYear]];
    _description_label.text = string;
    
    _version_label.text = [NSString stringWithFormat:@"Ver %@ 版本",NOW_VERSION];
    
    [self setNavgationView];
}

#pragma mark - 获取当前是哪一年
-(NSString *)returnCurrentYear
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY"];
    NSString *confromTimespStr = [formatter stringFromDate:[NSDate date]];
    
    return confromTimespStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)telphoneTap:(id)sender {
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"呼叫合作热线:\n18663909030" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (IBAction)talkTap:(id)sender {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:USER_IN])
    {
//        NewLogInView * loginView = [[NewLogInView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT)];
//        loginView.backgroundColor = [UIColor colorWithPatternImage:[LTools screenShot]];
//        [[UIApplication sharedApplication].keyWindow addSubview:loginView];
        
        [[NewLogInView loginShareInstance] showLogin];

    }else
    {
        [LTools rongCloudChatWithUserId:@"141490" userName:@"客户服务" viewController:self];
    }
}

- (IBAction)moreTap:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/yue-yee-zu/id605673005?l=zh&ls=1&mt=8"]];
}



#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"18663909030"]]];
    }
}









@end
