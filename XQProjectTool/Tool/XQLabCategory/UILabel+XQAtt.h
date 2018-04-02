//
//  UILabel+XQAtt.h
//  XQLabAtt
//
//  Created by WXQ on 2018/3/27.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (XQAtt)

/**
 字颜色
 */
- (void)xqAtt_setForegroundColor:(UIColor *)color range:(NSRange)range;

/**
 字体
 */
- (void)xqAtt_setFont:(UIFont *)font range:(NSRange)range;

/**
 下划线
 */
- (void)xqAtt_setUnderlineStyle:(NSUnderlineStyle)style range:(NSRange)range;

/**
 下划线颜色
 */
- (void)xqAtt_setUnderlineColor:(UIColor *)color range:(NSRange)range;

/**
 删除线
 */
- (void)xqAtt_setStrikethroughStyle:(NSUnderlineStyle)style range:(NSRange)range;

/**
 删除线颜色
 */
- (void)xqAtt_setStrikethroughColor:(UIColor *)color range:(NSRange)range;

/**
 行间距
 */
- (void)xqAtt_setParagraphStyleWithLineSpace:(CGFloat)space range:(NSRange)range;

/**
 字间距
 */
- (void)xqAtt_setKernWithSpace:(CGFloat)space range:(NSRange)range;

/**
 横竖排版, 测试并没有效果

 @param vertical NO横
 */
- (void)xqAtt_setVertical:(BOOL)vertical range:(NSRange)range;

/**
 添加att
 */
- (void)xq_addAttribute:(NSAttributedStringKey)name value:(id)value range:(NSRange)range;

@end












