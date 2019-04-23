//
//  NSString+AES.h
//  LLNetWorking
//
//  Created by shizhi on 2017/6/7.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "LLLogger.h"
#import "LLRequest.h"
#import "NSString+AES.h"

@implementation LLLogger

+ (NSString *)httpMethod:(LLRequestType)type
{
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

+ (void)logSigeInfoWithString:(NSString *)sige
{
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n**************************************************************\n*                       签名参数          "
                                                                   @"                    *\n**************************************************************\n\n"];

    [logString appendFormat:@"%@", sige];
    [logString appendFormat:@"\n\n**************************************************************\n*                         签名参数                            "
                            @"*\n**************************************************************\n\n\n\n"];
    NSLog(@"%@", logString);
}

+ (void)logDebugInfoWithRequest:(LLRequest *)request
{
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n**************************************************************\n*                       Request Start     "
                                                                   @"                   *\n**************************************************************\n\n"];

    [logString appendFormat:@"Method:\t\t\t%@\n", [LLLogger httpMethod:[request requestMethod]]];
    [logString appendFormat:@"Version:\t\t%@\n", request.apiVersion];
    [logString appendFormat:@"Service:\t\t%@\n", request.requestPath];
    [logString appendFormat:@"normalParams:\n%@", request.normalParams];
    [logString appendFormat:@"\n\nHTTP URL:\n\t%@", request.baseURL];
    [logString appendFormat:@"\n\n**************************************************************\n*                         Request End                        "
                            @"*\n**************************************************************\n\n\n\n"];
    NSLog(@"%@", logString);
}

+ (void)logDebugInfoWithTask:(NSURLSessionTask *)sessionTask data:(NSData *)data error:(NSError *)error
{
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                        API Response     "
                                                                   @"                   =\n==============================================================\n\n"];
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)sessionTask.response;
    NSURLRequest *request = sessionTask.originalRequest;

    [logString appendFormat:@"\nHTTP URL:\n\t%@", request.URL];
    [logString appendFormat:@"\n\nHTTP Header:\n%@", request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @"\t\t\t\t\tN/A"];

    NSString *jsonString = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    if (jsonString.length > 0)
    {
        NSArray *pas = [jsonString componentsSeparatedByString:@"&"];
        for (NSString *key in pas)
        {
            NSArray *p2 = [key componentsSeparatedByString:@"="];
            // 解密加密参数
            if (p2.count >= 2 && [p2[0] isEqualToString:@"params2"])
            {
                jsonString = p2[1];
                jsonString = [jsonString nn_decryAESAndBase64Data];
            }
            // 公共参数
            else
            {
            }
        }
    }

    [logString appendFormat:@"\n\nHTTP Body:\n\t%@", jsonString.stringByRemovingPercentEncoding ?: @"\t\t\t\tN/A"];

    [logString appendFormat:@"\n\nStatus:\t%ld\t(%@)\n\n", (long)response.statusCode, [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode]];
    [logString appendFormat:@"Content:\n\t%@\n\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    if (error)
    {
        [logString appendFormat:@"Error Domain:\t\t\t\t\t\t\t%@\n", error.domain];
        [logString appendFormat:@"Error Domain Code:\t\t\t\t\t\t%ld\n", (long)error.code];
        [logString appendFormat:@"Error Localized Description:\t\t\t%@\n", error.localizedDescription];
        [logString appendFormat:@"Error Localized Failure Reason:\t\t\t%@\n", error.localizedFailureReason];
        [logString appendFormat:@"Error Localized Recovery Suggestion:\t%@\n\n", error.localizedRecoverySuggestion];
    }

    [logString appendFormat:@"\n\n==============================================================\n=                        Response End                        "
                            @"=\n==============================================================\n\n\n\n"];

    NSLog(@"%@", logString);
}

@end
