//
//  NNRequest.m
//  NNNetWorking
//
//  Created by shizhi on 2017/6/7.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "NNRequest.h"
#import "NNNetConfigure.h"

@implementation NNRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        _requestMethod = NNRequestTypePost;
        _reqeustTimeoutInterval = 30.0;
        _encryptParams = @{};
        _normalParams = @{};
        _requestHeader = @{};
        _retryCount = 0;
        _apiVersion = @"1.0";
        
    }
    return self;
}

- (void)dealloc {
    if ([NNNetConfigure share].enableDebug) {
        NSLog(@"dealloc: %@", ([self class]));
    }
}

@end
