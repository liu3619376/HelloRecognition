//
//  LLChainRequest.m
//  LLNetWorking
//
//  Created by shizhi on 2017/6/13.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "LLChainRequest.h"
#import "LLRequest.h"
#import "LLResponse.h"
@interface LLChainRequest ()
@property (nonatomic, strong, readwrite) LLRequest *runningRequest;

@property (nonatomic, strong) NSMutableArray<LLNextBlock> *nextBlockArray;
@property (nonatomic, strong) NSMutableArray<LLResponse *> *responseArray;

@property (nonatomic, copy) LLGroupResponseBlock completeBlock;

@end

@implementation LLChainRequest : NSObject

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    _responseArray = [NSMutableArray array];
    _nextBlockArray = [NSMutableArray array];

    return self;
}

- (LLChainRequest *)onFirst:(LLRequestConfigBlock)firstBlock {
    NSAssert(firstBlock != nil, @"The first block for chain requests can't be nil.");
    NSAssert(_nextBlockArray.count == 0, @"The `-onFirst:` method must called befault `-oLLext:` method");
    _runningRequest = [LLRequest new];
    firstBlock(_runningRequest);
    return self;
}

- (LLChainRequest *)onFirstReqeust:(LLRequest *)request {
    _runningRequest = request;
    return self;
}

- (LLChainRequest *)onNext:(LLNextBlock)nextBlock {
    NSAssert(nextBlock != nil, @"The next block for chain requests can't be nil.");
    [_nextBlockArray addObject:nextBlock];
    return self;
}

- (LLChainRequest *)onNextReqeust:(LLRequest *)request {
    return self;
}

- (BOOL)onFinishedOneRequest:(LLRequest *)request response:(nullable LLResponse *)responseObject {
    BOOL isFinished = NO;
    [_responseArray addObject:responseObject];
    // 失败
    if (responseObject.status == LLResponseStatusError) {
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
    _runningRequest = [LLRequest new];
    LLNextBlock nextBlock = _nextBlockArray[_responseArray.count - 1];
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
