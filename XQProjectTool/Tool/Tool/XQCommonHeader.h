//
//  XQCommonHeader.h
//  Pods
//
//  Created by WXQ on 2019/1/12.
//

#ifndef XQCommonHeader_h
#define XQCommonHeader_h


/**
 weak

 @param weakSelf weak名称
 */
#define XQ_WS(weakSelf)  XQ_WSI(weakSelf, self)
/**
 weak

 @param weakName weak名称
 @param instance 对应weak的实例
 */
#define XQ_WSI(weakName, instance)  __weak __typeof(&*instance)weakName = instance



/**
 获取系统的UserDefaults
 */
#define XQ_UD [NSUserDefaults standardUserDefaults]

/**
 系统ud，获取值
 
 @param key 对应保存的key
 @return 返回值
 */
#define XQ_UDGet(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

/**
 系统ud，设置值
 
 @param value 保存的值
 @param key 保存的key
 */
#define XQ_UDSet(value, key) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]


/**
 实现下列几个方法, 对应xq_interface_method
 setMainxxx
 getMainxxx
 addxxx
 removexxx
 setxxxArr
 getxxxArr
 
 @param udKey 保存到本地ud的key
 @param name 小写名称
 @param uName 大写名称
 */
#define xq_imp_method(udKey, name, uName) \
+ (void)setMain##uName:(NSString *)acc {\
NSMutableArray *arr = [self get##uName##Arr].mutableCopy;\
if (![arr containsObject:acc]) {\
[arr insertObject:acc atIndex:0];\
}else {\
if ([arr indexOfObject:acc] == 0) {\
return;\
}\
[arr exchangeObjectAtIndex:[arr indexOfObject:acc] withObjectAtIndex:0];\
}\
[self set##uName##Arr:arr];\
}\
\
+ (NSString *)getMain##uName {\
NSArray *arr = [self get##uName##Arr];\
if (arr.count == 0) {\
return @"";\
}\
return arr.firstObject;\
}\
\
+ (void)add##uName:(NSString *)acc {\
NSMutableArray *arr = [self get##uName##Arr].mutableCopy;\
if (![arr containsObject:acc]) {\
[arr addObject:acc];\
[self set##uName##Arr:arr];\
}\
}\
\
+ (void)remove##uName:(NSString *)acc {\
NSMutableArray *arr = [self get##uName##Arr].mutableCopy;\
if ([arr containsObject:acc]) {\
[arr removeObject:acc];\
[self set##uName##Arr:arr];\
}\
}\
\
+ (void)set##uName##Arr:(NSArray <NSString *> *)accArr {\
XQ_UDSet(accArr, udKey);\
}\
\
+ (NSArray <NSString *> *)get##uName##Arr {\
return XQ_UDGet(udKey) ? XQ_UDGet(udKey) : @[];\
}

/**
 声明下列几个方法, 对应xq_imp_method
 
 @param name 小写name
 @param uName 大写name
 */
#define xq_interface_method(name, uName) \
+ (void)setMain##uName:(NSString *)acc;\
\
+ (NSString *)getMain##uName;\
\
+ (void)add##uName:(NSString *)acc;\
\
+ (void)remove##uName:(NSString *)acc;\
\
+ (void)set##uName##Arr:(NSArray <NSString *> *)accArr;\
\
+ (NSArray <NSString *> *)get##uName##Arr;

#endif /* XQCommonHeader_h */
