//
//  LLChainRequest.h
//  LLNetWorking
//
//  Created by shizhi on 2017/6/13.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLConstant.h"

@class LLRequest, LLResponse;
@interface LLChainRequest : NSObject

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, strong, readonly) LLRequest *runningRequest;

- (LLChainRequest *)onFirst:(LLRequestConfigBlock)firstBlock;
- (LLChainRequest *)onFirstReqeust:(LLRequest *)request UNAVAILABLE_ATTRIBUTE;

- (LLChainRequest *)onNext:(LLNextBlock)nextBlock;
- (LLChainRequest *)onNextReqeust:(LLRequest *)request UNAVAILABLE_ATTRIBUTE;

- (BOOL)onFinishedOneRequest:(LLRequest *)request response:(nullable LLResponse *)responseObject;

@end


