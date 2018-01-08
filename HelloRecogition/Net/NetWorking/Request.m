//
//  Request.m
//  HelloRecogition
//
//  Created by liuyang on 2017/12/5.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import "Request.h"
#import "NetConfigure.h"



@implementation Request

- (instancetype)init {
    self = [super init];
    if (self) {
        //默认post 请求
        _requestMethod = RequestTypePost;
        _reqeustTimeoutInterval = 30.0;
        _encryptParams = @{};
        _normalParams = @{};
        _requestHeader = @{};
        _retryCount = 0;
        _apiVersion = @"1.0";
        
    }
    return self;
}

- (void)dealloc {
    if ([NetConfigure share].enableDebug) {
        NSLog(@"dealloc: %@", ([self class]));
    }
}

@end

@implementation Request (Generate)

- (NSString *)httpMethod
{
    RequestType type = [self requestMethod];
    switch (type)
    {
        case RequestTypePost:
            return @"POST";
        case RequestTypeGet:
            return @"GET";
        case RequestTypePut:
            return @"PUT";
        case RequestTypeDelete:
            return @"DELETE";
        default:
            break;
    }
    return @"GET";
}

/// 生成 POST Body 数据
- (NSDictionary *)__generateRequestBody
{
    NSDictionary *commonDict = [NetConfigure share].generalParameters;
    
    NSMutableDictionary *encryptDict = @{}.mutableCopy;
    NSAssert(self.requestPath.length > 0, @"请求 Path 不能为空");
    encryptDict[@"uri"] = self.requestPath;
    [encryptDict addEntriesFromDictionary:commonDict];
    [encryptDict addEntriesFromDictionary:self.encryptParams];
    
    NSMutableDictionary *rslt = @{}.mutableCopy;
    [rslt addEntriesFromDictionary:self.normalParams];
    rslt[@"params2"] = [[encryptDict nn_jsonString] nn_encryptAESAndBase64Data];
    
    
    NSLog(@"%@", encryptDict);
    return rslt;
}

- (NSString *)__generateRequestURL
{
    if (self.reqeustURLString.length > 0)
    {
        return self.reqeustURLString;
    }
    return [NetConfigure share].generalServer;
}

/**
 生成最终请求
 
 @return NSURLRequest
 */
- (NSURLRequest *)generateRequest
{
    NSString *urlString = [self __generateRequestURL];
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    serializer.timeoutInterval = [self reqeustTimeoutInterval];
    serializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    NSMutableURLRequest *request = [serializer requestWithMethod:[self httpMethod] URLString:urlString parameters:[self __generateRequestBody] error:NULL];
    
    // header
    NSMutableDictionary *header = request.allHTTPHeaderFields.mutableCopy;
    if (!header)
    {
        header = @{}.mutableCopy;
    }
    [header addEntriesFromDictionary:[NetConfigure share].generalHeaders];
    request.allHTTPHeaderFields = header;
    
    return request.copy;
}

- (NSURLRequest *)generateNormalRequest { return nil; }
@end
