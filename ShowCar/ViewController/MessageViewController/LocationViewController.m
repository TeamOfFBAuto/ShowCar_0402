//
//  LocationViewController.m
//  CustomNewProject
//
//  Created by lichaowei on 15/1/24.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)configureNavigationBar
{
    UILabel *_myTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,44)];
    _myTitleLabel.textAlignment = NSTextAlignmentCenter;
    _myTitleLabel.text = @"选取位置";
    _myTitleLabel.textColor = [UIColor blackColor];
    _myTitleLabel.font = [UIFont systemFontOfSize:17];
    self.navigationItem.titleView = _myTitleLabel;
    
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton.width = -5;
    
    self.navigationController.navigationBarHidden=NO;
    
    
    UIBarButtonItem * spaceButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton1.width = -13;
    
    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(-5,8,40,44)];
    //    [button_back addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [button_back setImage:DEFAULT_IMAGE_BACK forState:UIControlStateNormal];
    UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:button_back];
    self.navigationItem.leftBarButtonItems=@[spaceButton1,back_item];
}

-(void)leftBarButtonItemPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

@end
