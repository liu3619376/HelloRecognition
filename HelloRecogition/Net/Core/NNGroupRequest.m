//
//  NNGroupRequest.m
//  NNNetWorking
//
//  Created by shizhi on 2017/6/12.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "NNGroupRequest.h"
#import "NNConstant.h"
#import "NNResponse.h"

@interface NNGroupRequest ()

@property (nonatomic, strong) dispatch_semaphore_t lock;
@property (nonatomic, assign) NSUInteger finishedCount;
@property (nonatomic, assign, getter=isFailed) BOOL failed;

@property (nonatomic, copy) NNGroupResponseBlock completeBlock;
@end

@implementation NNGroupRequest

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

- (void)addRequest:(NNRequest *)request {
    [_requestArray addObject:request];
}

- (BOOL)onFinishedOneRequest:(NNRequest *)request response:(nullable NNResponse *)responseObject {
    BOOL isFinished = NO;
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    if (responseObject) {
        [_responseArray addObject:responseObject];
    }
    _failed |= (responseObject.status == NNResponseStatusError);

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
