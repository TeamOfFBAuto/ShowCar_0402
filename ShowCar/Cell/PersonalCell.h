//
//  PersonalCell.h
//  ShowCar
//
//  Created by lichaowei on 15/4/1.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImageVIew;
- (IBAction)clickToMessage:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstNum_label;
@property (strong, nonatomic) IBOutlet UILabel *secondNum_label;
@property (strong, nonatomic) IBOutlet UILabel *thirdNum_label;
@property (strong, nonatomic) IBOutlet UIButton *messageButton;

- (void)setCellWithModel:(id)aModel;

@end
