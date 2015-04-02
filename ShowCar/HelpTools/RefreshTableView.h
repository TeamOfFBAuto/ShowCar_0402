//
//  RefreshTableView.h
//  TuanProject
//
//  Created by 李朝伟 on 13-9-6.
//  Copyright (c) 2013年 lanou. All rights reserved.
//


//=============================

// 封装 tableView 带刷新

//=============================


#import <UIKit/UIKit.h>
#import "LRefreshTableHeaderView.h"
typedef enum{
    GIS = 0,//有网
    GNO ,//没网
}GNetWorking;

@class HelperConnection;

@protocol RefreshDelegate <NSObject>

@optional
- (void)loadNewData;
- (void)loadMoreData;
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath;
- (UIView *)viewForHeaderInSection:(NSInteger)section;
- (CGFloat)heightForHeaderInSection:(NSInteger)section;

//scrollView滑动

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end

@interface RefreshTableView : UITableView<L_EGORefreshTableDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *_noDataView;//没有数据时候的展示view;
}

@property (nonatomic,retain)LRefreshTableHeaderView * refreshHeaderView;

@property (nonatomic,weak)id<RefreshDelegate>refreshDelegate;
@property (nonatomic,assign)BOOL                        isReloadData;      //是否是下拉刷新数据
@property (nonatomic,assign)BOOL                        reloading;         //是否正在loading
@property (nonatomic,assign)BOOL                        isLoadMoreData;    //是否是载入更多
@property (nonatomic,assign)BOOL                        isHaveMoreData;    //是否还有更多数据,决定是否有更多view

@property (nonatomic,assign)int pageNum;//页数
@property (nonatomic,retain)NSMutableArray *dataArray;//数据源

@property(nonatomic,retain)UIActivityIndicatorView *loadingIndicator;
@property(nonatomic,retain)UILabel *normalLabel;
@property(nonatomic,retain)UILabel *loadingLabel;
@property(nonatomic,assign)BOOL hiddenLoadMore;//隐藏加载更多,默认隐藏
@property(nonatomic,assign)GNetWorking netWorking;//yes有网  no没网
@property(nonatomic,strong)NSString *noDataStr;
@property(nonatomic,assign)CGFloat headerHeight;



-(void)createHeaderView;
-(void)removeHeaderView;

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos;
-(void)showRefreshHeader:(BOOL)animated;//代码出发刷新
- (void)finishReloadigData;

-(void)showRefreshNoOffset;//无偏移刷新数据

- (void)reloadData:(NSArray *)data total:(int)totalPage;//更新数据
- (void)loadFail;//请求数据失败

-(id)initWithFrame:(CGRect)frame showLoadMore:(BOOL)show;

@end
