//
//  ChatSessionViewController.h
//  RongCloud
//
//  Created by Heq.Shinoda on 14-4-22.
//  Copyright (c) 2014年 Heq.Shinoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCBasicViewController.h"
#import "RCIMClientHeader.h"
#import "RCLocationPickerViewController.h"
#import "RCLocationPickerViewController.h"

typedef NS_ENUM(NSInteger, KBottomBarStatus)
{
    KBottomBarStatusDefault = 0,
    KBottomBarStatusKeyboard,
    KBottomBarStatusMultiAction,
    KBottomBarStatusEmoji,
    KBottomBarStatusAudio
};

@class MessageDataModel;

@class RCAudioRecord;
@class RCEmojiView;
@class RCConversionDataSource;
@class RCMultiActionView;
@class RCPopupMenu;
@class RCPopupMenuItem;
@class RCVoiceCaptureControl;
@class RCChatSessionInputBarView;
@class RCConversationTableHeaderView;

typedef NS_ENUM(NSUInteger, RCMessageUserInteractionEvent) {
    RCMessageTapEvent = 0x0001 << 0,
    RCMessageLongPressEvent = 0x0001 << 1,
    RCMessageDoubleTapEvent = 0x0001 << 2,
    RCMessagePanEvent = 0x0001 << 3,
    RCMessagePinchEvent = 0x0001 << 4
};

typedef void (^didTapMessageHandler)(RCMessage *metadata);

@interface RCChatViewController : RCBasicViewController <RCSendMessageDelegate, RCLocationPickerViewControllerDelegate>
{
    KBottomBarStatus currentBottomBarStatus;
    BOOL isSendImage;
}

@property(nonatomic, copy)didTapMessageHandler messageTapHandler;
@property(nonatomic, strong) UIImagePickerController*curPicker;
@property(nonatomic, strong) RCConversionDataSource* conversionDataSource;
@property(nonatomic, strong) NSString* msgContent;
@property(nonatomic, strong) UITableView* chatListTableView;
@property (strong, nonatomic) RCChatSessionInputBarView *msgInputBar;

@property (strong, nonatomic) RCMultiActionView* multiActionView;
@property (strong, nonatomic) RCEmojiView *emojiView;

@property (strong, nonatomic) RCConversationTableHeaderView *tableHeaderView;

@property (nonatomic, assign) RCUserAvatarStyle portraitStyle;

@property (nonatomic,assign) RCConversationType conversationType;
@property (nonatomic,strong) NSString* currentTarget;
@property (nonatomic,strong) NSString* currentTargetName;

@property (nonatomic,assign,readonly) BOOL SendingCount;
@property (nonatomic,strong) RCVoiceCaptureControl *voiceCaptureControl;

//@property (nonatomic,strong) RCPopupMenu *popupMenu;

/** @name  可以设置的属性 */

/**
 *  是否屏蔽右导航按钮，默认YES
 */
@property (nonatomic ,assign) BOOL enableSettings;
/**
 *  是否开启VoIP
 */
@property (nonatomic,assign) BOOL enableVoIP;
/**
 *  是否开启右上角未读，默认开启 YES
 */
@property (nonatomic,assign) BOOL enableUnreadBadge;

/**
 *  是否开启地理位置信息
 */
@property (nonatomic,assign) BOOL enablePOI;


-(void)resendMessage:(NSNotification*)notification;

/** @name 消息发送接口 */

/**
 发送文本消息
 */
-(void)sendTextMessage;
-(void)sendRichContentMessage:(RCRichContentMessage *)message;
-(void)drag4ResetDefaultBottomBarStatus;

/**
 * @override,消息过滤，消息发送前调用，可以在发送前添加附加信息等等
 *
 */
-(RCMessageContent*)willSendMessage:(RCMessageContent *)message;

/**
 *  导航左面按钮点击事件
 */
-(void)leftBarButtonItemPressed:(id)sender;
/**
 *  导航右面按钮点击事件
 */
-(void)rightBarButtonItemPressed:(id)sender;
/**
 *  调用查看大图
 *
 *  @param rcMessage 消息体
 */
-(void)showPreviewPictureController:(RCMessage*)rcMessage;
/** 
 语音消息开始录音
 */
-(void)onBeginRecordEvent;
/**
 语音消息录音结束
 */
-(void)onEndRecordEvent;

/** @name 地理位置消息相关接口 */

/** 发送位置消息
 
 开发者可以直接调用该方法来发送地理位置消息。
 
 @param mapScreenShot 显示给用户的地图截图
 @param location 地理位置具体坐标
 @param locationName 地理位置名称
 */
- (void)sendLBSMessage:(UIImage*)mapScreenShot location:(CLLocationCoordinate2D)location locationName:(NSString*)locationName;

/** 打开位置选取界面
 
 点击“位置”按钮时，需要打开位置选取控件。用户可以实现该方法，跳转到自定义的位置选取界面。默认实现为打开<RCLocationPickerViewController>。
 */
- (void)openLocationPicker:(id)sender;
/** 根据坐标打开地图
 
 点击位置消息单元格时，会调用这个方法，进入地图界面。用户可以实现该方法，跳转到自定义的地图界面来显示位置。
 
 @param location 地理位置坐标。
 @param locationName 地理位置名称。
 */
- (void)openLocation:(CLLocationCoordinate2D)location locationName:(NSString*)locationName;
/** 获取地图数据源
 
 @return 返回实现了接口<RCLocationPickerViewControllerDataSource>的对象
 
 在函数<openLocationPicker:>中，会调用该函数来设置<RCLocationPickerViewController>的dataSource。
 
 函数默认返回一个<RCLocationPickerMKMapViewDataSource>对象，开发者可以覆盖这个函数，返回自己的<RCLocationPickerViewControllerDataSource>对象。
 */

- (id<RCLocationPickerViewControllerDataSource>)locationPickerDataSource;
/**
 *  复写此方法自定义打开URL的方式
 *
 *  @param URL URL description
 */
- (void)openURL:(NSURL*)URL;
/**
 *  是否隐藏输入框
 *
 *  @param hiden 是否隐藏
 */
- (void)setChatSessionInputBarViewHidden:(BOOL)hidden;

@end
