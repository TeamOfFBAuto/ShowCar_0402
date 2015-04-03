//
//  SliderRightSettingViewController.h
//  越野e族
//
//  Created by soulnear on 14-7-8.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SliderRightSettingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * title_array;//标题
}

@property(nonatomic,strong)UITableView * myTableView;



@end
