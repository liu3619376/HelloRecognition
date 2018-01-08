//
//  NetURLManager.m
//  HelloRecogition
//
//  Created by liuyang on 2017/12/8.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import "NetURLManager.h"
#import "NetConfigure.h"
#import "Logger.h"
#import "Request.h"
#import "Response.h"
#import "RequestInterceptorProtocol.h"
#import "AFNetworkReachabilityManager+NNNetMonitor.h"
#import "ResponseInterceptorProtocol.h"


@interface NetURLManager()

@property (nonatomic, strong) NSMutableDictionary *reqeustDictionary;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) NSMutableArray *requestInterceptorObjectArray;
@property (nonatomic, strong) NSMutableArray *responseInterceptorObjectArray;

@end


@implementation NetURLManager

+ (void)load { [[AFNetworkReachabilityManager sharedManager] startMonitoring]; }

+ (nonnull instancetype)manager
{
    static dispatch_once_t onceToken;
    static NetURLManager *manager = nil;
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
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    return _sessionManager;
}

- (NSString *)sendRequest:(nonnull Request *)request complete:(nonnull ResponseBlock)result
{
    // 拦截器处理
    if (![self needRequestInterceptor:request])
    {
        if ([NetConfigure share].enableDebug)
        {
            NSLog(@"该请求已经取消");
            [Logger logDebugInfoWithRequest:request];
        }
        return nil;
    }
    return [self requestWithRequest:[request generateRequest] orginRequest:request complete:result];
}

- (NSString *)sendRequestWithConfigBlock:(nonnull RequestConfigBlock)requestBlock complete:(nonnull ResponseBlock)result
{
    Request *request = [Request new];
    requestBlock(request);
    // 拦截器处理
    if (![self needRequestInterceptor:request])
    {
        if ([NetConfigure share].enableDebug)
        {
            NSLog(@"该请求已经取消");
            [Logger logDebugInfoWithRequest:request];
        }
        return nil;
    }
    return [self requestWithRequest:[request generateRequest] orginRequest:request complete:result];
}

- (BOOL)needRequestInterceptor:(Request *)request
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

- (NSString *)requestWithRequest:(NSURLRequest *)request orginRequest:(Request *)nnRequest complete:(ResponseBlock)success
{
    // 网络检查
    if (![[AFNetworkReachabilityManager sharedManager] isReachable] && ![[AFNetworkReachabilityManager sharedManager] nn_isReachableNetwork])
    {
        NSError *err = [NSError errorWithDomain:@"" code:-1 userInfo:nil];
        Response *rsp = [[Response alloc] initWithRequestId:@(0) request:request responseData:nil error:err];
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

- (void)requestFinishedWithBlock:(ResponseBlock)blk task:(NSURLSessionTask *)task data:(NSData *)data error:(NSError *)error
{
    if ([NetConfigure share].enableDebug)
    {
        [Logger logDebugInfoWithTask:task data:data error:error];
    }
    
    if (error)
    {
        Response *rsp = [[Response alloc] initWithRequestId:@([task taskIdentifier]) request:task.originalRequest responseData:data error:error];
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
        Response *rsp = [[Response alloc] initWithRequestId:@([task taskIdentifier]) request:task.originalRequest responseData:data status:ResponseStatusSuccess];
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

@implementation NetURLManager (Validate)

+ (void)registerResponseInterceptor:(nonnull Class)cls
{
    if (![cls conformsToProtocol:@protocol(ResponseInterceptorProtocol)])
    {
        return;
    }
    
    [NetURLManager unregisterResponseInterceptor:cls];
    
    NetURLManager *share = [NetURLManager manager];
    [share.responseInterceptorObjectArray addObject:[cls new]];
}

+ (void)unregisterResponseInterceptor:(nonnull Class)cls
{
    NetURLManager *share = [NetURLManager manager];
    
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
    if (![cls conformsToProtocol:@protocol(RequestInterceptorProtocol)])
    {
        return;
    }
    
    [NetURLManager unregisterRequestInterceptor:cls];
    
    NetURLManager *share = [NetURLManager manager];
    [share.requestInterceptorObjectArray addObject:[cls new]];
}

+ (void)unregisterRequestInterceptor:(nonnull Class)cls
{
    NetURLManager *share = [NetURLManager manager];
    
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
