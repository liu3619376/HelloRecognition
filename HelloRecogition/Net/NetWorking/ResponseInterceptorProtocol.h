//
//  NNResponseInterceptorProtocol.h
//  HelloRecogition
//
//  Created by liuyang on 2017/12/8.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#ifndef NNResponseInterceptorProtocol_h
#define NNResponseInterceptorProtocol_h

@class Request, Response;
/// 网络响应返回前的拦截协议
@protocol ResponseInterceptorProtocol <NSObject>

@optional
- (void)validatorResponse:(Response *)rsp;

@end
#endif /* NNResponseInterceptorProtocol_h */
