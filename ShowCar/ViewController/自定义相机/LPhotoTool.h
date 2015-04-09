//
//  LPhotoTool.h
//  ShowCar
//
//  Created by lichaowei on 15/4/8.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AssetsLibrary/AssetsLibrary.h>


@interface LPhotoTool : NSObject

@property(nonatomic,retain)ALAssetsLibrary* library;

+ (id)LPhotoInstance;

- (void)showLastImageForImageView:(UIImageView *)imageView;

@end
