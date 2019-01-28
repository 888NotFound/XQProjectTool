//
//  NSBundle+Localizable.m
//  XQLocalizedString
//
//  Created by ladystyle100 on 2017/9/6.
//  Copyright © 2017年 WangXQ. All rights reserved.
//

#import "NSBundle+Localizable.h"
#import "NSObject+XQExchangeIMP.h"

/** 原理
 *  其实就是创建本地化的时候, 在Bundle的路径下, 就会有各种语言的lproj文件(zh-Hans.lproj这个是简体中文)
 *  在App内改变语言, 就是关联本地的lproj文件
 *  然后在调用localizedStringForKey:value:table的时候, 获取管理的lproj, 然后去调用获取字符串
 *
 *  这里有个疑问, 就是lproj不是NSBundle对象, 为什么可以调用这个方法
 *  想了半天, 个人认为, 应该是NSBundle内部的写法就是最后用lproj来调用这个方法的, 而且名字参数等等, 都是一样的
 *  大概就那么多了把
 *
 *  不不不, 还有一个, 就是通过这个关联, 可以做出btn延展的block点击了, 应该不是说btn, 可以说是所有东西, 都可以直接这样写block
 */

// 网上是拿这个来做关联的key, 一般key最好为静态, 但也可以像平常写setget那样, 直接拿字符串做
static NSString *_xq_local_bundle = @"987";

@interface BundleEx : NSBundle

@end

@implementation BundleEx

/** 从本地获取值都走这个 */
- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName {
    /** 获取关联对象 ([NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]])
     *  这个关联对象就是上面这个路径下的NSBundle, 这样的话, 就相当于, 实时获取最新的NSBundle
     */
    NSBundle *bundle = [BundleEx xq_getAssociatedObject:self key:_xq_local_bundle];
//    NSBundle *bundle = objc_getAssociatedObject(self, &_bundle);
    
    // 获取值, 当关联对象不存在时, 用父类调用
    NSString *str = bundle ? [bundle localizedStringForKey:key value:value table:tableName] : [super localizedStringForKey:key value:value table:tableName];
    return str;
}

@end

@implementation NSBundle (Localizable)

- (void)xq_setLanguage:(NSString *)language {
    [[self class] xq_setLanguage:language bundle:self];
}

+ (void)xq_setMainBundleLanguage:(NSString *)language {
    [self xq_setLanguage:language bundle:[NSBundle mainBundle]];
}

+ (void)xq_setLanguage:(NSString *)language bundle:(NSBundle *)bundle {
    if (![bundle isKindOfClass:[BundleEx class]]) {
        object_setClass(bundle, [BundleEx class]);
    }
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        // 设置系统单例为BundleEx类
//        object_setClass([NSBundle mainBundle], [BundleEx class]);
//    });
    
    
    if (!language || language.length == 0) {
        //        NSLog(@"language is nil");
        return;
    }
    
    // 这个就是拿来做扩展的 set get 方法
    /** 设置关联(这个能App内就修改语言, 但是下一次启动就会失效了, 所以还要设置UD)
     *  作用: 关联是指把两个对象相互关联起来，使得其中的一个对象作为另外一个对象的一部分, 使用关联，我们可以不用修改类的定义而为其对象增加存储空间。这在我们无法访问到类的源码的时候或者是考虑到二进制兼容性的时候是非常有用。
     *
     *  以下是参数作用
     *  源对象
     *  关联key
     *  关联对象
     *  关联方案
     */
    [self xq_setAssociatedObject:bundle key:_xq_local_bundle value:[NSBundle bundleWithPath:[bundle pathForResource:language ofType:@"lproj"]] policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    
    //    objc_setAssociatedObject([NSBundle mainBundle], &_bundle, [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    // 断开所有关联 (如果想单单断开一个关联, 只需要把上面的关联对象变填nil就行)
    //objc_removeAssociatedObjects(<#id object#>)
    
    // 单纯设置这个, 只能重启App才能有效, 而且这句代码上上面这句代码顺序不能交换, 不然就设置失败
    // 注意: 如果你不是正常结束进程, 而是调试的时候, 直接 command + r 结束进程的话, 这样语音的更改是失败的
    [[NSUserDefaults standardUserDefaults] setObject:@[language] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:XQ_ChangeLanguage object:language];
}

@end















