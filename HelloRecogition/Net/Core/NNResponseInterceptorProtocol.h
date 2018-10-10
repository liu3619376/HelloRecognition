//
//  NNRequestInterceptorProtocol.h
//  NNNetWorking
//
//  Created by shizhi on 2017/6/7.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NNRequest, NNResponse;
/// 网络响应返回前的拦截协议
@protocol NNResponseInterceptorProtocol <NSObject>

@optional
- (void)validatorResponse:(NNResponse *)rsp;

@end
