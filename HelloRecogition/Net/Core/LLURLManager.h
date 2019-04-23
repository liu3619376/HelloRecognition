//
//  LLURLManager.h
//  LLNetWorking
//
//  Created by shizhi on 2017/6/6.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLConstant.h"

NS_ASSUME_NONNULL_BEGIN

@class LLRequest, LLResponse;

/// 网络请求 实现类
@interface LLURLManager : NSObject

+ (nonnull instancetype)manager;

/**
 直接进行请求，不进行参数及 url 的包装
 
 @param request 请求实体类
 @param result 响应结果
 @return 该请求对应的唯一 task id
 */
- (NSString *)sendRequest:(nonnull LLRequest *)request complete:(nonnull LLResponseBlock) result;


/**
 发送网络请求，紧凑型

 @param requestBlock 请求配置 Block
 @param result 请求结果 Block
 @return 该请求对应的唯一 task id
 */
- (NSString *)sendRequestWithConfigBlock:(nonnull LLRequestConfigBlock )requestBlock complete:(nonnull LLResponseBlock) result;

/**
 根据请求 ID 取消该任务
 
 @param requestID 任务请求 ID
 */
- (void)cancelRequestWithRequestID:(nonnull NSString *)requestID;


/**
 根据请求 ID 列表 取消任务
 
 @param requestIDList 任务请求 ID 列表
 */
- (void)cancelRequestWithRequestIDList:(nonnull NSArray<NSString *> *)requestIDList;

@end


@interface LLURLManager (Validate)

/**
 请求前的拦截器
 
 @param cls 实现 LLRequestInterceptorProtocol 协议的 实体类
 可以在该实体类中做请求前的处理
 */
+ (void)registerRequestInterceptor:(nonnull Class)cls;
+ (void)unregisterRequestInterceptor:(nonnull Class)cls;

/**
 返回数据前的拦截器
 
 @param cls 实现 LLResponseInterceptorProtocol 协议的 实体类
 可以在该实体类中做统一的数据验证
 */
+ (void)registerResponseInterceptor:(nonnull Class)cls;
+ (void)unregisterResponseInterceptor:(nonnull Class)cls;

@end



NS_ASSUME_NONNULL_END
