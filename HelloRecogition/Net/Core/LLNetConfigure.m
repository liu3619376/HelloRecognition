//
//  LLNetConfigure.m
//  LLNetWorking
//
//  Created by shizhi on 2017/6/7.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "LLNetConfigure.h"

@implementation LLNetConfigure

+ (instancetype)share {
    static dispatch_once_t onceToken;
    static LLNetConfigure *manager = nil;
    dispatch_once(&onceToken, ^{
      manager = [[[self class] alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
#ifdef DEBUG
         _enableDebug = true;
#else
         _enableDebug = false;
#endif
        _generalServer = @"";
       
    }
    return self;
}

+ (void)addGeneralParameter:(NSString *)sKey value:(id)sValue {
    LLNetConfigure *manager = [LLNetConfigure share];
    NSMutableDictionary *mDict = @{}.mutableCopy;
    mDict[sKey] = sValue;
    [mDict addEntriesFromDictionary:manager.generalParameters];
    manager.generalParameters = mDict.copy;
}
+ (void)removeGeneralParameter:(NSString *)sKey {
    LLNetConfigure *manager = [LLNetConfigure share];
    NSMutableDictionary *mDict = manager.generalParameters.mutableCopy;
    [mDict removeObjectForKey:sKey];
    manager.generalParameters = mDict.copy;
}

- (NSDictionary<NSString *,NSString *> *)generalHeaders{
#warning 需要与后端协议
    return @{
           //  @"User-Agent" : @"iPhone",
             //             @"Charset" : @"UTF-8",
             //             @"Accept-Encoding" : @"gzip"
             };
}

@end
