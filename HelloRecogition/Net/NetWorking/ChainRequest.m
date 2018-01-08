//
//  ChainRequset.m
//  HelloRecogition
//
//  Created by liuyang on 2017/12/5.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import "ChainRequest.h"
#import "Response.h"
#import "Request.h"

@interface ChainRequest()

@property (nonatomic, strong, readwrite) Request *runningRequest;

@property (nonatomic, strong) NSMutableArray<NextBlock> *nextBlockArray;
@property (nonatomic, strong) NSMutableArray<Response *> *responseArray;

@property (nonatomic, copy) GroupResponseBlock completeBlock;

@end

@implementation ChainRequest


- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _responseArray = [NSMutableArray array];
    _nextBlockArray = [NSMutableArray array];
    
    return self;
}

- (ChainRequest *)onFirst:(RequestConfigBlock)firstBlock {
    NSAssert(firstBlock != nil, @"The first block for chain requests can't be nil.");
    NSAssert(_nextBlockArray.count == 0, @"The `-onFirst:` method must called befault `-onNext:` method");
    _runningRequest = [Request new];
    firstBlock(_runningRequest);
    return self;
}

- (ChainRequest *)onFirstReqeust:(Request *)request {
    _runningRequest = request;
    return self;
}

- (ChainRequest *)onNext:(NextBlock)nextBlock {
    NSAssert(nextBlock != nil, @"The next block for chain requests can't be nil.");
    [_nextBlockArray addObject:nextBlock];
    return self;
}

- (ChainRequest *)onNextReqeust:(Request *)request {
    return self;
}

- (BOOL)onFinishedOneRequest:(Request *)request response:(nullable Response *)responseObject {
    BOOL isFinished = NO;
    [_responseArray addObject:responseObject];
    // 失败
    if (responseObject.status == ResponseStatusError) {
        _completeBlock(_responseArray.copy, NO);
        [self cleanCallbackBlocks];
        isFinished = YES;
        return isFinished;
    }
    // 正常完成
    if (_responseArray.count > _nextBlockArray.count) {
        _completeBlock(_responseArray.copy, YES);
        [self cleanCallbackBlocks];
        isFinished = YES;
        return isFinished;
    }
    /// 继续运行
    _runningRequest = [Request new];
    NextBlock nextBlock = _nextBlockArray[_responseArray.count - 1];
    BOOL isSent = YES;
    nextBlock(_runningRequest, responseObject, &isSent);
    if (!isSent) {
        _completeBlock(_responseArray.copy, YES);
        [self cleanCallbackBlocks];
        isFinished = YES;
    }
    return isFinished;
}

- (void)cleanCallbackBlocks {
    _runningRequest = nil;
    _completeBlock = nil;
    [_nextBlockArray removeAllObjects];
}


@end
