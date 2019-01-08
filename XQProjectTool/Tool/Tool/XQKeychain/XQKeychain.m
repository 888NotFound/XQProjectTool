//
//  XQKeychain.m
//  XQKeychain
//
//  Created by SyKingW on 2018/1/6.
//  Copyright © 2018年 SyKingW. All rights reserved.
//

#import "XQKeychain.h"
//#import <SAMKeychain.h>
#import <Security/Security.h>

/**
 多个应用共享 keychain
 Capabilities 里面找到keychain groups， 然后每个应用填同一个就好
 如果要多个groups...目前没试过， 反正一个的话， 勾选就直接用， 代码也不用做任何改变， 估计如果要多个， 就得代码选择那个group了
 */

@implementation XQKeychain

#pragma mark - Key

+ (void)initUDID {
    NSString *str = [self getUUIDStr];
    if (!str || [str isEqualToString:@""]) {
        NSString *uuidStr = [[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [self saveUUIDStr:uuidStr];
    }
}

+ (int)saveUUIDStr:(NSString *)UUIDStr {
    if (!UUIDStr) {
        NSLog(@"data not exist");
        return -1;
    }
    
    NSMutableDictionary *keychainQuery = [self getUDIDKeychainQuery];
    return [self saveData:UUIDStr dic:keychainQuery];
}

+ (NSString *)getUUIDStr {
    NSMutableDictionary *keychainQuery = [self getUDIDKeychainQuery];
    // 设置获取数据类型
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    // 获取的数量， one or all
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    
    NSData *data = [self getDataWithDic:keychainQuery];
    NSString *str = nil;
    if (data) {
        str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return str;
}

+ (int)deleteUUIDStr {
    NSMutableDictionary *keychainQuery = [self getUDIDKeychainQuery];
    CFDictionaryRef dRef = (__bridge_retained CFDictionaryRef)keychainQuery;
    int result = SecItemDelete(dRef);
    CFRelease(dRef);
    return result;
}

// 获取查询udid(设备唯一标识符, 这里是结合kechain and uuid, 不过设备重置, 就是刷机等等一些极端操作, 就会删除keychain, 所以这里的udid相对来说是唯一的)
+ (NSMutableDictionary *)getUDIDKeychainQuery {
    NSDictionary *dic = [self getKeychainKeyQueryWithLab:@"xq_lm_udid" tag:@"101"];
    return [dic mutableCopy];
}

+ (NSMutableDictionary *)getKeychainKeyQueryWithLab:(NSString *)lab tag:(NSString *)tag {
    NSDictionary *dic = @{
                          (__bridge_transfer id)kSecClass : (__bridge_transfer id)kSecClassKey,// 类型
                          (__bridge_transfer id)kSecAttrApplicationLabel : [lab dataUsingEncoding:NSUTF8StringEncoding], // 描述
                          (__bridge_transfer id)kSecAttrApplicationTag : [tag dataUsingEncoding:NSUTF8StringEncoding], // 标记
                          };
    return [dic mutableCopy];
}

#pragma mark - 密码

static NSString *pwdServer_ = @"xq_pwdServer";
+ (int)savePwdWithAcc:(NSString *)acc pwd:(NSString *)pwd {
    if (!acc || !pwd) {
        NSLog(@"data not exist");
        return -1;
    }
    
    NSMutableDictionary *keychainQuery = [self getKeychainPWDQueryWithSev:pwdServer_ acc:acc];
    return [self saveData:pwd dic:keychainQuery];
}

+ (NSString *)getPwdWithAcc:(NSString *)acc {
    NSMutableDictionary *keychainQuery = [self getKeychainPWDQueryWithSev:pwdServer_ acc:acc];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    
    NSData *data = [self getDataWithDic:keychainQuery];
    NSString *ret = nil;
    if (data) {
        ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return ret;
}

+ (NSArray *)getAllAcc {
    NSMutableDictionary *keychainQuery = [self getKeychainPWDQueryWithSev:pwdServer_];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnAttributes];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitAll forKey:(__bridge_transfer id)kSecMatchLimit];
    
    NSMutableArray *muArr = [NSMutableArray array];
    NSArray *arr = [self getDataWithDic:keychainQuery];
    for (NSDictionary *dataDic in arr) {
        NSString *acc = dataDic[(__bridge NSString *)kSecAttrAccount];
        [muArr addObject: acc ? acc : @""];
    }
    return muArr.copy;
}

+ (NSArray *)getAllAccInfo {
    NSArray *arr = [self getAllAcc];
    
    NSMutableArray *muArr = [NSMutableArray array];
    for (NSString *acc in arr) {
        NSString *pwd = [self getPwdWithAcc:acc];
        NSDictionary *dic = @{
                              @"xq_pwd": pwd ? pwd : @"",
                              @"xq_acc": acc,
                              };
        [muArr addObject:dic];
    }
    
    return muArr.copy;
}


+ (NSArray *)getAllPwd {
    NSMutableDictionary *keychainQuery = [self getKeychainPWDQueryWithSev:pwdServer_];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitAll forKey:(__bridge_transfer id)kSecMatchLimit];
    
    NSMutableArray *muArr = [NSMutableArray array];
    NSArray *arr = [self getDataWithDic:keychainQuery];
    for (int i = 0; i < arr.count; i++) {
        NSString *pwd = [[NSString alloc] initWithData:arr[i] encoding:NSUTF8StringEncoding];
        [muArr addObject: pwd ? pwd : @""];
    }
    
    return muArr;
}

+ (int)deleteAcc:(NSString *)acc {
    NSMutableDictionary *keychainQuery = [self getKeychainPWDQueryWithSev:pwdServer_ acc:acc];
    CFDictionaryRef ref = (__bridge_retained CFDictionaryRef)keychainQuery;
    int result = SecItemDelete(ref);
    CFRelease(ref);
    return result;
}

+ (int)deleteAllAcc {
    NSMutableDictionary *keychainQuery = [self getKeychainPWDQueryWithSev:pwdServer_];
    CFDictionaryRef ref = (__bridge_retained CFDictionaryRef)keychainQuery;
    int result = SecItemDelete(ref);
    CFRelease(ref);
    return result;
}

// 可以用这个来保存用户的密码这些
+ (NSMutableDictionary *)getKeychainPWDQueryWithSev:(NSString *)sev acc:(NSString *)acc {
    NSDictionary *dic = @{
                          (__bridge_transfer id)kSecClass : (__bridge_transfer id)kSecClassGenericPassword,// 类型
                          (__bridge_transfer id)kSecAttrService : sev, // 服务
                          (__bridge_transfer id)kSecAttrAccount : acc, // 账号
                          };
    return [dic mutableCopy];
}

+ (NSMutableDictionary *)getKeychainPWDQueryWithSev:(NSString *)sev {
    NSDictionary *dic = @{
                          (__bridge_transfer id)kSecClass : (__bridge_transfer id)kSecClassGenericPassword,// 类型
                          (__bridge_transfer id)kSecAttrService : sev, // 服务
                          };
    return [dic mutableCopy];
}

#pragma mark - 公共处理数据方法

+ (int)saveData:(NSString *)data dic:(NSMutableDictionary *)dic {
    CFDictionaryRef aRef = (__bridge_retained CFDictionaryRef)dic;
    SecItemDelete(aRef);
    [dic setObject:[data dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge_transfer id)kSecValueData];
    int result = SecItemAdd(aRef, NULL);
    CFRelease(aRef);
    return result;
}

+ (id)getDataWithDic:(NSDictionary *)dic {
    CFTypeRef keyData = NULL;
    id ret = nil;
    CFDictionaryRef dRef = (__bridge_retained CFDictionaryRef)dic;
    
    if (SecItemCopyMatching(dRef, &keyData) == errSecSuccess) {
        ret = (__bridge id)(keyData);
    }
    
    // 释放data
    if (keyData) {
        CFRelease(keyData);
    }
    CFRelease(dRef);
    return ret;
}

@end














