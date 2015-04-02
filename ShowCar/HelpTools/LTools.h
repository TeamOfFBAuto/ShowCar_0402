//
//  LCWTools.h
//  FBAuto
//
//  Created by lichaowei on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"

#import "UIColor+ConvertColor.h"

#define ERROR_INFO @"errinfo" //错误信息

typedef void(^ urlRequestBlock)(NSDictionary *result,NSError *erro);

typedef void(^versionBlock)(BOOL isNewVersion,NSString *updateUrl,NSString *updateContent);//版本更新

@interface LTools : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    urlRequestBlock _successBlock;
    urlRequestBlock _failBlock;
    versionBlock aVersionBlock;
    
    NSString *requestUrl;
    NSData *requestData;
    BOOL isPostRequest;//是否是post请求
    
    NSURLConnection *connection;
    
    NSString *_appid;
    
    NSString *_downUrl;//更新地址
}

+ (id)shareInstance;

+(UIImage *)screenShot;


+ (void)getRequestWithBaseUrl:(NSString *)baseUrl
                   parameters:(NSDictionary *)paramsDic
                   completion:(void(^)(NSDictionary *result,NSError *erro))completionBlock
                    failBlock:(void(^)(NSDictionary *result,NSError *erro))failBlock;


/**
 *  网络请求
 */
- (id)initWithUrl:(NSString *)url isPost:(BOOL)isPost postData:(NSData *)postData;//初始化请求

- (void)requestCompletion:(void(^)(NSDictionary *result,NSError *erro))completionBlock failBlock:(void(^)(NSDictionary *failDic,NSError *erro))failedBlock;//处理请求结果

- (void)cancelRequest;


- (void)versionForAppid:(NSString *)appid Block:(void(^)(BOOL isNewVersion,NSString *updateUrl,NSString *updateContent))version;
/**
 *  版本更新
 */
+ (void)versionForAppid:(NSString *)appid Block:(void(^)(BOOL isNewVersion,NSString *updateUrl,NSString *updateContent))version;//是否有新版本、新版本更新下地址

+ (UIImage *)sd_imageForUrl:(NSString *)url;

/**
 *  NSUserDefault 缓存
 */
//存
+ (void)cache:(id)dataInfo ForKey:(NSString *)key;
//取
+ (id)cacheForKey:(NSString *)key;

+ (void)cacheBool:(BOOL)boo ForKey:(NSString *)key;

+ (BOOL)cacheBoolForKey:(NSString *)key;

#pragma mark - 融云用户数据

+ (void)rongCloudChatWithUserId:(NSString *)userId
                       userName:(NSString *)userName
                 viewController:(UIViewController *)viewController;

+ (void)cacheRongCloudUserName:(NSString *)userName forUserId:(NSString *)userId;

+ (NSString *)rongCloudUserNameWithUid:(NSString *)userId;

+ (void)cacheRongCloudUserIcon:(NSString *)iconUrl forUserId:(NSString *)userId;

+ (NSString *)rongCloudUserIconWithUid:(NSString *)userId;

#pragma mark - 常用视图快速创建

+ (UITableViewCell *)cellForIdentify:(NSString *)identify
                            cellName:(NSString *)cellName
                            forTable:(UITableView *)tableView;

+ (UIButton *)createButtonWithType:(UIButtonType)buttonType
                             frame:(CGRect)aFrame
                       normalTitle:(NSString *)normalTitle
                             image:(UIImage *)normalImage
                    backgroudImage:(UIImage *)bgImage
                         superView:(UIView *)superView
                            target:(id)target
                            action:(SEL)action;

+ (UILabel *)createLabelFrame:(CGRect)aFrame
                        title:(NSString *)title
                         font:(CGFloat)size
                        align:(NSTextAlignment)align
                    textColor:(UIColor *)textColor;

#pragma mark - 计算宽度、高度

+ (CGFloat)widthForText:(NSString *)text font:(CGFloat)size;
+ (CGFloat)widthForText:(NSString *)text boldFont:(CGFloat)size;
+ (CGFloat)heightForText:(NSString *)text width:(CGFloat)width font:(CGFloat)size;
+ (CGFloat)heightForText:(NSString *)text width:(CGFloat)width Boldfont:(CGFloat)size;//加粗

#pragma mark - 小工具

+ (NSString *)stringHeadNoSpace:(NSString *)string;

+ (NSString *) md5:(NSString *) text;
+ (void)alertText:(NSString *)text;
+(NSString *)timechange:(NSString *)placetime;
+(NSString *)timechange2:(NSString *)placetime;
+(NSString *)timechange3:(NSString *)placetime;

+(NSString *)timechangeToDateline;//转换为时间戳

+(NSString*)timestamp:(NSString*)myTime;//模糊时间,如几天前

+ (NSString *)currentTime;//当前时间 yyyy-mm-dd

+ (BOOL)needUpdateForHours:(CGFloat)hours recordDate:(NSDate *)recordDate;//计算既定时间段是否需要更新

#pragma mark - 加载提示

+ (void)showMBProgressWithText:(NSString *)text addToView:(UIView *)aView;

+ (MBProgressHUD *)MBProgressWithText:(NSString *)text addToView:(UIView *)aView;

#pragma mark - 字符串的处理

+(NSString *)numberToString:(long)number;//千分位

+ (NSString *)NSStringNotNull:(NSString *)text;

+ (NSString *)NSStringAddComma:(NSString *)string; //添加逗号

+ (NSAttributedString *)attributedString:(NSString *)string lineSpaceing:(CGFloat)lineSpage;//行间距string

+ (NSAttributedString *)attributedString:(NSString *)content keyword:(NSString *)aKeyword color:(UIColor *)textColor;//关键词高亮

+ (NSAttributedString *)attributedString:(NSMutableAttributedString *)attibutedString originalString:(NSString *)string AddKeyword:(NSString *)keyword color:(UIColor *)color;//每次一个关键词高亮,多次调用

+ (BOOL)NSStringIsNull:(NSString *)string;//判断字符串是否全为空格

#pragma mark - 验证有效性

+ (BOOL)isDictinary:(id)object;//是否是字典

/**
 *  验证 邮箱、电话等
 */

+ (BOOL)isValidateInt:(NSString *)digit;
+ (BOOL)isValidateFloat:(NSString *)digit;
+ (BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)isValidateName:(NSString *)userName;
+ (BOOL)isValidatePwd:(NSString *)pwdString;
+ (BOOL)isValidateMobile:(NSString *)mobileNum;

/**
 *  切图
 */
+(UIImage *)scaleToSizeWithImage:(UIImage *)img size:(CGSize)size;


#pragma mark - CoreData管理

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)insertDataClassType:(NSString *)classType dataArray:(NSMutableArray*)dataArray unique:(NSString *)unique;
//查询
- (NSArray*)queryDataClassType:(NSString *)classType pageSize:(int)pageSize andOffset:(int)currentPage unique:(NSString *)unique;

#pragma mark - 分类论坛图片获取

+ (UIImage *)imageForBBSId:(NSString *)bbsId;

@end
