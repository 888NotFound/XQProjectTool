//
//  XQStartupItem.m
//
//  Created by WXQ on 2019/5/10.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQStartupItem.h"

#import <mach-o/dyld.h>
#import <mach-o/getsect.h>
#import <mach-o/loader.h>
#import <dlfcn.h>

/**
 
 总的来说, 就是利用 section() 函数, 把数据的地址信息注册到一个表里
 执行的时候根据 sectname 取这个节点的地址信息, 然后根据地址, 取出数据, 最后执行
 不过目前缺点来说, 就是要自己去释放 block, 暂时还想不到能自动执行一遍, 就自动释放block的方法
 
 */

#pragma mark - 实现存储block

#ifdef __LP64__
typedef uint64_t xq_uint_t;
typedef struct section_64 xq_section;
#define xq_getSectByNameFromHeader getsectbynamefromheader_64
typedef struct mach_header_64 xq_mach_header;
#else
typedef uint32_t xq_uint_t;
typedef struct section xq_section;
#define xq_getSectByNameFromHeader getsectbynamefromheader
typedef struct mach_header xq_mach_header;
#endif


int xq_execute_SI(const char * _Nullable key) {
    if (!key) {
        // key不存在
        return 1;
    }
    
    // 获取地址的符号信息
    Dl_info info;
    dladdr((const void *)&xq_execute_SI, &info);
    
    // 共享对象的基础地址
    const xq_uint_t m_h = (xq_uint_t)info.dli_fbase;
    // 获取指定mach-o文件中的某个段中某个节中的描述信息
    const xq_section *section = xq_getSectByNameFromHeader((xq_mach_header *)m_h, __XQ_SI_Sectname, key);
    if (section == NULL) {
        // 找不到这个节点
        return 2;
    }
    
    // 获取 struct 大小
    int addrOffset = sizeof(XQ_SI_Model);
    // for (初始地址; 当前地址 < 节点偏移量 + 节点大小; 当前地址 += struct大小)
    for (xq_uint_t addr = section->offset; addr < section->offset + section->size; addr += addrOffset) {
        // 获取 struct
        XQ_SI_Model entry = *(XQ_SI_Model *)(m_h + addr);
        // 执行block
        if (entry.block) {
            entry.block();
        }
        
        // 移除block, 在这移除没有用
//        entry.block = nil;
//        entry.key = nil;
    }
    
    return 0;
}



@implementation XQStartupItem

+ (void)executeWithKey:(NSString *)key {
    if (!key) {
        return;
    }
    xq_execute_SI([key UTF8String]);
}

+ (void)executeA {
    xq_execute_SI(__XQ_SI_Key_A);
}

+ (void)executeB {
    xq_execute_SI(__XQ_SI_Key_B);
}


#pragma mark - 保存数据

//使用 used字段，即使没有任何引用，在Release下也不会被优化
//#define WriteSection(sectName) __attribute((used, section(SEG_DATA ","#sectName" ")))
//#define SectionDataWithKeyValue(key,value) char * k##key WriteSection(CustomSection) = "{ \""#key"\" : \""#value"\"}";
//
//SectionDataWithKeyValue(url, www.baidu.com);
//SectionDataWithKeyValue(name, sinking);

// 类型 变量 __attribute((used, section(SEG_DATA "," "这个是section, 获取时, 是根据这个获取的"))) = 初始化变量
//char * _xq_key __attribute((used, section("__DATA" "," "CustomSection"))) = "{ \"key\" : \"value\"}";

// 读取数据
+ (NSArray <NSDictionary *> *)readConfigFromSectionName:(NSString *)sectionName {
    NSMutableArray *configs = [NSMutableArray array];
    
    if (sectionName.length) {
        NSString *configuration = @"";
        Dl_info info;
        dladdr((__bridge const void *)(configuration), &info);
        xq_mach_header * machHeader = (xq_mach_header *)info.dli_fbase;
        
        
        unsigned long size = 0;
        uintptr_t *memory = (uintptr_t*)getsectiondata(machHeader, SEG_DATA, [sectionName UTF8String], & size);
        
        NSUInteger counter = size/sizeof(void*);
        NSError *converError = nil;
        for(int i = 0; i < counter; i++){
            char *string = (char *)memory[i];
            
            NSString *str = [NSString stringWithUTF8String:string];
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&converError];
            
            if (json && [json isKindOfClass:[NSDictionary class]]) {
                [configs addObject:json];
            }
            
        }
        
    }
    return configs;
}



@end







