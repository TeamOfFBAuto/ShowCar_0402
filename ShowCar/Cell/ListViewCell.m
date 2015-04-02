//
//  ListViewCell.m
//  ShowCar
//
//  Created by lichaowei on 15/3/24.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "ListViewCell.h"
#import "AnliModel.h"

@implementation ListViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 55/2.f;
    self.iconImageView.layer.borderWidth = 1.f;
    self.iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithModel:(AnliModel *)aModel
{
    [self.bigImageView setImageWithURL:[NSURL URLWithString:aModel.pichead] placeholderImage:nil];
    self.contentLabel.text = aModel.sname;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:aModel.spichead] placeholderImage:nil];
}

@end
