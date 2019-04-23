//
//  LLURLManager+Chain.m
//  LLNetWorking
//
//  Created by shizhi on 2017/6/13.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "LLURLManager+Chain.h"
#import "LLChainRequest.h"
#import "LLURLManager+Group.h"
#import <objc/runtime.h>

@implementation LLURLManager (Chain)

- (NSMutableDictionary *)chainRequestDictionary {
    return objc_getAssociatedObject(self, @selector(chainRequestDictionary));
}

- (void)setChainRequestDictionary:(NSMutableDictionary *)mutableDictionary {
    objc_setAssociatedObject(self, @selector(chainRequestDictionary), mutableDictionary, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)sendChainRequest:(nullable LLChainRequestConfigBlock)configBlock complete:(nullable LLGroupResponseBlock)completeBlock {
    LLChainRequest *chainRequest = [[LLChainRequest alloc] init];
    if (configBlock) {
        configBlock(chainRequest);
    }

    if (chainRequest.runningRequest) {
        if (completeBlock) {
            [chainRequest setValue:completeBlock forKey:@"_completeBlock"];
        }

        NSString *uuid = [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [self __sendChainRequst:chainRequest uuid:uuid];
        return uuid;
    }
    return nil;
}

- (void)__sendChainRequst:(LLChainRequest *)chainRequest uuid:(NSString *)uuid {
    if (chainRequest.runningRequest != nil) {
        if (![self chainRequestDictionary]) {
            [self setChainRequestDictionary:[[NSMutableDictionary alloc] init]];
        }
        __weak __typeof(self) weakSelf = self;
        NSString *taskID = [self sendRequest:chainRequest.runningRequest
                                    complete:^(LLResponse *_Nullable response) {
                                      __weak __typeof(self) strongSelf = weakSelf;
                                      if ([chainRequest onFinishedOneRequest:chainRequest.runningRequest response:response]) {
                                      } else {
                                          if (chainRequest.runningRequest != nil) {
                                              [strongSelf __sendChainRequst:chainRequest uuid:uuid];
                                          }
                                      }
                                    }];
        [self chainRequestDictionary][uuid] = taskID;
    }
}

- (void)cancelChainRequest:(NSString *)taskID {
    // 根据 Chain id 找到 taskid
    NSString *tid = [self chainRequestDictionary][taskID];
    [self cancelRequestWithRequestID:tid];
}

@end
