//
//  ConversationListViewController.h
//  RCIM
//
//  Created by Heq.Shinoda on 14-6-11.
//  Copyright (c) 2014年 Heq.Shinoda. All rights reserved.
//



#import "RCBasicViewController.h"
#import "RCIMClientHeader.h"
#import "RCSelectPersonViewController.h"
#import "RCGroupListViewController.h"

typedef NS_ENUM(NSInteger, IsAllowScroll){
    TableIsScroll = 0,
    TableIsForbiddenScroll
};
@interface RCChatListViewController : RCBasicViewController<RCSelectPersonViewControllerDelegate>
{
    NSTimeInterval startTime, endTime;
}
@property(nonatomic, strong) NSMutableArray* conversationStore;
//@property(nonatomic, strong) NSMutableArray* allConversationItemCell;
@property (strong, nonatomic) UITableView *conversationListView;
@property(nonatomic, assign) IsAllowScroll isAllowScroll;
@property(nonatomic, assign) NSInteger editingCellNum;
@property (nonatomic, strong) RCGroupListViewController* currentGroupListView;
@property (nonatomic) RCUserAvatarStyle portraitStyle;

/**
 *  启动一对一聊天
 *
 *  @param userInfo
 */
-(void)startPrivateChat:(RCUserInfo*)userInfo;
/**
 *  启动讨论组
 *
 *  @param userInfos
 */
-(void)startDiscussionChat:(NSArray*)userInfos;
/**
 *  导航左面按钮点击事件
 */
-(void)leftBarButtonItemPressed:(id)sender;
/**
 *  导航右面按钮点击事件
 */
-(void)rightBarButtonItemPressed:(id)sender;

/**
 *  刷新会话列表
 */
-(void)refreshChatListView;


/**
 *  会话列表选中调用
 *
 *  @param conversation 选中单元的会话信息；
 */
-(void)onSelectedTableRow:(RCConversation*)conversation;
/**
 *  把chatController的生命周期加入到ChatList管理中
 *
 *  @param controller
 */
-(void)addChatController:(UIViewController*)controller;
/**
 *  获取chatController
 *
 *  @param targetId
 *  @param conversationType
 *
 *  @return chatController
 */
-(id)getChatController:(NSString*)targetId conversationType:(RCConversationType)conversationType;

/**
 *  是否隐藏默认背景，并设置自定义背景，默认为NO
 */
-(BOOL) showCustomEmptyBackView;

@end
