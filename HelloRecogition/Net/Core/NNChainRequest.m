//
//  NNChainRequest.m
//  NNNetWorking
//
//  Created by shizhi on 2017/6/13.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "NNChainRequest.h"
#import "NNRequest.h"
#import "NNResponse.h"
@interface NNChainRequest ()
@property (nonatomic, strong, readwrite) NNRequest *runningRequest;

@property (nonatomic, strong) NSMutableArray<NNNextBlock> *nextBlockArray;
@property (nonatomic, strong) NSMutableArray<NNResponse *> *responseArray;

@property (nonatomic, copy) NNGroupResponseBlock completeBlock;

@end

@implementation NNChainRequest : NSObject

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    _responseArray = [NSMutableArray array];
    _nextBlockArray = [NSMutableArray array];

    return self;
}

- (NNChainRequest *)onFirst:(NNRequestConfigBlock)firstBlock {
    NSAssert(firstBlock != nil, @"The first block for chain requests can't be nil.");
    NSAssert(_nextBlockArray.count == 0, @"The `-onFirst:` method must called befault `-onNext:` method");
    _runningRequest = [NNRequest new];
    firstBlock(_runningRequest);
    return self;
}

- (NNChainRequest *)onFirstReqeust:(NNRequest *)request {
    _runningRequest = request;
    return self;
}

- (NNChainRequest *)onNext:(NNNextBlock)nextBlock {
    NSAssert(nextBlock != nil, @"The next block for chain requests can't be nil.");
    [_nextBlockArray addObject:nextBlock];
    return self;
}

- (NNChainRequest *)onNextReqeust:(NNRequest *)request {
    return self;
}

- (BOOL)onFinishedOneRequest:(NNRequest *)request response:(nullable NNResponse *)responseObject {
    BOOL isFinished = NO;
    [_responseArray addObject:responseObject];
    // 失败
    if (responseObject.status == NNResponseStatusError) {
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
    _runningRequest = [NNRequest new];
    NNNextBlock nextBlock = _nextBlockArray[_responseArray.count - 1];
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
