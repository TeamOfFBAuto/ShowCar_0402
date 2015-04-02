//
//  BaseViewController.m
//  ShowCar
//
//  Created by lichaowei on 15/3/27.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,44)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    self.navigationItem.titleView = _titleLabel;

    spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton.width = 5.f;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setMyViewControllerLeftButtonType:(MyViewControllerLeftbuttonType)theType WithRightButtonType:(MyViewControllerRightbuttonType)rightType
{
    
    leftType = theType;
    myRightType = rightType;
    
    if (theType == MyViewControllerLeftbuttonTypeBack)
    {
        UIBarButtonItem * spaceButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButton1.width = -13;
        
        UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(-5,8,40,44)];
        [button_back addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [button_back setImage:DEFAULT_IMAGE_BACK forState:UIControlStateNormal];
        UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:button_back];
        self.navigationItem.leftBarButtonItems=@[spaceButton1,back_item];
    }else if (theType == MyViewControllerLeftbuttonTypelogo)
    {
        UIImageView * leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ios7logo"]];
        leftImageView.center = CGPointMake(18,22);
        UIView *lefttttview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
        [lefttttview addSubview:leftImageView];
        UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:lefttttview];
        
        self.navigationItem.leftBarButtonItems = @[spaceButton,leftButton];
    }else if(theType == MyViewControllerLeftbuttonTypeOther)
    {
        UIImage * leftImage = [UIImage imageNamed:_leftImageName];
        UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setImage:[UIImage imageNamed:self.leftImageName] forState:UIControlStateNormal];
        leftButton.frame = CGRectMake(0,0,leftImage.size.width,leftImage.size.height);
        //        leftButton.backgroundColor = [UIColor orangeColor];
        UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItems = @[spaceButton,leftBarButton];
        
        
    }else if (theType == MyViewControllerLeftbuttonTypeText)
    {
        UIButton * left_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        left_button.frame = CGRectMake(0,0,30,44);
        
        left_button.titleLabel.textAlignment = NSTextAlignmentRight;
        
        [left_button setTitle:_leftString forState:UIControlStateNormal];
        
        left_button.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [left_button setTitleColor:RGBCOLOR(91,138,59) forState:UIControlStateNormal];
        
        [left_button addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItems = @[spaceButton,[[UIBarButtonItem alloc] initWithCustomView:left_button]];
    }else
    {
        UIButton * left_button = [UIButton buttonWithType:UIButtonTypeCustom];
        left_button.frame = CGRectMake(0,0,30,44);
        self.navigationItem.leftBarButtonItems = @[spaceButton,[[UIBarButtonItem alloc] initWithCustomView:left_button]];
        
    }
    
    
    
    if (rightType == MyViewControllerRightbuttonTypeRefresh)
    {
        _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_my_right_button setImage:[UIImage imageNamed:@"ios7_refresh4139.png"] forState:UIControlStateNormal];
        _my_right_button.frame = CGRectMake(0,0,41/2,39/2);
        _my_right_button.center = CGPointMake(300,20);
        [_my_right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItems= @[spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
        
    }else if (rightType == MyViewControllerRightbuttonTypeSearch)
    {
        UIButton *rightview=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 37, 37/2)];
        rightview.backgroundColor=[UIColor clearColor];
        [rightview addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_my_right_button setImage:[UIImage imageNamed:@"ios7_newssearch.png"] forState:UIControlStateNormal];
        _my_right_button.frame = CGRectMake(25, 0, 37/2, 37/2);
        [rightview addSubview:_my_right_button];
        [_my_right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *_rightitem=[[UIBarButtonItem alloc]initWithCustomView:rightview];
        self.navigationItem.rightBarButtonItem=_rightitem;
        
    }else if(rightType == MyViewControllerRightbuttonTypeText)
    {
        _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _my_right_button.frame = CGRectMake(0,0,30,44);
        
        _my_right_button.titleLabel.textAlignment = NSTextAlignmentRight;
        
        [_my_right_button setTitle:_rightString forState:UIControlStateNormal];
        
        _my_right_button.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [_my_right_button setTitleColor:RGBCOLOR(80,80,80) forState:UIControlStateNormal];
        
        [_my_right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItems = @[spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
        
    }else if (rightType == MyViewControllerRightbuttonTypeDelete)
    {
        
    }else if (rightType == MyViewControllerRightbuttonTypePerson)
    {
        _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _my_right_button.frame = CGRectMake(0,0,36/2,33/2);
        
        [_my_right_button setImage:[UIImage imageNamed:@"chat_people.png"] forState:UIControlStateNormal];
        
        [_my_right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem * People_button = [[UIBarButtonItem alloc] initWithCustomView:_my_right_button];
        
        self.navigationItem.rightBarButtonItems = @[spaceButton,People_button];
        
        
    }else if(rightType == MyViewControllerRightbuttonTypeOther)
    {
        UIImage * rightImage = [UIImage imageNamed:_rightImageName];
        
        _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_my_right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        [_my_right_button setImage:[UIImage imageNamed:self.rightImageName] forState:UIControlStateNormal];
        
        _my_right_button.frame = CGRectMake(0,0,rightImage.size.width,rightImage.size.height);
        
        UIBarButtonItem * rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:_my_right_button];
        
        self.navigationItem.rightBarButtonItems = @[spaceButton,rightBarButton];;
        
    }else
    {
        
    }
    
}

-(void)setMyTitle:(NSString *)myTitle
{
    _myTitle = myTitle;
    _titleLabel.text = _myTitle;
}

-(void)setLeftString:(NSString *)leftString
{
    _leftString = leftString;
    [self setMyViewControllerLeftButtonType:leftType WithRightButtonType:myRightType];
}
-(void)setRightString:(NSString *)rightString
{
    _rightString = rightString;
    [self setMyViewControllerLeftButtonType:leftType WithRightButtonType:myRightType];
}
-(void)setRightImageName:(NSString *)rightImageName
{
    _rightImageName = rightImageName;
    [self setMyViewControllerLeftButtonType:leftType WithRightButtonType:myRightType];
}
-(void)setLeftImageName:(NSString *)leftImageName
{
    _leftImageName = leftImageName;
    [self setMyViewControllerLeftButtonType:leftType WithRightButtonType:myRightType];
}


-(void)rightButtonTap:(UIButton *)sender
{
    
}

-(void)leftButtonTap:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
