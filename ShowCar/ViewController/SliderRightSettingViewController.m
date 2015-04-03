//
//  SliderRightSettingViewController.m
//  越野e族
//
//  Created by soulnear on 14-7-8.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "SliderRightSettingViewController.h"
#import "SDImageCache.h"
#import "UMFeedbackViewController.h"
#import "AboutViewController.h"
//#import "UMTableViewController.h"
#import "AppDelegate.h"
#import "GMAPI.h"
#import "NewLogInView.h"

//#import "RCIM.h"

///当前类统计代表的数字
#define CURRENT_SHOW_NUM @"9"

@interface SliderRightSettingViewController ()
{
//    UMUFPTableView * _mTableView;
    
    NSArray * arrayofjingpinyingyong;
    
    UIButton * logOut_button;//退出/登陆按钮
}

@end

@implementation SliderRightSettingViewController
@synthesize myTableView = _myTableView;





- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:YES];
//    [MobClick beginEvent:@"SliderRightSettingViewController"];
//    
//    [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_GOTO WithObject:CURRENT_SHOW_NUM WithValue:@""];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
//    [MobClick endEvent:@"SliderRightSettingViewController"];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
        
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    self.myTitle = @"设置";
    
//    title_array = [NSArray arrayWithObjects:@"",@"清除缓存",@"意见反馈",@"版本更新",@"关于",@"",nil];
    
    title_array = [NSArray arrayWithObjects:@"",@"清除缓存",@"意见反馈",@"关于",@"",nil];

    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT - 20 - 44) style:UITableViewStylePlain];
    
    self.myTableView.delegate = self;
    
    self.myTableView.separatorColor = RGBCOLOR(230,230,230);
    
    self.myTableView.dataSource = self;
    
    self.myTableView.backgroundColor = RGBCOLOR(248,248,248);
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.myTableView.showsHorizontalScrollIndicator = NO;
    
    self.myTableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:self.myTableView];
    
    
    
//    _mTableView = [[UMUFPTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain appkey:@"5153e5e456240b79e20006b9" slotId:nil currentViewController:self];
//    _mTableView.delegate = self;
//    _mTableView.dataSource = self;
//    _mTableView.dataLoadDelegate = (id<UMUFPTableViewDataLoadDelegate>)self;
//    
//    [_mTableView requestPromoterDataInBackground];
    
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(successToLogIn) name:@"gdengluchenggong" object:nil];//登陆成功通知
    
    
}

-(void)leftButtonTap:(UIButton *)sender
{
//    [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_GOTO WithObject:CURRENT_SHOW_NUM WithValue:@"6"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 登陆成功

-(void)successLogIn
{
    [_myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:8 inSection:0],nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark--取精品应用数据回调


- (void)loadDataFailed {
    
    NSLog(@"获取精品应用数据失败");
    
}

////该方法在成功获取广告数据后被调用
//- (void)UMUFPTableViewDidLoadDataFinish:(UMUFPTableView *)tableview promoters:(NSArray *)promoters {
//    
//    arrayofjingpinyingyong=[NSArray arrayWithArray:promoters];
//    
//    if ([promoters count] > 0)
//    {
//        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:7 inSection:0];
//        [_myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//    }
//}



#pragma mark - UITableViewDelegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return title_array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 23;
    }else if(indexPath.row == 4)
    {
        return 90;
    }else
    {
        return 54;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = [title_array objectAtIndex:indexPath.row];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,0.5)];
    
    lineView.backgroundColor = RGBCOLOR(231,231,231);
    
    [cell.contentView addSubview:lineView];
    
    if (indexPath.row == 0) {
        lineView.hidden = YES;
        
        cell.backgroundColor = RGBCOLOR(239,237,237);
    }else
    {
        lineView.hidden = NO;
    }
    
    if (indexPath.row == 4)
    {
        cell.backgroundColor = RGBCOLOR(248,248,248);
        
        lineView.center = CGPointMake(DEVICE_WIDTH / 2.f,0.25);
        
        BOOL isLogIn = [[NSUserDefaults standardUserDefaults] boolForKey:USER_IN];
        
        
        logOut_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        logOut_button.frame = CGRectMake(14,23,DEVICE_WIDTH - 14 * 2,85/2);
        
        [logOut_button setTitle:isLogIn?@"退出登录":@"立即登录" forState:UIControlStateNormal];
        
        [logOut_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        logOut_button.backgroundColor = RGBCOLOR(255,135,0);
        
        [logOut_button addTarget:self action:@selector(logOutTap:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:logOut_button];
        
        
    }else if (indexPath.row == 1)
    {
//        NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/data"];
        
        lineView.center = CGPointMake(DEVICE_WIDTH / 2.f,0.25);
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_WIDTH - 112,0,100,54)];
        
        label.textAlignment = NSTextAlignmentRight;
        
        label.backgroundColor = [UIColor clearColor];
        
        float tmpSize = [[SDImageCache sharedImageCache] getSize]/1024.0f/1024.0f;
        
        NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM",tmpSize] : [NSString stringWithFormat:@"%.2fK",tmpSize * 1024];
        
        label.text =  clearCacheName;//[NSString stringWithFormat:@"%d",[[SDImageCache sharedImageCache] getSize]];// [ZSNApi fileSizeAtPath:path];
        
        label.font = [UIFont systemFontOfSize:15];
        
        label.textColor = RGBCOLOR(194,194,194);
        
        [cell.contentView addSubview:label];
        
        
    }else if (indexPath.row == 2)
    {
//        lineView.center = CGPointMake(DEVICE_WIDTH - 146,0.25);
        
        lineView.left = 20.f;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
//    else if (indexPath.row == 3)
//    {
////        lineView.center = CGPointMake(DEVICE_WIDTH - 146,0.25);
//        lineView.left = 20.f;
//        
//    }
    
    else if (indexPath.row == 3)
    {
        //174
//        lineView.center = CGPointMake(DEVICE_WIDTH - 146,0.25);
        
        lineView.left = 20.f;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)//清除缓存
    {
//        [MobClick event:@"qingchuhuancun"];
        [self removeCache];
    }else if (indexPath.row == 2)//意见反馈
    {
//        [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_GOTO WithObject:CURRENT_SHOW_NUM WithValue:@"2"];
        UMFeedbackViewController *feedb=[[UMFeedbackViewController alloc]init];
        [self.navigationController pushViewController:feedb animated:YES];
        
        
    }
    
//    else if (indexPath.row == 3)//版本更新
//    {
//        [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_GOTO WithObject:CURRENT_SHOW_NUM WithValue:@"3"];
//        [self checkVersionUpdate];
//    }
    
    else if (indexPath.row == 3)//关于
    {
//        [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_GOTO WithObject:CURRENT_SHOW_NUM WithValue:@"4"];
        AboutViewController * aboutVC = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }else if (indexPath.row == 6)//精品应用
    {
//        UMTableViewController *controller = [[UMTableViewController alloc] init];
//        [self.navigationController pushViewController:controller animated:YES];
    }
}



-(void)domysuggestbutton:(UIButton *)sender{
    
//    NSLog(@"点击的是第%d个Button",sender.tag-99);
//    int index=sender.tag-99;
//    NSDictionary *promoter = [_mTableView.mPromoterDatas objectAtIndex:index];
//    
//    [_mTableView didClickPromoterAtIndex:promoter index:index];
    
}


-(void)logOutTap:(UIButton *)sender
{
    BOOL isLogIn = [[NSUserDefaults standardUserDefaults] boolForKey:USER_IN];
    
    if (isLogIn)
    {
//        [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_GOTO WithObject:CURRENT_SHOW_NUM WithValue:@"5"];
        
        [logOut_button setTitle:@"立即登录" forState:UIControlStateNormal];
        
        [GMAPI cleanUserFaceAndBanner];
        
        [self deletetoken];
        
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        [user setObject:@"" forKey:USER_NAME] ;
        [user setObject:@"" forKey:USER_PW] ;
        [user setObject:@"" forKey:USER_AUTHOD] ;
        [user setObject:@"" forKey:USER_UID] ;
        [user setBool:NO forKey:USER_IN];
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGOUT object:nil];
        
        [[RCIM sharedRCIM] disconnect];//注销融云
//        [[RCIM sharedRCIM]clearConversations:ConversationType_PRIVATE,ConversationType_GROUP,ConversationType_DISCUSSION,nil];
        
        [user removeObjectForKey:@"friendList"];
        [user removeObjectForKey:@"RecentContact"];
        
        [user synchronize];
    }else
    {
        
        [[NewLogInView loginShareInstance] showLogin];

    }
}


#pragma mark - 登录代理


-(void)successToLogIn
{
    [logOut_button setTitle:@"退出登录" forState:UIControlStateNormal];
}

-(void)failToLogIn
{
    
}


#pragma mark-退出登录，消除devicetoken

-(void)deletetoken{
    /*http://bbs2.fblife.com/localapi/user_app_token.php?action=deltoken&authcode=sdfasfdsafdasdf&token=ssdfasdfaddfgdsgf2a&token_key=01b1f00235ae1d46432ba45771beb2d1&datatype=json*/
    
    
    NSString *stringdevicetoken=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:DEVICETOKEN]];
    NSString *authkey=[[NSUserDefaults standardUserDefaults] objectForKey:USER_AUTHOD];
    NSString * fullURL= [NSString stringWithFormat:@"http://bbs2.fblife.com/localapi/user_app_token.php?action=deltoken&authcode=%@&token=%@&token_key=01b1f00235ae1d46432ba45771beb2d1&datatype=json",authkey,stringdevicetoken];
    NSLog(@"删除的urlurl = %@",fullURL);
    
    //&authcode=%@&token=%@
    NSString *url = @"http://bbs2.fblife.com/localapi/user_app_token.php?action=deltoken&token_key=01b1f00235ae1d46432ba45771beb2d1&datatype=json";
    
    NSDictionary *params = @{@"authcode":authkey
                             ,@"token":stringdevicetoken};
    
    [LTools getRequestWithBaseUrl:url parameters:params completion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"%s",__FUNCTION__);
        
    } failBlock:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"%s : %@",__FUNCTION__,result[ERROR_INFO]);
        
    }];
    
    
}


#pragma mark - 清除缓存

-(void)removeCache
{
//    [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_GOTO WithObject:CURRENT_SHOW_NUM WithValue:@"1"];
    [[SDImageCache sharedImageCache] clearDisk];
    NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    NSArray *arra=[NSArray arrayWithObject:reloadIndexPath];
    [ _myTableView reloadRowsAtIndexPaths:arra withRowAnimation:UITableViewRowAnimationNone];
    
    
    
    
    //弹出提示信息
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"缓存清除成功" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark - 检查版本更新

-(void)checkVersionUpdate
{

    [[LTools shareInstance] versionForAppid:@"950579792" Block:^(BOOL isNewVersion, NSString *updateUrl, NSString *updateContent) {
        
        NSLog(@"updateContent %@ %@",updateUrl,updateContent);
        
        if (!isNewVersion) {
         
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"版本更新检查" message:@"您目前使用的是最新版本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }];
  
    
//    NSURL * fullUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://bbs.fblife.com/bbsapinew/version.php?appversion=%@",NOW_VERSION]];
//    
//    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:fullUrl];
//    
//    __block ASIHTTPRequest * _request = request;
//    
//    
//    request.delegate = self;
//    
//    [_request setCompletionBlock:^{
//        
//        @try {
//            NSDictionary * dic = [request.responseData objectFromJSONData];
//            
//            NSString * bbsInfo = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bbsinfo"]];
//            NSLog(@"dic===%@",dic);
//            if (![bbsInfo isEqualToString:NOW_VERSION])
//            {
//                NSString * new = [NSString stringWithFormat:@"我们的%@版本已经上线了,赶快去更新吧!",bbsInfo];
//                
//                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"发现新版本" message:new delegate:self cancelButtonTitle:@"立即升级" otherButtonTitles:@"稍后提示",nil];
//                
//                alert.delegate = self;
//                
//                alert.tag = 10000;
//                
//                [alert show];
//                
//                
//            }else
//            {
//                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"版本更新检查" message:@"您目前使用的是最新版本" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
//                [alert show];
//            }
//        }
//        @catch (NSException *exception) {
//            
//        }
//        @finally {
//            
//        }
//        
//        
//        
//    }];
//    
//    
//    [_request setFailedBlock:^{
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测失败,请检查您当前网络是否正常" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
//        [alert show];
//    }];
//    
//    [request startAsynchronous];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
