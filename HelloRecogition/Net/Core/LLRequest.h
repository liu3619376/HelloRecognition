//
//  LLRequest.h
//  LLNetWorking
//
//  Created by shizhi on 2017/6/7.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLConstant.h"

/**
 网络请求参数数据类
 */
@interface LLRequest : NSObject

/**
 请求 Base URL，优先级高于 [LLNetConfigure generalServer];
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
 请求方式 默认为 LLRequestTypePost
 */
@property (nonatomic, assign) LLRequestType requestMethod;

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
