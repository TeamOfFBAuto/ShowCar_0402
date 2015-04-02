//
//  RefreshTableView.m
//  TuanProject
//s
//  Created by 李朝伟 on 13-9-6.
//  Copyright (c) 2013年 lanou. All rights reserved.
//

#import "RefreshTableView.h"

//创建此类时,自动创建下拉刷新headerView,只有当判断有更多数据时,使用者去调用创建footerView方法

#define NORMAL_TEXT @"上拉加载更多"
#define NOMORE_TEXT @"没有更多数据"

#define TABLEFOOTER_HEIGHT 50.f

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@implementation RefreshTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.pageNum = 1;
        self.dataArray = [NSMutableArray array];
        
        [self createHeaderView];
//        [self createFooterView];
        self.delegate = self;
        
    }
    return self;
}

- (void)dealloc
{
    self.dataArray = nil;
    self.loadingIndicator = nil;
    self.normalLabel = nil;
    self.loadingLabel = nil;
    self.delegate = nil;
    _refreshHeaderView.delegate = nil;
    _refreshHeaderView = nil;
    NSLog(@"%s dealloc",__FUNCTION__);
}

-(id)initWithFrame:(CGRect)frame showLoadMore:(BOOL)show
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.pageNum = 1;
        self.dataArray = [NSMutableArray array];
        self.delegate = self;
        [self createHeaderView];
        if (show) {
            
            [self createFooterView];
        }
    }
    return self;
}

-(void)createHeaderView
{
    if (_refreshHeaderView && _refreshHeaderView.superview) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = [[LRefreshTableHeaderView alloc]initWithFrame:CGRectMake(0.0f,0.0f -self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    _refreshHeaderView.backgroundColor = [UIColor clearColor];
    [self addSubview:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];
}
-(void)removeHeaderView
{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = Nil;
}

- (void)createFooterView
{
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320, TABLEFOOTER_HEIGHT)];
    
    [tableFooterView addSubview:self.loadingIndicator];
    [tableFooterView addSubview:self.loadingLabel];
    [tableFooterView addSubview:self.normalLabel];
    
    tableFooterView.backgroundColor = [UIColor clearColor];
    self.tableFooterView = tableFooterView;
}


#pragma mark-
#pragma mark force to show the refresh headerView
//代码触发刷新
-(void)showRefreshHeader:(BOOL)animated
{
    if (animated)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.contentInset = UIEdgeInsetsMake(65.0f, 0.0f, 0.0f, 0.0f);
        [self scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
    }
    else
    {
        self.contentInset = UIEdgeInsetsMake(65.0f, 0.0f, 0.0f, 0.0f);
        [self scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
    }
    
    [_refreshHeaderView setState:L_EGOOPullRefreshLoading];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self];
}


-(void)showRefreshNoOffset
{
    _isReloadData = YES;
    
//    self.userInteractionEnabled = NO;
    
    _reloading = YES;
        
    if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(loadNewData)]) {
        
        self.pageNum = 1;
        [_refreshDelegate performSelector:@selector(loadNewData)];
    }
}


#pragma mark - EGORefreshTableDelegate
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    [self beginToReloadData:aRefreshPos];
}

//根据刷新类型，是看是下拉还是上拉
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos
{
    //  should be calling your tableviews data source model to reload
    _reloading = YES;
    if (aRefreshPos ==  EGORefreshHeader)
    {
        _isReloadData = YES;
        
        if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(loadNewData)]) {
            
            self.pageNum = 1;
            [_refreshDelegate performSelector:@selector(loadNewData)];
        }
    }
    
    // overide, the actual loading data operation is done in the subclass
}

/**
 *  更新数据源
 *
 *  @param data      新请求的一页数据
 *  @param totalPage 总的页数
 */
- (void)reloadData:(NSArray *)data total:(int)totalPage
{
    if (self.pageNum < totalPage) {
        
        self.isHaveMoreData = YES;
    }else
    {
        self.isHaveMoreData = NO;
    }
    
    if (self.isReloadData) {
        
        [self.dataArray removeAllObjects];
        
    }
    [self.dataArray addObjectsFromArray:data];
    
    [self performSelector:@selector(finishReloadigData) withObject:nil afterDelay:0];
}

//请求数据失败

- (void)loadFail
{
    if (self.isLoadMoreData) {
        self.pageNum --;
    }
    [self performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];

}

//完成数据加载

- (void)finishReloadigData
{
    NSLog(@"finishReloadigData完成加载");
    
    

    _reloading = NO;
    if (_refreshHeaderView) {
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
        self.isReloadData = NO;
    }
    
    @try {
        
        [self reloadData];
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
    
    //如果有更多数据，重新设置footerview  frame
    if (self.isHaveMoreData)
    {
        [self stopLoading:1];
        
    }else {
        
        if (self.dataArray.count == 0 && self.pageNum ==1 && self.netWorking != GNO) {//有网没数据
            
            [self stopLoading:3];
        }else if(self.netWorking == GNO){//没网
            [self stopLoading:4];
        }else if (self.netWorking == GIS){
            [self stopLoading:2];
        }
        
        
    }
    
    
    
    
    
    self.userInteractionEnabled = YES;
}


-(void)setNodataView{
    //整个视图
    
    
    
    UIView *center_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 60 + 1 + 5 + 13 + 5 + 1)];
    center_view.backgroundColor = [UIColor whiteColor];
    [_noDataView addSubview:center_view];
    center_view.center = CGPointMake(DEVICE_WIDTH/2.f, _noDataView.height/2.f);
    
    //图
    UIImageView *noDataImv = [[UIImageView alloc]initWithFrame:CGRectMake((DEVICE_WIDTH-130)*0.5, 1 - 22, 130, 60)];
    
    [noDataImv setImage:[UIImage imageNamed:@"noanydata.png"]];
    [center_view addSubview:noDataImv];
    
    //上分割线
    UIView *shangxian = [[UIView alloc]initWithFrame:CGRectMake(noDataImv.frame.origin.x, CGRectGetMaxY(noDataImv.frame)+12, noDataImv.frame.size.width, 1)];
    shangxian.backgroundColor = RGBCOLOR(233, 233, 233);
    [center_view addSubview:shangxian];
    
    //文字提示
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(shangxian.frame.origin.x, CGRectGetMaxY(shangxian.frame)+5, shangxian.frame.size.width, 13)];
    if (self.noDataStr == nil) {
        self.noDataStr = @"没有收藏任何内容";
    }
    titleLabel.text = self.noDataStr;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = RGBCOLOR(129, 129, 129);
    [center_view addSubview:titleLabel];

    //下分割线
    UIView *xiaxian = [[UIView alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(titleLabel.frame)+5, titleLabel.frame.size.width, 1)];
    xiaxian.backgroundColor = RGBCOLOR(233, 233, 233);
    
    [center_view addSubview:xiaxian];
    
    center_view.height = xiaxian.bottom;
    
    //视图添加
    [_noDataView addSubview:center_view];
    
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
    return _reloading;
}
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
    return [NSDate date];
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    
    if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(refreshScrollViewDidScroll:)]) {
        [_refreshDelegate refreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");
    
    if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(refreshScrollViewDidEndDecelerating:)]) {
        [_refreshDelegate refreshScrollViewDidEndDecelerating:scrollView];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    
    // 下拉到最底部时显示更多数据
    
    if(_isHaveMoreData && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height-40)))
    {
        if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(loadMoreData)]) {
            
            [self startLoading];
            
            _isLoadMoreData = YES;
            
            self.pageNum ++;
            [_refreshDelegate performSelector:@selector(loadMoreData)];
        }
    }
}

#pragma mark -
#pragma mark overide UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat aHeight = 0.0;
    if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(heightForRowIndexPath:)]) {
        aHeight = [_refreshDelegate heightForRowIndexPath:indexPath];
    }
    return aHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(didSelectRowAtIndexPath:)]) {
        [_refreshDelegate didSelectRowAtIndexPath:indexPath];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *aView;
    if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(viewForHeaderInSection:)]) {
        aView = [_refreshDelegate viewForHeaderInSection:section];
    }
    return aView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat aHeight = 0.0;
    if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(heightForHeaderInSection:)]) {
        aHeight = [_refreshDelegate heightForHeaderInSection:section];
    }
    return aHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0.5)];
//    line.backgroundColor = [UIColor lightGrayColor];
//    
//    return line;
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

#pragma mark -
#pragma mark overide UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == Nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}


#pragma - mark 创建所需label 和 UIActivityIndicatorView

- (UIActivityIndicatorView*)loadingIndicator
{
    if (!_loadingIndicator) {
        _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingIndicator.hidden = YES;
        _loadingIndicator.backgroundColor = [UIColor clearColor];
        _loadingIndicator.hidesWhenStopped = YES;
        _loadingIndicator.frame = CGRectMake(self.frame.size.width/2 - 70 ,6+2 + (TABLEFOOTER_HEIGHT - 40)/2.0, 24, 24);
    }
    return _loadingIndicator;
}

- (UILabel*)normalLabel
{
    if (!_normalLabel) {
        _normalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8 + (TABLEFOOTER_HEIGHT - 40)/2.0, self.frame.size.width, 20)];
        _normalLabel.text = NSLocalizedString(NORMAL_TEXT, nil);
        _normalLabel.backgroundColor = [UIColor clearColor];
        [_normalLabel setFont:[UIFont systemFontOfSize:14]];
        _normalLabel.textAlignment = NSTextAlignmentCenter;
        [_normalLabel setTextColor:[UIColor darkGrayColor]];
    }
    
    return _normalLabel;
    
}

- (UILabel*)loadingLabel
{
    if (!_loadingLabel) {
        _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(320.f/2-80,8 + (TABLEFOOTER_HEIGHT - 40)/2.0, self.frame.size.width/2+30, 20)];
        _loadingLabel.text = NSLocalizedString(@"加载中...", nil);
        _loadingLabel.backgroundColor = [UIColor clearColor];
        [_loadingLabel setFont:[UIFont systemFontOfSize:14]];
        _loadingLabel.textAlignment = NSTextAlignmentCenter;
        [_loadingLabel setTextColor:[UIColor darkGrayColor]];
        [_loadingLabel setHidden:YES];
    }
    
    return _loadingLabel;
}


- (void)startLoading
{
    [self.loadingIndicator startAnimating];
    [self.loadingLabel setHidden:NO];
    [self.normalLabel setHidden:YES];
}

- (void)stopLoading:(int)loadingType
{
    _isLoadMoreData = NO;
    
    [self.loadingIndicator stopAnimating];
    switch (loadingType) {
        case 1:
            self.tableFooterView = nil;
            [self createFooterView];
            [self.normalLabel setHidden:NO];
            [self.normalLabel setText:NSLocalizedString(NORMAL_TEXT, nil)];
            [self.loadingLabel setHidden:YES];
            
            break;
        case 2:
            
            self.tableFooterView = nil;
            [self createFooterView];
            [self.normalLabel setHidden:NO];
            [self.normalLabel setText:NSLocalizedString(NOMORE_TEXT, nil)];
            [self.loadingLabel setHidden:YES];
            
            break;
        case 3:
        {
            
            [self setNodataView];
            self.tableFooterView = _noDataView;
        }
            break;
        case 4:
        {
            self.tableFooterView = nil;
            [self createFooterView];
            [self.normalLabel setHidden:NO];
            [self.normalLabel setText:NSLocalizedString(@"请检查网络", nil)];
            [self.loadingLabel setHidden:YES];
        }
            
        default:
            break;
    }
}



@end
