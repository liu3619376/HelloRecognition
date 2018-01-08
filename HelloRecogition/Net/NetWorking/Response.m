//
//  Response.m
//  HelloRecogition
//
//  Created by liuyang on 2017/12/5.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import "Response.h"

@interface Response()

@property (nonatomic, copy, readwrite) NSData *rawData;
@property (nonatomic, assign, readwrite) ResponseStatus status;
@property (nonatomic, copy, readwrite) id content;
@property (nonatomic, assign, readwrite) NSInteger statueCode;
@property (nonatomic, assign, readwrite) NSInteger requestId;
@property (nonatomic, copy, readwrite) NSURLRequest *request;

@end

@implementation Response

#pragma mark - life cycle
- (nonnull instancetype)initWithRequestId:(nonnull NSNumber *)requestId
                                  request:(nonnull NSURLRequest *)request
                             responseData:(nullable NSData *)responseData
                                   status:(ResponseStatus)status
{
    self = [super init];
    if (self)
    {
        self.requestId = [requestId unsignedIntegerValue];
        self.request = request;
        self.rawData = responseData;
        [self inspectionResponse:nil];
    }
    return self;
}

- (nonnull instancetype)initWithRequestId:(nonnull NSNumber *)requestId
                                  request:(nonnull NSURLRequest *)request
                             responseData:(nullable NSData *)responseData
                                    error:(nullable NSError *)error
{
    self = [super init];
    if (self)
    {
        self.requestId = [requestId unsignedIntegerValue];
        self.request = request;
        self.rawData = responseData;
        [self inspectionResponse:error];
    }
    return self;
}

- (id)jsonWithData:(NSData *)data { return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL]; }
#pragma mark - Private methods

- (void)inspectionResponse:(NSError *)error
{
    if (error)
    {
        self.status = ResponseStatusError;
        self.content = @"网络异常，请稍后再试";
        self.statueCode = error.code;
    }
    else
    {
        if (self.rawData.length > 0)
        {
            NSDictionary *dic = [self jsonWithData:self.rawData];
            
            BOOL result = MAX([dic[@"success"] boolValue], [dic[@"result"] boolValue]);
            if (result)
            {
                self.status = ResponseStatusSuccess;
                self.content = [self processCotnentValue:dic];
                NSString *code = dic[@"code"];
                if (code && [code isKindOfClass:[NSString class]]) {
                    self.statueCode = ((NSString*)code).integerValue;
                }
            }
            else
            {
                self.status = ResponseStatusError;
                self.content = dic[@"msg"];
                NSString *code = dic[@"code"];
                if (code && [code isKindOfClass:[NSString class]]) {
                    self.statueCode = ((NSString*)code).integerValue;
                }
                if (![self.content isKindOfClass:[NSString class]]) {
                    self.content = @"未知错误";
                }
            }
        }
        else
        {
            self.statueCode = NSURLErrorUnknown;
            self.status = ResponseStatusError;
            self.content = @"未知错误";
        }
    }
}

/// 临时 返回数据处理
- (id)processCotnentValue:(id)content
{
    if ([content isKindOfClass:[NSDictionary class]])
    {
        NSMutableDictionary *contentDict = ((NSDictionary *)content).mutableCopy;
        [contentDict removeObjectForKey:@"result"];
        //        [contentDict removeObjectForKey:@"msg"];
        
        if ([contentDict[@"data"] isKindOfClass:[NSNull class]])
        {
            [contentDict removeObjectForKey:@"data"];
        }
        
        return contentDict.copy;
    }
    return content;
}


@end
