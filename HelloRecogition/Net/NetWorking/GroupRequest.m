//
//  GroupRequest.m
//  HelloRecogition
//
//  Created by liuyang on 2017/12/6.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import "GroupRequest.h"
#import "Constant.h"
#import "Response.h"

@interface GroupRequest()

@property (nonatomic, strong) dispatch_semaphore_t lock;
@property (nonatomic, assign) NSUInteger finishedCount;
@property (nonatomic, assign, getter=isFailed) BOOL failed;
@property (nonatomic, copy) GroupResponseBlock completeBlock;

@end

@implementation GroupRequest

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

- (void)addRequest:(Request *)request {
    [_requestArray addObject:request];
}

- (BOOL)onFinishedOneRequest:(Request *)request response:(nullable Response *)responseObject {
    BOOL isFinished = NO;
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    if (responseObject) {
        [_responseArray addObject:responseObject];
    }
    _failed |= (responseObject.status == ResponseStatusError);
    
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
