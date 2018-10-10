//
//  NNGroupRequest.h
//  NNNetWorking
//
//  Created by shizhi on 2017/6/12.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class NNRequest, NNResponse;
@interface NNGroupRequest : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<NNRequest *> *requestArray;
@property (nonatomic, strong, readonly) NSMutableArray<NNResponse *> *responseArray;

- (void)addRequest:(NNRequest *)request;

- (BOOL)onFinishedOneRequest:(NNRequest *)request response:(nullable NNResponse *)responseObject;

@end
NS_ASSUME_NONNULL_END
