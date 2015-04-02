//
//  PrivacyPolicyView.m
//  CustomNewProject
//
//  Created by soulnear on 15-1-28.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import "PrivacyPolicyView.h"

@implementation PrivacyPolicyView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

-(void)setup
{
    UIImageView * logo_imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginview_logo_image"]];
    logo_imageView.center = CGPointMake(self.width/2.0f,56/2.0f);
    [self addSubview:logo_imageView];
    
    
    ///关闭按钮
    UIButton * close_button = [UIButton buttonWithType:UIButtonTypeCustom];
    close_button.frame = CGRectMake(self.width-40,0,40,40);
    [close_button setImage:[UIImage imageNamed:@"LogInView_close"] forState:UIControlStateNormal];
    [close_button addTarget:self action:@selector(closeTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:close_button];
    
    
    
    UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(0,56,self.width,0.5)];
    line_view.backgroundColor = RGBCOLOR(146,146,146);
    [self addSubview:line_view];
    
    UISegmentedControl * segmentC = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"隐私条款",@"服务条款",nil]];
    segmentC.backgroundColor = [UIColor whiteColor];
    segmentC.tintColor = RGBCOLOR(195,195,195);
    segmentC.selectedSegmentIndex = 0;
    segmentC.frame = CGRectMake(5,70,self.width-10,28);
    [segmentC setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(3,3,3),
                                       NSFontAttributeName:[UIFont systemFontOfSize:13]} forState:UIControlStateNormal];
    [segmentC setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(3,3,3),
                                       NSFontAttributeName:[UIFont systemFontOfSize:13]} forState:UIControlStateSelected];
    [segmentC addTarget:self action:@selector(changeTap:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:segmentC];

    content_array = [NSArray arrayWithObjects:@"隐私条款.html",@"服务条款.html",nil];
    
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:[content_array objectAtIndex:0] ofType:nil];
    NSURL * url = [NSURL fileURLWithPath:resourcePath];
    myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,segmentC.bottom+10,self.width,self.height-segmentC.bottom-10)];
    myWebView.scrollView.showsHorizontalScrollIndicator = NO;
    myWebView.scrollView.showsVerticalScrollIndicator = NO;
    myWebView.scrollView.bounces = NO;
    [self addSubview:myWebView];
    [myWebView loadRequest:[NSURLRequest requestWithURL:url] ];
    
    myWebView.scalesPageToFit = YES;
}

-(void)closeTap:(UIButton *)button
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)changeTap:(UISegmentedControl *)Seg
{
    NSInteger Index = Seg.selectedSegmentIndex;
    NSLog(@"Index %i", Index);
    
    NSString *resourcePath = [ [NSBundle mainBundle] pathForResource:[content_array objectAtIndex:Index] ofType:nil];
    NSURL * url = [[NSURL alloc] initFileURLWithPath:resourcePath];
    [myWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
