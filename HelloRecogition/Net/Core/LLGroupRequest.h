//
//  LLGroupRequest.h
//  LLNetWorking
//
//  Created by shizhi on 2017/6/12.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LLRequest, LLResponse;
@interface LLGroupRequest : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<LLRequest *> *requestArray;
@property (nonatomic, strong, readonly) NSMutableArray<LLResponse *> *responseArray;

- (void)addRequest:(LLRequest *)request;

- (BOOL)onFinishedOneRequest:(LLRequest *)request response:(nullable LLResponse *)responseObject;

@end

