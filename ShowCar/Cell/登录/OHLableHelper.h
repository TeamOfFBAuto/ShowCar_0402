//
//  OHLableHelper.h
//  FBCircle
//
//  Created by soulnear on 14-9-12.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegexKitLite.h"
#import "MarkupParser.h"
#import "NSAttributedString+Attributes.h"
#import "MarkupParser.h"
#import "OHAttributedLabel.h"
#import "SCGIFImageView.h"


@interface OHLableHelper : NSObject
+ (NSMutableArray *)addHttpArr:(NSString *)text;
+ (NSMutableArray *)addPhoneNumArr:(NSString *)text;
+ (NSMutableArray *)addEmailArr:(NSString *)text;
+ (NSString *)transformString:(NSString *)originalStr;//表情转换为html
+ (void)drawImage:(OHAttributedLabel *)label;
+ (void)creatAttributedText:(NSString *)o_text Label:(OHAttributedLabel *)label OHDelegate:(id<OHAttributedLabelDelegate>)delegate WithWidht:(float)image_widht WithHeight:(float)image_height WithLineBreak:(BOOL)isBreak;
///计算ohlabel高度
+ (float)returnHeightAttributedText:(NSString *)o_text Label:(OHAttributedLabel *)label WithWidht:(float)image_widht WithHeight:(float)image_height;
@end
