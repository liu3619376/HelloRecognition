//
//  Request.h
//  HelloRecogition
//
//  Created by liuyang on 2017/12/5.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"

/**
 网络请求参数数据类
 */
@interface Request : NSObject

/**
 请求 Base URL，优先级高于 [NetConfigure generalServer];
 */
@property (nonatomic, copy) NSString *reqeustURLString;

/**
 请求路径 eg: /login2
 */
@property (nonatomic, copy) NSString *requestPath;

/**
 请求头，默认为空 @{}
 */
@property (nonatomic, strong) NSDictionary *requestHeader;

/**
 请求参数，加密参数 默认为空 @{}
 */
@property (nonatomic, strong) NSDictionary *encryptParams;

/**
 请求参数，不用加密 默认为 @{}
 */
@property (nonatomic, strong) NSDictionary *normalParams;

/**
 请求方式 默认为 RequestTypePost
 */
@property (nonatomic, assign) RequestType requestMethod;

/**
 请求超时时间 默认 30s
 */
@property (nonatomic, assign) NSTimeInterval reqeustTimeoutInterval;

/**
 api 版本号，默认 1.0
 */
@property (nonatomic, copy) NSString *apiVersion;

/**
 重试次数，默认为 0
 */
@property (nonatomic, assign) UInt8 retryCount NS_UNAVAILABLE;

@end

@interface Request (Generate)
- (NSURLRequest *)generateRequest;
@end

