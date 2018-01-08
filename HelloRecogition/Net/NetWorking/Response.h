//
//  Response.h
//  HelloRecogition
//
//  Created by liuyang on 2017/12/5.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"

/// 网络响应数据类
@interface Response : NSObject

@property (nullable, nonatomic, copy, readonly) NSData *rawData;
@property (nonatomic, assign, readonly) ResponseStatus status;
@property (nullable, nonatomic, copy, readonly) id content;
@property (nonatomic, assign, readonly) NSInteger statueCode;
@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonnull, nonatomic, copy, readonly) NSURLRequest *request;

- (nonnull instancetype)initWithRequestId:(nonnull NSNumber *)requestId
                                  request:(nonnull NSURLRequest *)request
                             responseData:(nullable NSData *)responseData
                                   status:(ResponseStatus)status;

- (nonnull instancetype)initWithRequestId:(nonnull NSNumber *)requestId
                                  request:(nonnull NSURLRequest *)request
                             responseData:(nullable NSData *)responseData
                                    error:(nullable NSError *)error;

@end
