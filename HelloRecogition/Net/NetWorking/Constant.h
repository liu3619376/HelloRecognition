//
//  Constant.h
//  HelloRecogition
//
//  Created by liuyang on 2017/12/4.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

@class Request, Response, GroupRequest, ChainRequest;

typedef NS_ENUM (NSUInteger, RequestType){
    RequestTypeGet,
    RequestTypePost,
    RequestTypePut,
    RequestTypeDelete
};

typedef NS_ENUM (NSUInteger, ResponseStatus){
    ResponseStatusSuccess = 1,
    ResponseStatusError
};

/// 请求响应Block
typedef void (^ResponseBlock)(Response * _Nullable response);
typedef void (^GroupResponseBlock)(NSArray<Response *> * _Nullable responseObjects, BOOL isSuccess);
typedef void (^NextBlock)(Request * _Nullable request, Response * _Nullable responseObject, BOOL * _Nullable isSent);

/// 请求 配置 Block
typedef void (^RequestConfigBlock)(Request * _Nullable request);
typedef void (^GroupRequestConfigBlock)(GroupRequest * _Nullable groupRequest);
typedef void (^ChainRequestConfigBlock)(ChainRequest * _Nullable chainRequest);


#endif /* Constant_h */
