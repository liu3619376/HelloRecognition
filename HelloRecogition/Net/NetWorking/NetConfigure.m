//
//  NetConfigure.m
//  HelloRecogition
//
//  Created by liuyang on 2017/12/5.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import "NetConfigure.h"

@implementation NetConfigure

//单例模式
+ (instancetype)share {
    static dispatch_once_t onceToken;
    static NetConfigure *manager = nil;
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
    NetConfigure *manager = [NetConfigure share];
    NSMutableDictionary *mDict = @{}.mutableCopy;
    mDict[sKey] = sValue;
    [mDict addEntriesFromDictionary:manager.generalParameters];
    manager.generalParameters = mDict.copy;
}
+ (void)removeGeneralParameter:(NSString *)sKey {
    NetConfigure *manager = [NetConfigure share];
    NSMutableDictionary *mDict = manager.generalParameters.mutableCopy;
    [mDict removeObjectForKey:sKey];
    manager.generalParameters = mDict.copy;
}


@end
