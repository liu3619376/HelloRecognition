//
//  LLURLManager.m
//  LLNetWorking
//
//  Created by shizhi on 2017/6/6.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "LLURLManager.h"
#import "LLLogger.h"
#import "LLRequest.h"
#import "LLResponse.h"
#import "NSString+AES.h"
#import "LLNetConfigure.h"
#import "NSString+MD5.h"
#import "NSDictionary+JSON.h"
#import <AFNetworking/AFNetworking.h>
#import "LLRequestInterceptorProtocol.h"
#import "LLResponseInterceptorProtocol.h"


@interface LLRequest (Generate)
- (NSURLRequest *)generateRequest;
@end

@implementation LLRequest (Generate)

- (NSString *)httpMethod
{
    LLRequestType type = [self requestMethod];
    switch (type)
    {
        case LLRequestTypePost:
            return @"POST";
        case LLRequestTypeGet:
            return @"GET";
        case LLRequestTypePut:
            return @"PUT";
        case LLRequestTypeDelete:
            return @"DELETE";
        default:
            break;
    }
    return @"GET";
}

/// 生成 POST Body 数据
- (NSDictionary *)__generateRequestBody
{
    NSMutableDictionary *commonDict = [LLNetConfigure share].generalParameters.mutableCopy;

    NSMutableDictionary *encryptDict = @{}.mutableCopy;
    NSAssert(self.requestPath.length > 0, @"请求 Path 不能为空");
    [encryptDict addEntriesFromDictionary:commonDict];
    NSMutableDictionary *rslt = @{}.mutableCopy;
    [rslt addEntriesFromDictionary:self.normalParams];
    //参数加密
  //  rslt[@"params2"] = [[encryptDict LL_jsonString] LL_encryptAESAndBase64Data];

    
    NSLog(@"\n<+++++++++=调用参数=++++++++>%@\n<++++++=加密=+++++>%@\n<++++++++++接口调用++++++++++++>\n", encryptDict, rslt);
    return rslt;
}

//这里可以进行域名拼接生成链接地址
- (NSString *)__generateRequestURL
{
    if (self.baseURL.length > 0)
    {
        return self.baseURL;
    }
    return [LLNetConfigure share].generalServer;
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

    NSMutableURLRequest *request = [serializer requestWithMethod:[self httpMethod] URLString:[urlString stringByAppendingString:self.requestPath] parameters:[self __generateRequestBody] error:NULL];

    // header
    NSMutableDictionary *header = request.allHTTPHeaderFields.mutableCopy;
    if (!header)
    {
        header = @{}.mutableCopy;
    }
    
    [header addEntriesFromDictionary:[LLNetConfigure share].generalHeaders];
    [header addEntriesFromDictionary:self.requestHeader]; //添加自定义头请求
    request.allHTTPHeaderFields = header.copy;//拼接完成的请求头

    return request.copy;
}

- (NSURLRequest *)generateNormalRequest { return nil; }
@end

#pragma mark - LLURLManager implement

@interface LLURLManager ()

@property (nonatomic, strong) NSMutableDictionary *reqeustDictionary;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) NSMutableArray *requestInterceptorObjectArray;
@property (nonatomic, strong) NSMutableArray *responseInterceptorObjectArray;

@end

@implementation LLURLManager

+ (void)load { [[AFNetworkReachabilityManager sharedManager] startMonitoring]; }
+ (nonnull instancetype)manager
{
    static dispatch_once_t onceToken;
    static LLURLManager *manager = nil;
    dispatch_once(&onceToken, ^{
      manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _requestInterceptorObjectArray = [NSMutableArray arrayWithCapacity:3];
        _responseInterceptorObjectArray = [NSMutableArray arrayWithCapacity:3];
        _reqeustDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (AFHTTPSessionManager *)sessionManager
{
    if (_sessionManager == nil)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPMaximumConnectionsPerHost = 4;
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                             @"text/plain",
                                                             @"application/json",
                                                             @"text/json",
                                                             @"text/javascript",
                                                             @"text/html",
                                                             @"application/x-javascript",
                                                             nil];
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;

    }
    return _sessionManager;
}

- (NSString *)sendRequest:(nonnull LLRequest *)request complete:(nonnull LLResponseBlock)result
{
    // 拦截器处理
    if (![self needRequestInterceptor:request])
    {
        if ([LLNetConfigure share].enableDebug)
        {
            NSLog(@"该请求已经取消");
            [LLLogger logDebugInfoWithRequest:request];
        }
        return @"";
    }
    return [self requestWithRequest:[request generateRequest] orginRequest:request complete:result];
}

- (NSString *)sendRequestWithConfigBlock:(nonnull LLRequestConfigBlock)requestBlock complete:(nonnull LLResponseBlock)result
{
    LLRequest *request = [LLRequest new];
    requestBlock(request);
    // 拦截器处理
    if (![self needRequestInterceptor:request])
    {
        if ([LLNetConfigure share].enableDebug)
        {
            NSLog(@"该请求已经取消");
            [LLLogger logDebugInfoWithRequest:request];
        }
        return @"";
    }
    return [self requestWithRequest:[request generateRequest] orginRequest:request complete:result];
}

- (BOOL)needRequestInterceptor:(LLRequest *)request
{
    BOOL need = true;
    for (id obj in self.requestInterceptorObjectArray)
    {
        if ([obj respondsToSelector:@selector(needRequestWithRequest:)])
        {
            need = [obj needRequestWithRequest:request];
            if (need)
            {
                break;
            }
        }
    }
    return need;
}

- (NSString *)requestWithRequest:(NSURLRequest *)request orginRequest:(LLRequest *)LLRequest complete:(LLResponseBlock)success
{
      // ========= 未通过网络检查 ==========
    if (![[AFNetworkReachabilityManager sharedManager] isReachable])
    {
        NSError *err = [NSError errorWithDomain:@"" code:-1 userInfo:nil];
        LLResponse *rsp = [[LLResponse alloc] initWithRequestId:@(0) request:request responseData:nil error:err];
        for (id obj in self.responseInterceptorObjectArray)
        {
            if ([obj respondsToSelector:@selector(validatorResponse:)])
            {
                [obj validatorResponse:rsp];
                break;
            }
        }

        success ? success(rsp) : nil;
        return nil;
    }

    __block NSURLSessionDataTask *task = nil;
    task = [self.sessionManager dataTaskWithRequest:request
                                     uploadProgress:nil
                                   downloadProgress:nil
                                  completionHandler:^(NSURLResponse *_Nonnull response, id _Nullable responseObject, NSError *_Nullable error) {
                                    [self.reqeustDictionary removeObjectForKey:@([task taskIdentifier])];
                                    NSData *responseData = responseObject;
                                    [self requestFinishedWithBlock:success task:task data:responseData error:error];
                                  }];

    NSString *requestId = [[NSString alloc] initWithFormat:@"%ld", [task taskIdentifier]];
    self.reqeustDictionary[requestId] = task;
    [task resume];
    return requestId;
}

- (void)requestFinishedWithBlock:(LLResponseBlock)blk task:(NSURLSessionTask *)task data:(NSData *)data error:(NSError *)error
{
    if ([LLNetConfigure share].enableDebug)
    {
        [LLLogger logDebugInfoWithTask:task data:data error:error];
    }

    if (error)
    {
        LLResponse *rsp = [[LLResponse alloc] initWithRequestId:@([task taskIdentifier]) request:task.originalRequest responseData:data error:error];
        for (id obj in self.responseInterceptorObjectArray)
        {
            if ([obj respondsToSelector:@selector(validatorResponse:)])
            {
                [obj validatorResponse:rsp];
                break;
            }
        }
        blk ? blk(rsp) : nil;
    }
    else
    {
        LLResponse *rsp = [[LLResponse alloc] initWithRequestId:@([task taskIdentifier]) request:task.originalRequest responseData:data status:LLResponseStatusSuccess];
        for (id obj in self.responseInterceptorObjectArray)
        {
            if ([obj respondsToSelector:@selector(validatorResponse:)])
            {
                [obj validatorResponse:rsp];
                break;
            }
        }
        blk ? blk(rsp) : nil;
    }
}

- (void)cancelRequestWithRequestID:(nonnull NSString *)requestID
{
    NSURLSessionDataTask *requestOperation = self.reqeustDictionary[requestID];
    [requestOperation cancel];
    [self.reqeustDictionary removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(nonnull NSArray<NSString *> *)requestIDList
{
    for (NSString *requestId in requestIDList)
    {
        [self cancelRequestWithRequestID:requestId];
    }
}

@end

#pragma mark - 拦截

@implementation LLURLManager (Validate)

+ (void)registerResponseInterceptor:(nonnull Class)cls
{
    if (![cls conformsToProtocol:@protocol(LLResponseInterceptorProtocol)])
    {
        return;
    }

    [LLURLManager unregisterResponseInterceptor:cls];

    LLURLManager *share = [LLURLManager manager];
    [share.responseInterceptorObjectArray addObject:[cls new]];
}

+ (void)unregisterResponseInterceptor:(nonnull Class)cls
{
    LLURLManager *share = [LLURLManager manager];

    for (id obj in share.responseInterceptorObjectArray)
    {
        if ([obj isKindOfClass:[cls class]])
        {
            [share.responseInterceptorObjectArray removeObject:obj];
            break;
        }
    }
}

+ (void)registerRequestInterceptor:(nonnull Class)cls
{
    if (![cls conformsToProtocol:@protocol(LLRequestInterceptorProtocol)])
    {
        return;
    }

    [LLURLManager unregisterRequestInterceptor:cls];

    LLURLManager *share = [LLURLManager manager];
    [share.requestInterceptorObjectArray addObject:[cls new]];
}

+ (void)unregisterRequestInterceptor:(nonnull Class)cls
{
    LLURLManager *share = [LLURLManager manager];

    for (id obj in share.requestInterceptorObjectArray)
    {
        if ([obj isKindOfClass:[cls class]])
        {
            [share.requestInterceptorObjectArray removeObject:obj];
            break;
        }
    }
}

@end
