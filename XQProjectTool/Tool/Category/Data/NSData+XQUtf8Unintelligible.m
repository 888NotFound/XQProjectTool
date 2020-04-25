//
//  NSData+XQUtf8Unintelligible.m
//  XQFBaseUIOC
//
//  Created by WXQ on 2020/4/18.
//  Copyright © 2020 SyKing. All rights reserved.
//

#import "NSData+XQUtf8Unintelligible.h"

@implementation NSData (XQUtf8Unintelligible)

/// 替换非utf8字符
/// 注意：如果是三字节utf-8，第二字节错误，则先替换第一字节内容(认为此字节误码为三字节utf8的头)，然后判断剩下的两个字节是否非法；
+ (NSData *)xq_replaceNoUtf8:(NSData *)data
{
    char aa[] = {'A','A','A','A','A','A'}; //utf8最多6个字符，当前方法未使用
    NSMutableData *md = [NSMutableData dataWithData:data];
    int loc = 0;
    while (loc < [md length])
    {
        char buffer;
        [md getBytes:&buffer range:NSMakeRange(loc, 1)];
        if ((buffer & 0x80) == 0) //0xxx xxxx 1个Byte
        {
            loc++;
            continue;
        }
        else if ((buffer & 0xE0) == 0xC0) //110x xxxx 2个Byte
        {
            loc++; //此处可能越界，要判断
            if (loc >= md.length) { //此时的buffer已经是最后一个Byte
                loc--;
                //非法字符，将这个字符（一个byte）替换为A
                [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
                break;
            }
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if ((buffer & 0xC0) == 0x80) //10xx xxxx 第2个Byte
            {
                loc++;
                continue;
            }
            loc--;
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else if ((buffer & 0xF0) == 0xE0) //1110 xxxx 3个Byte
        {
            loc++; //此处可能越界，要判断
            if (loc >= md.length) { //此时的buffer已经是最后一个Byte
                loc--;
                //非法字符，将这个字符（一个byte）替换为A
                [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
                break;
            }
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if ((buffer & 0xC0) == 0x80) //10xx xxxx 第2个Byte
            {
                loc++; //此处可能越界，要判断
                if (loc >= md.length) { //此时的buffer已经是最后一个Byte
                    loc--;
                    //非法字符，将这个字符（一个byte）替换为A
                    [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
                    break;
                }
                [md getBytes:&buffer range:NSMakeRange(loc, 1)];
                if ((buffer & 0xC0) == 0x80) //10xx xxxx 第3个Byte
                {
                    loc++;
                    continue;
                }
                loc--;
            }
            loc--;
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else
        {
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
    }
    
    return md;
}

@end
