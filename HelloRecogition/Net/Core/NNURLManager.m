//
//  NNURLManager.m
//  NNNetWorking
//
//  Created by shizhi on 2017/6/6.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "NNURLManager.h"
#import "NNLogger.h"
#import "NNRequest.h"
#import "NNResponse.h"
#import "NSString+AES.h"
#import "NNNetConfigure.h"
#import "NSString+MD5.h"
#import "NSDictionary+JSON.h"
#import <AFNetworking/AFNetworking.h>
#import "NNRequestInterceptorProtocol.h"
#import "NNResponseInterceptorProtocol.h"
#import "AFNetworkReachabilityManager+NNNetMonitor.h"

@interface NNRequest (Generate)
- (NSURLRequest *)generateRequest;
@end

@implementation NNRequest (Generate)

- (NSString *)httpMethod
{
    NNRequestType type = [self requestMethod];
    switch (type)
    {
        case NNRequestTypePost:
            return @"POST";
        case NNRequestTypeGet:
            return @"GET";
        case NNRequestTypePut:
            return @"PUT";
        case NNRequestTypeDelete:
            return @"DELETE";
        default:
            break;
    }
    return @"GET";
}

/// 生成 POST Body 数据
- (NSDictionary *)__generateRequestBody
{
    NSDictionary *commonDict = [NNNetConfigure share].generalParameters;

    NSMutableDictionary *encryptDict = @{}.mutableCopy;
    NSAssert(self.requestPath.length > 0, @"请求 Path 不能为空");
    encryptDict[@"uri"] = self.requestPath;
    [encryptDict addEntriesFromDictionary:commonDict];
    [encryptDict addEntriesFromDictionary:self.encryptParams];

    NSMutableDictionary *rslt = @{}.mutableCopy;
    [rslt addEntriesFromDictionary:self.normalParams];
    rslt[@"params2"] = [[encryptDict nn_jsonString] nn_encryptAESAndBase64Data];

    
    NSLog(@"\n<+++++++++=调用参数=++++++++>%@\n<++++++=加密=+++++>%@\n<++++++++++接口调用++++++++++++>\n", encryptDict, rslt);
    return rslt;
}

- (NSString *)__generateRequestURL
{
    if (self.reqeustURLString.length > 0)
    {
        return self.reqeustURLString;
    }
    return [NNNetConfigure share].generalServer;
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
    [header addEntriesFromDictionary:[NNNetConfigure share].generalHeaders];
    request.allHTTPHeaderFields = header;

    return request.copy;
}

- (NSURLRequest *)generateNormalRequest { return nil; }
@end

#pragma mark - NNURLManager implement

@interface NNURLManager ()

@property (nonatomic, strong) NSMutableDictionary *reqeustDictionary;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) NSMutableArray *requestInterceptorObjectArray;
@property (nonatomic, strong) NSMutableArray *responseInterceptorObjectArray;

@end

@implementation NNURLManager

+ (void)load { [[AFNetworkReachabilityManager sharedManager] startMonitoring]; }
+ (nonnull instancetype)manager
{
    static dispatch_once_t onceToken;
    static NNURLManager *manager = nil;
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
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
//        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    return _sessionManager;
}

- (NSString *)sendRequest:(nonnull NNRequest *)request complete:(nonnull NNResponseBlock)result
{
    // 拦截器处理
    if (![self needRequestInterceptor:request])
    {
        if ([NNNetConfigure share].enableDebug)
        {
            NSLog(@"该请求已经取消");
            [NNLogger logDebugInfoWithRequest:request];
        }
        return @"";
    }
    return [self requestWithRequest:[request generateRequest] orginRequest:request complete:result];
}

- (NSString *)sendRequestWithConfigBlock:(nonnull NNRequestConfigBlock)requestBlock complete:(nonnull NNResponseBlock)result
{
    NNRequest *request = [NNRequest new];
    requestBlock(request);
    // 拦截器处理
    if (![self needRequestInterceptor:request])
    {
        if ([NNNetConfigure share].enableDebug)
        {
            NSLog(@"该请求已经取消");
            [NNLogger logDebugInfoWithRequest:request];
        }
        return @"";
    }
    return [self requestWithRequest:[request generateRequest] orginRequest:request complete:result];
}

- (BOOL)needRequestInterceptor:(NNRequest *)request
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

- (NSString *)requestWithRequest:(NSURLRequest *)request orginRequest:(NNRequest *)nnRequest complete:(NNResponseBlock)success
{
    // 网络检查
    if (![[AFNetworkReachabilityManager sharedManager] isReachable] && ![[AFNetworkReachabilityManager sharedManager] nn_isReachableNetwork])
    {
        NSError *err = [NSError errorWithDomain:@"" code:-1 userInfo:nil];
        NNResponse *rsp = [[NNResponse alloc] initWithRequestId:@(0) request:request responseData:nil error:err];
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

- (void)requestFinishedWithBlock:(NNResponseBlock)blk task:(NSURLSessionTask *)task data:(NSData *)data error:(NSError *)error
{
    if ([NNNetConfigure share].enableDebug)
    {
        [NNLogger logDebugInfoWithTask:task data:data error:error];
    }

    if (error)
    {
        NNResponse *rsp = [[NNResponse alloc] initWithRequestId:@([task taskIdentifier]) request:task.originalRequest responseData:data error:error];
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
        NNResponse *rsp = [[NNResponse alloc] initWithRequestId:@([task taskIdentifier]) request:task.originalRequest responseData:data status:NNResponseStatusSuccess];
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

@implementation NNURLManager (Validate)

+ (void)registerResponseInterceptor:(nonnull Class)cls
{
    if (![cls conformsToProtocol:@protocol(NNResponseInterceptorProtocol)])
    {
        return;
    }

    [NNURLManager unregisterResponseInterceptor:cls];

    NNURLManager *share = [NNURLManager manager];
    [share.responseInterceptorObjectArray addObject:[cls new]];
}

+ (void)unregisterResponseInterceptor:(nonnull Class)cls
{
    NNURLManager *share = [NNURLManager manager];

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
    if (![cls conformsToProtocol:@protocol(NNRequestInterceptorProtocol)])
    {
        return;
    }

    [NNURLManager unregisterRequestInterceptor:cls];

    NNURLManager *share = [NNURLManager manager];
    [share.requestInterceptorObjectArray addObject:[cls new]];
}

+ (void)unregisterRequestInterceptor:(nonnull Class)cls
{
    NNURLManager *share = [NNURLManager manager];

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
