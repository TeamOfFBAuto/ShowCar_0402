//
//  LCWTools.m
//  FBAuto
//
//  Created by lichaowei on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "LTools.h"
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"
#import "UIView+Frame.h"
#import "UIImage+ImageEffects.h"

#import "ChatViewController.h"

@implementation LTools
{
    NSMutableData *_data;
}

+ (id)shareInstance
{
    static dispatch_once_t once_t;
    static LTools *dataBlock;
    
    dispatch_once(&once_t, ^{
        dataBlock = [[LTools alloc]init];
    });
    
    return dataBlock;
}

///截图并模糊处理
+(UIImage *)screenShot
{
    UIGraphicsBeginImageContextWithOptions([UIApplication sharedApplication].keyWindow.bounds.size,YES,0.0f);
    [[UIApplication sharedApplication].keyWindow drawViewHierarchyInRect:[UIApplication sharedApplication].keyWindow.bounds afterScreenUpdates:YES];
    UIImage *uiImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage * screenShot = [uiImage applyBlurWithRadius:3 tintColor:[UIColor colorWithWhite:0.2 alpha:0.1] saturationDeltaFactor:1.0 maskImage:nil];
    
    return screenShot;
}

#pragma - mark MD5 加密

+ (NSString *) md5:(NSString *) text
{
    const char * bytes = [text UTF8String];
    unsigned char md5Binary[16];
    CC_MD5(bytes, (CC_LONG)strlen(bytes), md5Binary);
    
    NSString * md5String = [NSString
                            stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                            md5Binary[0], md5Binary[1], md5Binary[2], md5Binary[3],
                            md5Binary[4], md5Binary[5], md5Binary[6], md5Binary[7],
                            md5Binary[8], md5Binary[9], md5Binary[10], md5Binary[11],
                            md5Binary[12], md5Binary[13], md5Binary[14], md5Binary[15]
                            ];
    return md5String;
}

#pragma - mark 网络数据请求

+ (void)getRequestWithBaseUrl:(NSString *)baseUrl
                parameters:(NSDictionary *)paramsDic
                   completion:(void(^)(NSDictionary *result,NSError *erro))completionBlock
                    failBlock:(void(^)(NSDictionary *result,NSError *erro))failBlock
{
    baseUrl = [baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *operation = [[AFHTTPRequestOperationManager alloc]init];
    
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];;
    
    [operation GET:baseUrl parameters:paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            
                                            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
                                            
                                            if ([result isKindOfClass:[NSDictionary class]]) {
                                                
                                                int erroCode = [[result objectForKey:@"errcode"]intValue];
                                                NSString *erroInfo = [result objectForKey:@"errinfo"];
                                                
                                                if (erroCode != 0) { //0代表无错误,  && erroCode != 1 1代表无结果
                                                    
                                                    NSDictionary *failDic = @{ERROR_INFO:erroInfo,@"errcode":[NSString stringWithFormat:@"%d",erroCode]};
                                                    failBlock(failDic,0);
                                                    
                                                    return ;
                                                }else
                                                {
                                                    completionBlock(result,0);//传递的已经是没有错误的结果
                                                }
                                                
                                            }
                                            
                                            
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            
                                            NSLog(@"---->response %@",operation.responseString);
                                            
                                            
                                            NSString *errInfo = @"网络有问题,请检查网络";
                                            switch (error.code) {
                                                case NSURLErrorNotConnectedToInternet:
                                                    
                                                    errInfo = @"无网络连接";
                                                    break;
                                                case NSURLErrorTimedOut:
                                                    
                                                    errInfo = @"网络连接超时";
                                                    break;
                                                default:
                                                    break;
                                            }
                                            
                                            NSDictionary *failDic = @{ERROR_INFO: errInfo};
                                            failBlock(failDic,error);
                                            
                                        }];
    
}


- (id)initWithUrl:(NSString *)url isPost:(BOOL)isPost postData:(NSData *)postData//post
{
    self = [super init];
    if (self) {
        requestUrl = url;
        
        if (isPost) {
            requestData = postData;
            isPostRequest = isPost;
        }
    }
    return self;
}

- (void)requestCompletion:(void(^)(NSDictionary *result,NSError *erro))completionBlock failBlock:(void(^)(NSDictionary *failDic,NSError *erro))failedBlock{
    _successBlock = completionBlock;
    _failBlock = failedBlock;
    
    NSString *newStr = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"requestUrl %@",newStr);
    NSURL *urlS = [NSURL URLWithString:newStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlS cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    
    if (isPostRequest) {
        
        [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:requestData];
    }
    
    connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    [connection start];
}

- (void)cancelRequest
{
    NSLog(@"取消请求");
    [connection cancel];
}

#pragma mark - 版本更新信息

- (void)versionForAppid:(NSString *)appid Block:(void(^)(BOOL isNewVersion,NSString *updateUrl,NSString *updateContent))version//是否有新版本、新版本更新下地址
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //test FBLife 605673005 fbauto 904576362
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appid];
    
    NSString *newStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"requestUrl %@",newStr);
    NSURL *urlS = [NSURL URLWithString:newStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlS cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (data.length > 0) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:Nil];
            
            NSArray *results = [dic objectForKey:@"results"];
            
            if (results.count == 0) {
                version(NO,@"no",@"没有更新");
                return ;
            }
            
            //appStore 版本
            NSString *newVersion = [[results objectAtIndex:0]objectForKey:@"version"];
            
            NSString *updateContent = [[results objectAtIndex:0]objectForKey:@"releaseNotes"];
            //本地版本
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            _downUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8",appid];
            
            //            _downUrl = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/crash-drive-2/id765099329?mt=12"];
            BOOL isNew = NO;
            if (newVersion && ([newVersion compare:currentVersion] == 1)) {
                isNew = YES;
            }
            
            version(isNew,_downUrl,updateContent);
            
            if (isNew) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"版本更新" message:updateContent delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即更新", nil];
                [alert show];
            }
            
        }else
        {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            NSLog(@"data 为空 connectionError %@",connectionError);
            
            NSString *errInfo = @"网络有问题,请检查网络";
            switch (connectionError.code) {
                case NSURLErrorNotConnectedToInternet:
                    
                    errInfo = @"无网络连接";
                    break;
                case NSURLErrorTimedOut:
                    
                    errInfo = @"网络连接超时";
                    break;
                default:
                    break;
            }
            
            NSDictionary *failDic = @{ERROR_INFO: errInfo};
            
            NSLog(@"version erro %@",failDic);
            
        }
        
    }];
    
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_downUrl]];
    }
}


+ (void)versionForAppid:(NSString *)appid Block:(void(^)(BOOL isNewVersion,NSString *updateUrl,NSString *updateContent))version//是否有新版本、新版本更新下地址
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //test FBLife 605673005
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appid];
    
    NSString *newStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"requestUrl %@",newStr);
    NSURL *urlS = [NSURL URLWithString:newStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlS cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (data.length > 0) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:Nil];
            
            NSArray *results = [dic objectForKey:@"results"];
            
            if (results.count == 0) {
                version(NO,@"no",@"没有更新");
                return ;
            }
            
            //appStore 版本
            NSString *newVersion = [[[dic objectForKey:@"results"] objectAtIndex:0]objectForKey:@"version"];
            NSString *updateContent = [[[dic objectForKey:@"results"] objectAtIndex:0]objectForKey:@"releaseNotes"];
            //本地版本
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            NSString *downUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8",appid];
            BOOL isNew = NO;
            if (newVersion && ([newVersion compare:currentVersion] == 1)) {
                isNew = YES;
            }
            version(isNew,downUrl,updateContent);
            
        }else
        {
            NSLog(@"data 为空 connectionError %@",connectionError);
            
            NSString *errInfo = @"网络有问题,请检查网络";
            switch (connectionError.code) {
                case NSURLErrorNotConnectedToInternet:
                    
                    errInfo = @"无网络连接";
                    break;
                case NSURLErrorTimedOut:
                    
                    errInfo = @"网络连接超时";
                    break;
                default:
                    break;
            }
            
            NSDictionary *failDic = @{ERROR_INFO: errInfo};
            
            NSLog(@"version erro %@",failDic);
            
        }
        
    }];

}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    _data = [NSMutableData data];
    
    NSLog(@"response :%@",response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    
    if (_data.length > 0) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
        
        if ([dic isKindOfClass:[NSDictionary class]]) {
            
            int erroCode = [[dic objectForKey:@"errcode"]intValue];
            NSString *erroInfo = [dic objectForKey:@"errinfo"];
            
            
            
            if (erroCode != 0) { //0代表无错误,  && erroCode != 1 1代表无结果
                
                
                NSDictionary *failDic = @{ERROR_INFO:erroInfo,@"errcode":[NSString stringWithFormat:@"%d",erroCode]};
                _failBlock(failDic,0);
                
                return ;
            }else
            {
                _successBlock(dic,0);//传递的已经是没有错误的结果
            }
        }
        
    }
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSLog(@"data 为空 connectionError %@",error);
    
    NSString *errInfo = @"网络有问题,请检查网络";
    switch (error.code) {
        case NSURLErrorNotConnectedToInternet:
            
            errInfo = @"无网络连接";
            break;
        case NSURLErrorTimedOut:
            
            errInfo = @"网络连接超时";
            break;
        default:
            break;
    }
    
    NSDictionary *failDic = @{ERROR_INFO: errInfo};
    _failBlock(failDic,error);
    
}


+ (UIImage *)sd_imageForUrl:(NSString *)url
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString *imageKey = [manager cacheKeyForURL:[NSURL URLWithString:url]];

    SDImageCache *cache = [SDImageCache sharedImageCache];
    UIImage *cacheImage = [cache imageFromDiskCacheForKey:imageKey];

    return cacheImage;
}

+(NSString *)returnSmallImageWithUserId:(NSString *)userId
{
    NSString * uid = userId;
    
    if (uid.length !=0 && uid.length < 9)
    {
        for (int i = 0;i < uid.length -9;i++)
        {
            uid = [NSString stringWithFormat:@"%d%@",0,uid];
        }
    }
    
    NSString * string;
    if (uid.length ==0)
    {
        string = @"";
    }else
    {
        string =  [NSString stringWithFormat:@"http://avatar.fblife.com/%@/%@/%@/%@_avatar_small.jpg",[[uid substringToIndex:3] substringFromIndex:0],[[uid substringToIndex:5] substringFromIndex:3],[[uid substringToIndex:7] substringFromIndex:5],[[uid substringToIndex:9] substringFromIndex:7]];
    }
    
    return string;
}

+(NSString *)returnMiddleImageWithUserId:(NSString *)userId
{
    NSString * uid = userId;
    
    if (uid.length !=0 && uid.length < 9)
    {
        for (int i = 0;i < uid.length -9;i++)
        {
            uid = [NSString stringWithFormat:@"%d%@",0,uid];
        }
    }
    
    NSString * string;
    if (uid.length ==0)
    {
        string = @"";
    }else
    {
        string =  [NSString stringWithFormat:@"http://avatar.fblife.com/%@/%@/%@/%@_avatar_middle.jpg",[[uid substringToIndex:3] substringFromIndex:0],[[uid substringToIndex:5] substringFromIndex:3],[[uid substringToIndex:7] substringFromIndex:5],[[uid substringToIndex:9] substringFromIndex:7]];
    }
    
    return string;
}



#pragma mark - NSUserDefault缓存

//存
+ (void)cache:(id)dataInfo ForKey:(NSString *)key
{
    
    @try {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:nil forKey:key];
        [defaults setObject:dataInfo forKey:key];
        [defaults synchronize];
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"exception %@",exception);
        
    }
    @finally {
        
    }
    
}

//取
+ (id)cacheForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}


+ (void)cacheBool:(BOOL)boo ForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults]setBool:boo forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (BOOL)cacheBoolForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:key];
}

#pragma mark - 融云用户数据

//与某人聊天
+ (void)rongCloudChatWithUserId:(NSString *)userId
                       userName:(NSString *)userName
                 viewController:(UIViewController *)viewController
{
    if ([userId isEqualToString:[GMAPI getUid]]) {
        
        [LTools showMBProgressWithText:@"您不能和自己发起会话" addToView:viewController.view];
        
        return;
    }
    
    if (userId.length == 0) {
        [LTools showMBProgressWithText:@"您咨询的对象不存在" addToView:viewController.view];
        return;
    }
    
    userName = userName.length > 0 ? userName : @"";
    
    if ([LTools cacheBoolForKey:USER_IN]) {
        //已登录成功自己服务器
        
        ChatViewController *contact = [[ChatViewController alloc]init];
        contact.currentTarget = userId;
        contact.currentTargetName = userName;
        contact.shopName = userName;
        contact.portraitStyle = RCUserAvatarCycle;
        contact.enableSettings = NO;
        contact.conversationType = ConversationType_PRIVATE;
        //        contact.enablePOI = NO;
        [LTools cacheRongCloudUserName:userName forUserId:userId];
        
        [viewController.navigationController pushViewController:contact animated:YES];
        
    }else
    {
        [[NewLogInView loginShareInstance]showLogin];
    }
}


+ (void)cacheRongCloudUserName:(NSString *)userName forUserId:(NSString *)userId
{
    NSString *key = [NSString stringWithFormat:@"userName_%@",userId];
    [LTools cache:userName ForKey:key];
}

+ (NSString *)rongCloudUserNameWithUid:(NSString *)userId
{
    NSString *key = [NSString stringWithFormat:@"userName_%@",userId];
    return [LTools cacheForKey:key];
}

+ (void)cacheRongCloudUserIcon:(NSString *)iconUrl forUserId:(NSString *)userId
{
    NSString *key = [NSString stringWithFormat:@"userIcon_%@",userId];
    [LTools cache:iconUrl ForKey:key];
}

+ (NSString *)rongCloudUserIconWithUid:(NSString *)userId
{
    NSString *key = [NSString stringWithFormat:@"userIcon_%@",userId];
    return [LTools cacheForKey:key];
}

#pragma mark - 常用视图快速创建


/**
 *  通过xib创建cell
 *
 *  @param identify  标识名称
 *  @param tableView
 *  @param cellName
 *
 *  @return cell
 */
+ (UITableViewCell *)cellForIdentify:(NSString *)identify
                            cellName:(NSString *)cellName
                            forTable:(UITableView *)tableView
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellName owner:self options:nil]objectAtIndex:0];
    }
    return cell;
}

+ (UIButton *)createButtonWithType:(UIButtonType)buttonType
                             frame:(CGRect)aFrame
                             normalTitle:(NSString *)normalTitle
                             image:(UIImage *)normalImage
                    backgroudImage:(UIImage *)bgImage
                         superView:(UIView *)superView
                            target:(id)target
                            action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:buttonType];
    btn.frame = aFrame;
    [btn setTitle:normalTitle forState:UIControlStateNormal];
    [btn setImage:normalImage forState:UIControlStateNormal];
    [btn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:btn];
    return btn;
}

+ (UILabel *)createLabelFrame:(CGRect)aFrame
                        title:(NSString *)title
                         font:(CGFloat)size
                        align:(NSTextAlignment)align
                    textColor:(UIColor *)textColor
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:aFrame];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:size];
    titleLabel.textAlignment = align;
    titleLabel.textColor = textColor;
    return titleLabel;
}

/**
 *  计算宽度
 */
+ (CGFloat)widthForText:(NSString *)text font:(CGFloat)size
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:size]};
    CGSize aSize = [text sizeWithAttributes:attributes];
    return aSize.width;
}

+ (CGFloat)widthForText:(NSString *)text boldFont:(CGFloat)size
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:size]};
    CGSize aSize = [text sizeWithAttributes:attributes];
    return aSize.width;
}

+ (CGFloat)heightForText:(NSString *)text width:(CGFloat)width font:(CGFloat)size
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:size]};
    CGSize aSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:Nil].size;
    return aSize.height;
}

+ (CGFloat)heightForText:(NSString *)text width:(CGFloat)width Boldfont:(CGFloat)size
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:size]};
    CGSize aSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:Nil].size;
    return aSize.height;
}

#pragma mark - 验证有消息

//是否是字典
+ (BOOL)isDictinary:(id)object
{
    if ([object isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    return NO;
}

#pragma - mark 验证邮箱、电话等有效性

/*匹配正整数*/
+ (BOOL)isValidateInt:(NSString *)digit
{
    NSString * digitalRegex = @"^[1-9]\\d*$";
    NSPredicate * digitalTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",digitalRegex];
    return [digitalTest evaluateWithObject:digit];
}

/*匹配整浮点数*/
+ (BOOL)isValidateFloat:(NSString *)digit
{
    NSString * digitalRegex = @"^[1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*$";
    NSPredicate * digitalTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",digitalRegex];
    return [digitalTest evaluateWithObject:digit];
}

/*邮箱*/
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString * emailRegex = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
    NSPredicate * emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isValidateName:(NSString *)userName
{
    NSString * emailRegex = @"^[\u4E00-\u9FA5a-zA-Z0-9_]{1,20}$";
    NSPredicate * emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailTest evaluateWithObject:userName];
}

+ (BOOL)isValidatePwd:(NSString *)pwdString
{
    NSString * emailRegex = @"^[a-zA-Z0-9_]{6,20}$";
    NSPredicate * emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailTest evaluateWithObject:pwdString];
}

/*手机及固话*/
+ (BOOL)isValidateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma - mark 小工具

/**
 *  去除开头的空格
 */
+ (NSString *)stringHeadNoSpace:(NSString *)string
{
    string = string.length == 0 ? @"" : string;
    NSMutableString *mu_str = [NSMutableString stringWithString:string];
    [mu_str replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, mu_str.length)];
    return mu_str;
}

+(NSString*)timestamp:(NSString*)myTime{
    
    NSString *timestamp;
    time_t now;
    time(&now);
    
    int distance = (int)difftime(now,  [myTime integerValue]);
    if (distance < 0) distance = 0;
    
    if (distance < 60) {
        timestamp = [NSString stringWithFormat:@"%d%@", distance, @"秒钟前"];
    }
    else if (distance < 60 * 60) {
        distance = distance / 60;
        timestamp = [NSString stringWithFormat:@"%d%@", distance, @"分钟前"];
    }
    else if (distance < 60 * 60 * 24) {
        distance = distance / 60 / 60;
        timestamp = [NSString stringWithFormat:@"%d%@", distance,@"小时前"];
    }
    else if (distance < 60 * 60 * 24 * 7) {
        distance = distance / 60 / 60 / 24;
        timestamp = [NSString stringWithFormat:@"%d%@", distance,@"天前"];
    }
    else if (distance < 60 * 60 * 24 * 7 * 4) {
        distance = distance / 60 / 60 / 24 / 7;
        timestamp = [NSString stringWithFormat:@"%d%@", distance, @"周前"];
    }else
    {
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
        NSDate *date = [NSDate dateWithTimeIntervalSince1970: [myTime integerValue]];
        
        timestamp = [dateFormatter stringFromDate:date];
    }
    
    return timestamp;
}


//当前时间转换为 时间戳

+(NSString *)timechangeToDateline
{
    return [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
}

//时间线转化

+(NSString *)timechange:(NSString *)placetime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[placetime doubleValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+(NSString *)timechange2:(NSString *)placetime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[placetime doubleValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+(NSString *)timechange3:(NSString *)placetime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY年MM月"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[placetime doubleValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}


+ (NSString *)currentTime
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    
    [outputFormatter setLocale:[NSLocale currentLocale]];
    
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *date = [outputFormatter stringFromDate:[NSDate date]];
    
    NSLog(@"时间 === %@",date);
    return date;
}

/**
 *  是否需要更新
 *
 *  @param hours      时间间隔
 *  @param recordDate 上次记录时间
 *
 *  @return 是否需要更新
 */
+ (BOOL)needUpdateForHours:(CGFloat)hours recordDate:(NSDate *)recordDate
{
    if (recordDate) {
        
        NSTimeInterval timeIn = [recordDate timeIntervalSinceNow];
        
        CGFloat daySeconds = hours * 60 * 60.f;//秒数
        
        if ((timeIn * -1) >= daySeconds) { //预定时间
            
            return YES;
        }else
        {
            return NO;
        }
    }
    
    return YES;
}

//alert 提示

+ (void)alertText:(NSString *)text
{
    id obj=NSClassFromString(@"UIAlertController");
    if (obj) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:text preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        [alertController addAction:cancelAction];
        
        
        UIViewController *viewC = [UIApplication sharedApplication].keyWindow.rootViewController;
        
        [viewC presentViewController:alertController animated:YES completion:^{
            
        }];
        
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:text delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}


+ (void)showMBProgressWithText:(NSString *)text addToView:(UIView *)aView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 15.f;
//    hud.yOffset = DEVICE_HEIGHT / 2.f;
//    hud.centerY = DEVICE_HEIGHT / 2.f;
    
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

+ (MBProgressHUD *)MBProgressWithText:(NSString *)text addToView:(UIView *)aView
{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:aView];
//    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
//    hud.margin = 15.f;
//    hud.yOffset = 0.0f;
    [aView addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

#pragma - mark 非空字符串

+(NSString *)numberToString:(long)number
{
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    NSString *numberString = [numberFormatter stringFromNumber: [NSNumber numberWithInteger: number]];
    return numberString;
}


+ (NSString *)NSStringNotNull:(NSString *)text
{
    if (![text isKindOfClass:[NSString class]]) {
        return @"";
    }else if ([text isEqualToString:@"(null)"]){
        return @"";
    }
    return text;
}
/**
 *  给字符串加逗号
 *
 *  @param string 源字符串 如： 123456.78 或者 123456
 *
 *  @return 逗号分割字符串  1,234,567.89 或者 123,456
 */

+ (NSString *)NSStringAddComma:(NSString *)string{//添加逗号
    
    if (string == nil) {
        return @"";
    }
    
    NSRange range = [string rangeOfString:@"."];
    
    NSMutableString *temp = [NSMutableString stringWithString:string];
    int i;
    if (range.length > 0) {
        //有.
        
        i = (int)range.location;
        
    }else
    {
        i = (int)string.length;
    }
    
    while ((i-=3) > 0) {
        
        [temp insertString:@"," atIndex:i];
    }
    
    return temp;
    
}

/**
 *  行间距string
 */

+ (NSAttributedString *)attributedString:(NSString *)string lineSpaceing:(CGFloat)lineSpage
{
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:lineSpage];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [string length])];
    
    return attributedString1;
}


/**
 *  关键词特殊显示
 *
 *  @param content   源字符串
 *  @param aKeyword  关键词
 *  @param textColor 关键词颜色
 */
+ (NSAttributedString *)attributedString:(NSString *)content keyword:(NSString *)aKeyword color:(UIColor *)textColor
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:content];
    
    if (content.length <= aKeyword.length) {
        return string;
    }
    
    for (int i = 0; i <= content.length - aKeyword.length; i ++) {
        
        NSRange tmp = NSMakeRange(i, aKeyword.length);
        
        NSRange range = [content rangeOfString:aKeyword options:NSCaseInsensitiveSearch range:tmp];
        
        if (range.location != NSNotFound) {
            [string addAttribute:NSForegroundColorAttributeName value:textColor range:range];
        }
    }
    
    return string;
}
/**
 *  每次只给一个关键词加高亮颜色
 *
 *  @param attibutedString 可以为空
 *  @param string          attibutedString 为空时,用此进行初始化;并且用于找到关键词的range
 *  @param keyword         需要高亮的部分
 *  @param color           高亮的颜色
 *
 *  @return NSAttributedString
 */
+ (NSAttributedString *)attributedString:(NSMutableAttributedString *)attibutedString originalString:(NSString *)string AddKeyword:(NSString *)keyword color:(UIColor *)color
{
    if (attibutedString == nil) {
        attibutedString = [[NSMutableAttributedString alloc]initWithString:string];
    }
    
    if (keyword.length == 0) {
        keyword = @"";
    }
    
    NSRange range = [string rangeOfString:keyword options:NSCaseInsensitiveSearch range:NSMakeRange(0, string.length)];
    
    [attibutedString addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    return attibutedString;
}

+ (BOOL)NSStringIsNull:(NSString *)string
{
    NSMutableString *str = [NSMutableString stringWithString:string];
    [str replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, str.length)];
    if (str.length == 0) {
        return YES;
    }
    return NO;
}

#pragma - mark 切图

+(UIImage *)scaleToSizeWithImage:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark - 分类论坛图片获取

+ (UIImage *)imageForBBSId:(NSString *)bbsId
{
    NSString *name = [NSString stringWithFormat:@"mirco_icon_%@",bbsId];
    UIImage *image = [UIImage imageNamed:name];
    return image;
}


@end
