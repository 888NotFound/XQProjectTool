//
//  XQUD.h
//  MacApp
//
//  Created by WXQ on 2018/1/17.
//  Copyright © 2018年 ConfidenceCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQUD : NSObject

+ (NSArray *)getIPArr;
+ (void)saveIP:(NSString *)ip;

+ (NSArray *)getPortArr;
+ (void)savePort:(NSString *)port;

@end











