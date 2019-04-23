//
//  LLConstant.h
//  LLNetWorking
//
//  Created by shizhi on 2017/6/6.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#ifndef LLConstant_h
#define LLConstant_h

@class LLRequest, LLResponse, LLGroupRequest, LLChainRequest;

typedef NS_ENUM (NSUInteger, LLRequestType){
    LLRequestTypeGet,
    LLRequestTypePost,
    LLRequestTypePut,
    LLRequestTypeDelete
};

typedef NS_ENUM (NSUInteger, LLResponseStatus){
    LLResponseStatusSuccess = 1,
    LLResponseStatusError
};

/// 请求响应Block
typedef void (^LLResponseBlock)(LLResponse * _Nullable response);
typedef void (^LLGroupResponseBlock)(NSArray<LLResponse *> * _Nullable responseObjects, BOOL isSuccess);
typedef void (^LLNextBlock)(LLRequest * _Nullable request, LLResponse * _Nullable responseObject, BOOL * _Nullable isSent);

/// 请求 配置 Block
typedef void (^LLRequestConfigBlock)(LLRequest * _Nullable request);
typedef void (^LLGroupRequestConfigBlock)(LLGroupRequest * _Nullable groupRequest);
typedef void (^LLChainRequestConfigBlock)(LLChainRequest * _Nullable chainRequest);


#endif /* LLConstant_h */
