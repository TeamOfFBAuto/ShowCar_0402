//
//  RootViewController.h
//  ShowCar
//
//  Created by lichaowei on 15/3/24.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BlockName)(NSString *params1);

@interface RootViewController : UITabBarController
{
    BlockName _abock;
}

@property(nonatomic,assign)BlockName aBlock;

@end
