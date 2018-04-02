//
//  UILabel+XQAtt.m
//  XQLabAtt
//
//  Created by WXQ on 2018/3/27.
//  Copyright © 2018年 SyKing. All rights reserved.
//

#import "UILabel+XQAtt.h"

@implementation UILabel (XQAtt)

// 字颜色
- (void)xqAtt_setForegroundColor:(UIColor *)color range:(NSRange)range {
    [self xq_addAttribute:NSForegroundColorAttributeName value:color range:range];
}

    // 字体
- (void)xqAtt_setFont:(UIFont *)font range:(NSRange)range {
    [self xq_addAttribute:NSFontAttributeName value:font range:range];
}

// 下划线
- (void)xqAtt_setUnderlineStyle:(NSUnderlineStyle)style range:(NSRange)range {
    [self xq_addAttribute:NSUnderlineStyleAttributeName value:@(style) range:range];
}

    // 下划线颜色
- (void)xqAtt_setUnderlineColor:(UIColor *)color range:(NSRange)range {
    [self xq_addAttribute:NSUnderlineColorAttributeName value:color range:range];
}

    // 删除线
- (void)xqAtt_setStrikethroughStyle:(NSUnderlineStyle)style range:(NSRange)range {
    [self xq_addAttribute:NSStrikethroughStyleAttributeName value:@(style) range:range];
}

    // 删除线颜色
- (void)xqAtt_setStrikethroughColor:(UIColor *)color range:(NSRange)range {
    [self xq_addAttribute:NSStrikethroughColorAttributeName value:color range:range];
}

    // 行间距
- (void)xqAtt_setParagraphStyleWithLineSpace:(CGFloat)space range:(NSRange)range {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [self xq_addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
}

    // 字间距
- (void)xqAtt_setKernWithSpace:(CGFloat)space range:(NSRange)range {
    [self xq_addAttribute:NSKernAttributeName value:@(space) range:range];
}

    // 横竖排
- (void)xqAtt_setVertical:(BOOL)vertical range:(NSRange)range {
    [self xq_addAttribute:NSVerticalGlyphFormAttributeName value:@(vertical) range:range];
}

// 添加att
- (void)xq_addAttribute:(NSAttributedStringKey)name value:(id)value range:(NSRange)range {
    if (!value || self.text.length == 0 || range.length == 0) {
        NSLog(@"参数错误");
        return;
    }
    
    NSMutableAttributedString *muAtt = [self getMuAtt];
    if (!muAtt) {
        NSLog(@"不存在 att");
        return;
    }
    [muAtt addAttribute:name value:value range:range];
    self.attributedText = muAtt;
}

// 获取当前的att
- (NSMutableAttributedString *)getMuAtt {
    NSMutableAttributedString *muAtt = nil;
    if (self.attributedText) {
        muAtt = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }else {
        NSError *error = nil;
        muAtt = [[NSMutableAttributedString alloc] initWithData:[self.text dataUsingEncoding:NSUTF8StringEncoding] options:@{} documentAttributes:nil error:&error];
        if (error) {
            NSLog(@"error: %@", error);
        }
    }
    return muAtt;
}

- (void)xqtest {
//    NSParagraphStyleAttributeName 段落格式
//
//    NSBackgroundColorAttributeName 背景颜色
//
//    NSStrokeWidthAttributeName 删除线宽度
//
//    NSShadowAttributeName 阴影
    
}

@end











