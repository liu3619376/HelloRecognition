//
//  Logger.h
//  HelloRecogition
//
//  Created by liuyang on 2017/12/4.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"

@interface Logger : NSObject

+ (void)logSigeInfoWithString:(NSString *)sige;
+ (void)logDebugInfoWithRequest:(Request *)request;
+ (void)logDebugInfoWithTask:(NSURLSessionTask *)sessionTask data:(NSData *)data error:(NSError *)error;

@end
