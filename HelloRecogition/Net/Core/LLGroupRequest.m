//
//  LLGroupRequest.m
//  LLNetWorking
//
//  Created by shizhi on 2017/6/12.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "LLGroupRequest.h"
#import "LLConstant.h"
#import "LLResponse.h"

@interface LLGroupRequest ()

@property (nonatomic, strong) dispatch_semaphore_t lock;
@property (nonatomic, assign) NSUInteger finishedCount;
@property (nonatomic, assign, getter=isFailed) BOOL failed;

@property (nonatomic, copy) LLGroupResponseBlock completeBlock;
@end

@implementation LLGroupRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        _requestArray = [NSMutableArray new];
        _responseArray = [NSMutableArray new];

        _failed = NO;
        _finishedCount = 0;
        _lock = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)addRequest:(LLRequest *)request {
    [_requestArray addObject:request];
}

- (BOOL)onFinishedOneRequest:(LLRequest *)request response:(nullable LLResponse *)responseObject {
    BOOL isFinished = NO;
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    if (responseObject) {
        [_responseArray addObject:responseObject];
    }
    _failed |= (responseObject.status == LLResponseStatusError);

    _finishedCount++;
    if (_finishedCount == _requestArray.count) {
        if (_completeBlock) {
            _completeBlock(_responseArray.copy, !_failed);
        }
        [self cleanCallbackBlocks];
        isFinished = YES;
    }
    dispatch_semaphore_signal(_lock);
    return isFinished;
}

- (void)cleanCallbackBlocks {
    _completeBlock = nil;
}

@end
