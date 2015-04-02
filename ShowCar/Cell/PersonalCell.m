//
//  PersonalCell.m
//  ShowCar
//
//  Created by lichaowei on 15/4/1.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "PersonalCell.h"
#import "UserInfo.h"

@implementation PersonalCell

- (void)awakeFromNib {
    // Initialization code
    
    self.iconImageVIew.layer.cornerRadius = 140/2.f;
    self.iconImageVIew.backgroundColor = [UIColor orangeColor];
    self.iconImageVIew.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickToMessage:(id)sender {
    
    
}

- (void)setCellWithModel:(UserInfo *)aModel
{
    [self.iconImageVIew sd_setImageWithURL:[NSURL URLWithString:aModel.pichead] placeholderImage:nil];
    self.nameLabel.text = aModel.username;
    self.contentLabel.text = @"咱无简介";
    self.firstNum_label.text = @"10";
    self.secondNum_label.text = @"20";
    self.thirdNum_label.text = @"30";
}

@end
