//
//  AppDelegate.m
//  ShowCar
//
//  Created by lichaowei on 15/3/24.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

#import "MobClick.h"

#import "RCIMClient.h"

#import "BMapKit.h"


//改装志 和 酷车志 晒车 用同一个key
#define Rong_AppKey_Develope @"e0x9wycfxjyaq"
#define Rong_AppSecret_Develope @"ePqoE3K7SuSgTH"

//晒车
#define UMENG_APPKEY @"55092f23fd98c54774000331"


//晒车 appid

#define APPID_APPSTORE @"784258347"

//百度
#define BAIDU_APPKEY @"APMdmYcmGzQGBs3MUzr086Fk"


@interface AppDelegate ()<RCIMConnectionStatusDelegate,RCConnectDelegate,RCIMReceiveMessageDelegate,RCIMUserInfoFetcherDelegagte,BMKGeneralDelegate,CLLocationManagerDelegate>
{
    CLLocationManager    *location;

}

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
#pragma mark - 友盟统计
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:REALTIME channelId:nil];
    [MobClick setLogEnabled:YES];
#pragma mark - 融云
    
    [RCIM initWithAppKey:Rong_AppKey_Develope deviceToken:nil];
    
    [[RCIM sharedRCIM]setConnectionStatusDelegate:self];//监控连接状态
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];//接受消息
    [RCIM setUserInfoFetcherWithDelegate:self isCacheUserInfo:YES];
    
    //系统登录成功通知 登录融云
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginToRongCloud) name:NOTIFICATION_LOGIN_SUCCESS object:nil];
    
    [self rongCloudDefaultLoginWithToken:[LTools cacheForKey:RONGCLOUD_TOKEN]];
    
    
    
#pragma mark - 定位
    
    location = [[CLLocationManager alloc] init];
    location.delegate= self;
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=8.0)) {
        
        [location requestAlwaysAuthorization];
    }

    
#ifdef __IPHONE_8_0
    // 在 iOS 8 下注册苹果推送，申请推送权限。
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
#else
    // 注册苹果推送，申请推送权限。
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
#endif
    
    
#pragma mark 版本检测
    
    //版本更新
    
    [[LTools shareInstance]versionForAppid:APPID_APPSTORE Block:^(BOOL isNewVersion, NSString *updateUrl, NSString *updateContent) {
        
        NSLog(@"updateContent %@ %@",updateUrl,updateContent);
        
    }];

    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    RootViewController *root = [[RootViewController alloc]init];
    self.window.rootViewController = root;
    self.window.backgroundColor = [UIColor whiteColor];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = [[RCIM sharedRCIM] getTotalUnreadCount];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // Register to receive notifications.
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    // Handle the actions.
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

// 获取苹果推送权限成功。
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 设置 deviceToken。
    [[RCIM sharedRCIM] setDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"RegisterForRemote Erro");
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    NSLog(@" 收到推送消息： %@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
}


#pragma - mark - 获取融云token -

- (void)loginToRongCloud
{
    [self loginToRoncloudUserId:[GMAPI getUid] userName:[GMAPI getUsername] userHeadImage:[LTools returnMiddleImageWithUserId:[GMAPI getUid]]];
}

- (void)loginToRoncloudUserId:(NSString *)userId
                     userName:(NSString *)userName
                userHeadImage:(NSString *)headImage
{
    
    if (headImage.length == 0) {
        headImage = @"nnn";
    }
    
    NSString *url = [NSString stringWithFormat:RONCLOUD_GET_TOKEN,userId,userName,headImage];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result %@",result);
        
        [LTools cache:result[@"token"] ForKey:RONGCLOUD_TOKEN];
        
        [self rongCloudDefaultLoginWithToken:result[@"token"]];
        
        
    } failBlock:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"获取融云token失败 %@",result);
        
        [LTools showMBProgressWithText:result[ERROR_INFO] addToView:self.window];
        
    }];
}


- (void)rongCloudDefaultLoginWithToken:(NSString *)loginToken
{
    //默认测试
    
    if (loginToken.length > 0) {
        
        
        __weak typeof(self)weakSelf = self;
        [RCIM connectWithToken:loginToken completion:^(NSString *userId) {
            
            NSLog(@"------> rongCloud 登陆成功 %@",userId);
            
            //            [LTools cacheBool:YES ForKey:LOGIN_RONGCLOUD_STATE];
            
        } error:^(RCConnectErrorCode status) {
            
            NSLog(@"------> rongCloud 登陆失败 %d",(int)status);
            
            //            [LTools cacheBool:NO ForKey:LOGIN_RONGCLOUD_STATE];
            
            if (status == ConnectErrorCode_TOKEN_INCORRECT) {
                //错误的令牌 服务器重新获取
                
                [weakSelf loginToRongCloud];
            }
            
        }];
    }
}

#pragma mark - RCIMReceiveMessageDelegate

-(void)didReceivedMessage:(RCMessage *)message left:(int)nLeft
{
    if (0 == nLeft) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber+1;
        });
    }
    
    
    [[RCIM sharedRCIM] invokeVoIPCall:self.window.rootViewController message:message];
}

#pragma mark - RCIMUserInfoFetcherDelegagte method

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    NSString *userName = [LTools rongCloudUserNameWithUid:userId];
    
    if ([userId isEqualToString:[GMAPI getUid]]) {
        
        userName = [GMAPI getUsername];
    }
    
    if ([userName isKindOfClass:[NSString class]] && userName.length == 0) {
        NSString *url = [NSString stringWithFormat:@"%@&uid=%@",USERINFO,userId];
        LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
        [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
            
            NSDictionary *dic = [result objectForKey:@"datainfo"];
            
            NSString *name = dic[@"username"];
            
            if ([name isKindOfClass:[NSString class]] && name.length > 0) {
                
                [LTools cacheRongCloudUserName:name forUserId:userId];
            }
            
            RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:userId name:name portrait:[LTools returnMiddleImageWithUserId:userId]];
            
            return completion(userInfo);
            
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            
        }];
    }
    
    RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:userId name:userName portrait:[LTools returnMiddleImageWithUserId:userId]];
    
    return completion(userInfo);
}


#pragma mark - RCIMConnectionStatusDelegate <NSObject>

-(void)responseConnectionStatus:(RCConnectionStatus)status{
    if (ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT == status) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"----->被踢下线 %ld",status);
            
            
        });
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (2000 == alertView.tag) {
        
        if (0 == buttonIndex) {
            
            NSLog(@"NO");
        }
        
        if (1 == buttonIndex) {
            
            NSLog(@"YES");
            
            [RCIMClient reconnect:self];
        }
    }
    
}

#pragma mark - ReConnectDelegate
/**
 *  回调成功。
 *
 *  @param userId 当前登录的用户 Id，既换取登录 Token 时，App 服务器传递给融云服务器的用户 Id。
 */
- (void)responseConnectSuccess:(NSString*)userId{
    
    NSLog(@"userId %@ rongCloud登录成功",userId);
}

/**
 *  回调出错。
 *
 *  @param errorCode 连接错误代码。
 */
- (void)responseConnectError:(RCConnectErrorCode)errorCode
{
    NSLog(@"rongCloud重新连接失败--- %d",(int)errorCode);
    
    if (errorCode == ConnectErrorCode_TOKEN_INCORRECT) {
        //错误的令牌 服务器重新获取
        
        [self loginToRongCloud];
    }
}


@end
