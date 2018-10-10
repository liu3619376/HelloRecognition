//
//  NNNetConfigure.m
//  NNNetWorking
//
//  Created by shizhi on 2017/6/7.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "NNNetConfigure.h"

@implementation NNNetConfigure

+ (instancetype)share {
    static dispatch_once_t onceToken;
    static NNNetConfigure *manager = nil;
    dispatch_once(&onceToken, ^{
      manager = [[[self class] alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _enableDebug = false;
    }
    return self;
}

+ (void)addGeneralParameter:(NSString *)sKey value:(id)sValue {
    NNNetConfigure *manager = [NNNetConfigure share];
    NSMutableDictionary *mDict = @{}.mutableCopy;
    mDict[sKey] = sValue;
    [mDict addEntriesFromDictionary:manager.generalParameters];
    manager.generalParameters = mDict.copy;
}
+ (void)removeGeneralParameter:(NSString *)sKey {
    NNNetConfigure *manager = [NNNetConfigure share];
    NSMutableDictionary *mDict = manager.generalParameters.mutableCopy;
    [mDict removeObjectForKey:sKey];
    manager.generalParameters = mDict.copy;
}

@end
