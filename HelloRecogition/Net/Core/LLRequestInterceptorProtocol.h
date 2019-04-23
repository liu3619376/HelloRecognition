
//
//  LLRequestInterceptorProtocol.h
//  LLNetWorking
//
//  Created by shizhi on 2017/6/7.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LLRequest;
/// 网络请求前的拦截协议
@protocol LLRequestInterceptorProtocol <NSObject>

@optional
- (BOOL)needRequestWithRequest:(LLRequest *)request;
- (NSData *)cacheDataFromRequest:(LLRequest *)request;
@end
