//
//  ChainRequset.h
//  HelloRecogition
//
//  Created by liuyang on 2017/12/5.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"

NS_ASSUME_NONNULL_BEGIN
//链式请求
@interface ChainRequest : NSObject


@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, strong, readonly) Request *runningRequest;

- (ChainRequest *)onFirst:(RequestConfigBlock)firstBlock;
- (ChainRequest *)onFirstReqeust:(Request *)request UNAVAILABLE_ATTRIBUTE;

- (ChainRequest *)onNext:(NextBlock)nextBlock;
- (ChainRequest *)onNextReqeust:(Request *)request UNAVAILABLE_ATTRIBUTE;

- (BOOL)onFinishedOneRequest:(Request *)request response:(nullable Response *)responseObject;

@end

NS_ASSUME_NONNULL_END
