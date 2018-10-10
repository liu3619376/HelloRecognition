//
//  NNChainRequest.h
//  NNNetWorking
//
//  Created by shizhi on 2017/6/13.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NNConstant.h"

NS_ASSUME_NONNULL_BEGIN

@class NNRequest, NNResponse;
@interface NNChainRequest : NSObject

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, strong, readonly) NNRequest *runningRequest;

- (NNChainRequest *)onFirst:(NNRequestConfigBlock)firstBlock;
- (NNChainRequest *)onFirstReqeust:(NNRequest *)request UNAVAILABLE_ATTRIBUTE;

- (NNChainRequest *)onNext:(NNNextBlock)nextBlock;
- (NNChainRequest *)onNextReqeust:(NNRequest *)request UNAVAILABLE_ATTRIBUTE;

- (BOOL)onFinishedOneRequest:(NNRequest *)request response:(nullable NNResponse *)responseObject;

@end

NS_ASSUME_NONNULL_END
