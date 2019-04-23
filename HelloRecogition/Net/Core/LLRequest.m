//
//  LLRequest.m
//  LLNetWorking
//
//  Created by shizhi on 2017/6/7.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "LLRequest.h"
#import "LLNetConfigure.h"

@implementation LLRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        _requestMethod = LLRequestTypePost;
        _reqeustTimeoutInterval = 30.0;
        _normalParams = @{};
        _requestHeader = @{};
        _retryCount = 0;
        _apiVersion = @"1.0";
        
    }
    return self;
}

- (void)dealloc {
    if ([LLNetConfigure share].enableDebug) {
        NSLog(@"dealloc: %@", ([self class]));
    }
}

@end
