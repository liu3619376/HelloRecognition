//
//  NNConstant.h
//  NNNetWorking
//
//  Created by shizhi on 2017/6/6.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#ifndef NNConstant_h
#define NNConstant_h

@class NNRequest, NNResponse, NNGroupRequest, NNChainRequest;

typedef NS_ENUM (NSUInteger, NNRequestType){
    NNRequestTypeGet,
    NNRequestTypePost,
    NNRequestTypePut,
    NNRequestTypeDelete
};

typedef NS_ENUM (NSUInteger, NNResponseStatus){
    NNResponseStatusSuccess = 1,
    NNResponseStatusError
};

/// 请求响应Block
typedef void (^NNResponseBlock)(NNResponse * _Nullable response);
typedef void (^NNGroupResponseBlock)(NSArray<NNResponse *> * _Nullable responseObjects, BOOL isSuccess);
typedef void (^NNNextBlock)(NNRequest * _Nullable request, NNResponse * _Nullable responseObject, BOOL * _Nullable isSent);

/// 请求 配置 Block
typedef void (^NNRequestConfigBlock)(NNRequest * _Nullable request);
typedef void (^NNGroupRequestConfigBlock)(NNGroupRequest * _Nullable groupRequest);
typedef void (^NNChainRequestConfigBlock)(NNChainRequest * _Nullable chainRequest);


#endif /* NNConstant_h */
