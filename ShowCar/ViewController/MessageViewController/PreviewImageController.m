//
//  PreviewImageController.m
//  CustomNewProject
//
//  Created by lichaowei on 15/1/26.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import "PreviewImageController.h"
#import "ZoomScrollView.h"

@implementation PreviewImageController
{
    ZoomScrollView *_aImageView;
}

- (void)dealloc
{
    _aImageView = nil;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.rightString = @"保存";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    
    _aImageView = [[ZoomScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    
    [_aImageView.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:self.thumImage];
    
    __weak typeof(self)weakSelf = self;
    [_aImageView setGestureBlock:^(GESTURE_STYLE aStyle) {
       
        if (aStyle == Gesture_Tap) {
            
            weakSelf.navigationController.navigationBarHidden = !weakSelf.navigationController.isNavigationBarHidden;
        }
    }];
    
    [self.view addSubview:_aImageView];
}

-(void)rightButtonTap:(UIButton *)sender
{
    if (_aImageView.imageView.image)
    {
        UIImageWriteToSavedPhotosAlbum(_aImageView.imageView.image,self,
                                       @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

-(void)leftButtonTap:(UIButton *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - 保存图片到本地

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error == nil) {
        
        [LTools showMBProgressWithText:@"保存图片成功" addToView:self.view];
    }
    
}


@end
