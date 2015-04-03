//
//  ZoomImageView.h
//  TestImageAlbum
//
//  Created by lichaowei on 14-6-23.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    Gesture_Tap = 0,//点击
    Gesture_Tap_Double //双击
    
}GESTURE_STYLE;

typedef void(^GestureBlock)(GESTURE_STYLE aStyle);

@interface ZoomScrollView : UIScrollView<UIScrollViewDelegate>
{
    GestureBlock _gestureBlock;
}

@property (nonatomic,retain)UIImageView *imageView;

- (void)setGestureBlock:(GestureBlock)aBlock;

@end
