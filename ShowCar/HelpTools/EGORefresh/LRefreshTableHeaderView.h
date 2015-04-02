//
//  LRefreshTableHeaderView.h
//  FBCircle
//
//  Created by lichaowei on 14-8-5.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class SCGIFImageView;

typedef enum{
	L_EGOOPullRefreshPulling = 0,
	L_EGOOPullRefreshNormal,
	L_EGOOPullRefreshLoading,
} L_EGOPullRefreshState;

typedef enum{
    EGORefreshHeader = 0,
    EGORefreshFooter
} EGORefreshPos;

@protocol L_EGORefreshTableDelegate
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos;
- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view;
@optional
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view;
@end

@interface LRefreshTableHeaderView : UIView
{
    L_EGOPullRefreshState _state;
    
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
}

@property(nonatomic,assign) id <L_EGORefreshTableDelegate> delegate;


- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor;

- (void)refreshLastUpdatedDate;
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
- (void)setState:(L_EGOPullRefreshState)aState;

@end
