//
//  GroupRequest.h
//  HelloRecogition
//
//  Created by liuyang on 2017/12/6.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Request, Response;

@interface GroupRequest : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<Request *> *requestArray;
@property (nonatomic, strong, readonly) NSMutableArray<Response *> *responseArray;

- (void)addRequest:(Request *)request;
- (BOOL)onFinishedOneRequest:(Request *)request response:(nullable Response *)responseObject;
@end

NS_ASSUME_NONNULL_END
