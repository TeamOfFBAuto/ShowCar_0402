//
//  AnliListViewController.m
//  ShowCar
//
//  Created by lichaowei on 15/3/27.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "AnliListViewController.h"

#import "PersonalViewController.h"
#import "ListViewCell.h"
#import "AnliModel.h"

@interface AnliListViewController ()<RefreshDelegate,UITableViewDataSource>
{
    RefreshTableView *_table;
    CGFloat currentOffsetY;
}


@end

@implementation AnliListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"案例";
    
    //数据展示table
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 44 - 49 - 20)];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    _table.backgroundColor = [UIColor clearColor];
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    _table.noDataStr = @"没有改装案例";
    _table.headerHeight = DEVICE_HEIGHT - 44;
    
    [_table showRefreshHeader:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 事件处理
/**
 *  调整至个人主页
 *
 */
- (void)clickToUserPage:(UIButton *)sender
{
    AnliModel *aModel =  [_table.dataArray objectAtIndex:sender.tag - 1000];
    
    PersonalViewController *personal = [[PersonalViewController alloc]init];
    
    personal.userId = aModel.uid;
    
    personal.isOther = YES;
    
    personal.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:personal animated:YES];
    
    [self updateViewFrameForShow:YES duration:0];

}

#pragma mark - 网络请求


- (void)networkForAnliList:(int)pageNum
{
    
    NSString *baseurl = ANLI_LIST;
    
    NSDictionary *params = @{
                             @"page":[NSNumber numberWithInt:pageNum],
                             @"ps":[NSNumber numberWithInt:10],
                             @"ordertype":[NSNumber numberWithInt:1],
                             @"id":[NSNumber numberWithInt:0]
                             };
    
    [LTools getRequestWithBaseUrl:baseurl parameters:params completion:^(NSDictionary *result, NSError *erro){
        
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dataInfo = result[@"datainfo"];
            
            int total = [dataInfo[@"total"] intValue];
            NSArray *data = dataInfo[@"data"];
            NSMutableArray *temp_arr = [NSMutableArray arrayWithCapacity:data.count];
            for (NSDictionary *aDic in data) {
                AnliModel *aModel = [[AnliModel alloc]initWithDictionary:aDic];
                [temp_arr addObject:aModel];
            }
            
            [_table reloadData:temp_arr total:total];
        }
        
    } failBlock:^(NSDictionary *result, NSError *erro) {
        
        [_table loadFail];
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _table.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"ListViewCell";
    
    ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ListViewCell" owner:self options:nil]lastObject];
    }
    [cell setCellWithModel:[_table.dataArray objectAtIndex:indexPath.row]];
    cell.bigImageView.height = [self heightFor:252];
    cell.bottomView.bottom = cell.bigImageView.bottom+ 80;
    
    cell.userButton.tag = 1000 + indexPath.row;
    [cell.userButton addTarget:self action:@selector(clickToUserPage:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark delegate

#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    NSLog(@"loadNewData");
    
    [self networkForAnliList:1];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    [self networkForAnliList:_table.pageNum];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [_table deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return [self heightFor:252] + 80;//80 为底部view高度
}

//根据宽度适应高度
- (CGFloat)heightFor:(CGFloat)oHeight
{
    CGFloat aHeight = (DEVICE_WIDTH / 320) * oHeight;
    return aHeight;
}


#pragma mark 列表滑动更新视图

//滑动列表时更新 navigationBar  tabbar 等视图 frame

- (void)updateViewFrameForShow:(BOOL)show duration:(CGFloat)seconds
{
    
    __weak typeof(_table)weakTable = _table;
    
    CGFloat oldHeight = DEVICE_HEIGHT - 44 - 49 - 20;
    
    [UIView animateWithDuration:seconds animations:^{
        
        
        CGFloat aY = show ? 20 : -44;
        
        
        weakTable.height = show ? oldHeight : DEVICE_HEIGHT;
        
        
        self.navigationController.navigationBar.top = aY;
        
        self.navigationController.navigationBarHidden = !show;
        
        self.tabBarController.tabBar.top = show ? DEVICE_HEIGHT - 49 : DEVICE_HEIGHT;
        
    }];
    
}

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    
    NSLog(@"offset %f",offset);
    
    if (offset > 20 && offset > currentOffsetY) {
        
        //消失
        
        [self updateViewFrameForShow:NO duration:0.2];
        
    }
    
    if (offset > 0 && offset < currentOffsetY) {
        
        [self updateViewFrameForShow:YES duration:0.2];
    }
    
    if (scrollView.contentOffset.y <= ((scrollView.contentSize.height - scrollView.frame.size.height-40))) {
        
        currentOffsetY = scrollView.contentOffset.y;
    }
    
}



@end
