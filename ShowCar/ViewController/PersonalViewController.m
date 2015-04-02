//
//  PersonalViewController.m
//  ShowCar
//
//  Created by lichaowei on 15/3/31.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "PersonalViewController.h"
#import "PersonalCell.h"
#import "PersonalAnliCell.h"

#import "UserInfo.h"
#import "AnliModel.h"

@interface PersonalViewController ()<RefreshDelegate,UITableViewDataSource>
{
    RefreshTableView *_table;
    UserInfo *_userInfo;
    MBProgressHUD *loading;
}

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myTitle = @"个人中心";
    self.titleLabel.textColor = RGBCOLOR(226, 0, 0);
    self.rightImageName = @"publish_tianjia";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeOther];
    
    //数据展示table
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 44 - 49 - 20)];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    _table.backgroundColor = [UIColor clearColor];
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    loading = [LTools MBProgressWithText:@"数据加载..." addToView:self.view];
    
    [self networkForUserInfo];
    
    [self networkForUserShouCang:1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 事件处理

- (void)dealUserInfo:(UserInfo *)aModel
{
    NSMutableString *pichead = [NSMutableString stringWithString:aModel.pichead];
    [pichead replaceOccurrencesOfString:@"small" withString:@"big" options:0 range:NSMakeRange(0, pichead.length)];
    aModel.pichead = pichead;
    
    _userInfo = aModel;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - 网络请求

/**
 *  获取个人信息
 */
- (void)networkForUserInfo
{
    NSString *baseurl = USERINFO;
    
    NSDictionary *params = @{
                             @"uid":@"1102017" //固定测试
                             };
    
    __weak typeof(self)weakSelf = self;
    
    [LTools getRequestWithBaseUrl:baseurl parameters:params completion:^(NSDictionary *result, NSError *erro){
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dataInfo = result[@"datainfo"];
            
            UserInfo *userInfo = [[UserInfo alloc]initWithDictionary:dataInfo];
            
            [weakSelf dealUserInfo:userInfo];
        }
        
    } failBlock:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"%s %@",__FUNCTION__,[result objectForKey:ERROR_INFO]);
    }];
    
}

//// &uid=%@&=%d&=%d
//#define ANLI_LIST_SHOUCANG @"http://cool.fblife.com/index.php?c=interface&a=getFavCase&fbtype=json"

/**
 *  获取收藏案例
 *
 *  @param page 请求第几页
 */
- (void)networkForUserShouCang:(int)page
{
    NSString *baseurl = ANLI_LIST_SHOUCANG;
    
    NSDictionary *params = @{
                             @"uid":@"1102017" //固定测试
                             ,@"page":[NSNumber numberWithInt:page],
                             @"ps":[NSNumber numberWithInt:10]
                             };
    
//    __weak typeof(self)weakSelf = self;
    __weak typeof(_table)weakTable = _table;
    
    [LTools getRequestWithBaseUrl:baseurl parameters:params completion:^(NSDictionary *result, NSError *erro){
        
            NSDictionary *dataInfo = result[@"datainfo"];
        NSArray *data = dataInfo[@"data"];
        
        int total = [dataInfo[@"total"]intValue];
        
        if ([data isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *temp_arr = [NSMutableArray arrayWithCapacity:data.count];
            
            for (NSDictionary *aDic in data) {
                
                AnliModel *aModel = [[AnliModel alloc]initWithDictionary:aDic];
                
                [temp_arr addObject:aModel];
            }
            
            [weakTable reloadData:temp_arr total:total];
            
        }
        
    } failBlock:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"%s %@",__FUNCTION__,[result objectForKey:ERROR_INFO]);
        
        int errcode = [result[@"errcode"]intValue];
        if (errcode == 1) {
            
            [weakTable loadFail];
        }
        
    }];
    
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _table.dataArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        static NSString *identify = @"PersonalCell";
        
        PersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonalCell" owner:self options:nil]lastObject];
        }
        
        [cell setCellWithModel:_userInfo];
        
        return cell;
    }
    
    static NSString *identify = @"PersonalAnliCell";
    
    PersonalAnliCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonalAnliCell" owner:self options:nil]lastObject];
    }
    AnliModel *aModel = [_table.dataArray objectAtIndex:indexPath.row - 1];
    [cell setCellWithModel:aModel];
    
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
    
    [self networkForUserShouCang:1];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    [self networkForUserShouCang:_table.pageNum];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [_table deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        return 319 + 20;
    }
    
    return [self heightFor:250];//80 为底部view高度
}

//根据宽度适应高度
- (CGFloat)heightFor:(CGFloat)oHeight
{
    CGFloat aHeight = (DEVICE_WIDTH / 320) * oHeight;
    return aHeight;
}



@end
