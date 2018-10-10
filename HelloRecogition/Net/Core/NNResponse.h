//
//  NNResponse.h
//  NNNetWorking
//
//  Created by shizhi on 2017/6/6.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NNConstant.h"

/// 网络响应数据类
@interface NNResponse : NSObject

@property (nullable, nonatomic, copy, readonly) NSData *rawData;
@property (nonatomic, assign, readonly) NNResponseStatus status;
@property (nullable, nonatomic, copy, readonly) id content;
@property (nonatomic, assign, readonly) NSInteger statueCode;
@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonnull, nonatomic, copy, readonly) NSURLRequest *request;

- (nonnull instancetype)initWithRequestId:(nonnull NSNumber *)requestId
                          request:(nonnull NSURLRequest *)request
                     responseData:(nullable NSData *)responseData
                           status:(NNResponseStatus)status;

- (nonnull instancetype)initWithRequestId:(nonnull NSNumber *)requestId
                          request:(nonnull NSURLRequest *)request
                     responseData:(nullable NSData *)responseData
                            error:(nullable NSError *)error;

@end
