//
//  NSString+AES.h
//  NNNetWorking
//
//  Created by shizhi on 2017/6/7.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NNRequest;
@interface NNLogger : NSObject

+ (void)logSigeInfoWithString:(NSString *)sige;
+ (void)logDebugInfoWithRequest:(NNRequest *)request;
+ (void)logDebugInfoWithTask:(NSURLSessionTask *)sessionTask data:(NSData *)data error:(NSError *)error;

@end
