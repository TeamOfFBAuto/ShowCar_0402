//
//  PersonalAnliCell.m
//  ShowCar
//
//  Created by lichaowei on 15/4/1.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "PersonalAnliCell.h"
#import "AnliModel.h"

@implementation PersonalAnliCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellWithModel:(AnliModel *)aModel
{
    
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:aModel.pichead] placeholderImage:nil];
    self.contentLabel.text = aModel.content;
    self.zanNum_label.text = @"10";
    self.commentNum_label.text = @"20";
}

@end
