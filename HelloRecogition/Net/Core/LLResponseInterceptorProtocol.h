//
//  LLRequestInterceptorProtocol.h
//  LLNetWorking
//
//  Created by shizhi on 2017/6/7.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LLRequest, LLResponse;
/// 网络响应返回前的拦截协议
@protocol LLResponseInterceptorProtocol <NSObject>

@optional
- (void)validatorResponse:(LLResponse *)rsp;

@end
