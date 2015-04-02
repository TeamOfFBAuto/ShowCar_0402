//
//  BaseViewController.h
//  ShowCar
//
//  Created by lichaowei on 15/3/27.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  基类
 */

typedef enum
{
    MyViewControllerLeftbuttonTypeBack=0,
    MyViewControllerLeftbuttonTypelogo=1,
    MyViewControllerLeftbuttonTypeOther=2,
    MyViewControllerLeftbuttonTypeNull=3,
    MyViewControllerLeftbuttonTypeText = 4
}MyViewControllerLeftbuttonType;


typedef enum
{
    MyViewControllerRightbuttonTypeRefresh=0,
    MyViewControllerRightbuttonTypeSearch=1,
    MyViewControllerRightbuttonTypeText=2,
    MyViewControllerRightbuttonTypePerson=3,
    MyViewControllerRightbuttonTypeDelete=4,
    MyViewControllerRightbuttonTypeNull=5,
    MyViewControllerRightbuttonTypeOther
}MyViewControllerRightbuttonType;

@interface BaseViewController : UIViewController
{
    UIBarButtonItem * spaceButton;
    
    MyViewControllerLeftbuttonType leftType;
    MyViewControllerRightbuttonType myRightType;
}

///标题
@property(nonatomic,strong)UILabel * titleLabel;

@property(nonatomic,retain)UIButton *leftButton;//收藏按钮

@property(nonatomic,retain)UIButton *rightButton;//举报按钮

@property(nonatomic,assign)MyViewControllerLeftbuttonType * leftButtonType;

@property(nonatomic,strong)NSString * rightString;

@property(nonatomic,strong)NSString * leftString;

@property(nonatomic,strong)NSString * leftImageName;

@property(nonatomic,strong)NSString * rightImageName;

///标题
@property(nonatomic,strong)NSString * myTitle;
//右上角按钮
@property(nonatomic,strong)UIButton * my_right_button;


-(void)setMyViewControllerLeftButtonType:(MyViewControllerLeftbuttonType)theType WithRightButtonType:(MyViewControllerRightbuttonType)rightType;

@end
