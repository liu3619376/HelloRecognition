//
//  RequestInterceptorProtocol.h
//  HelloRecogition
//
//  Created by liuyang on 2017/12/8.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#ifndef RequestInterceptorProtocol_h
#define RequestInterceptorProtocol_h

@class Request;
/// 网络请求前的拦截协议
@protocol RequestInterceptorProtocol <NSObject>

@optional
- (BOOL)needRequestWithRequest:(Request *)request;
- (NSData *)cacheDataFromRequest:(Request *)request;

@end

#endif /* RequestInterceptorProtocol_h */
