
//
//  NNRequestInterceptorProtocol.h
//  NNNetWorking
//
//  Created by shizhi on 2017/6/7.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NNRequest;
/// 网络请求前的拦截协议
@protocol NNRequestInterceptorProtocol <NSObject>

@optional
- (BOOL)needRequestWithRequest:(NNRequest *)request;
- (NSData *)cacheDataFromRequest:(NNRequest *)request;
@end
