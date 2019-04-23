//
//  LLURLManager+Group.m
//  LLNetWorking
//
//  Created by shizhi on 2017/6/13.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "LLURLManager+Group.h"
#import "LLGroupRequest.h"
#import "LLRequest.h"
#import <objc/runtime.h>

@implementation LLURLManager (Group)

- (NSMutableDictionary *)groupRequestDictionary {
    return objc_getAssociatedObject(self, @selector(groupRequestDictionary));
}

- (void)setGroupRequestDictionary:(NSMutableDictionary *)mutableDictionary {
    objc_setAssociatedObject(self, @selector(groupRequestDictionary), mutableDictionary, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)sendGroupRequest:(nullable LLGroupRequestConfigBlock)configBlock
                     complete:(nullable LLGroupResponseBlock)completeBlock {
    
    if (![self groupRequestDictionary]) {
        [self setGroupRequestDictionary:[[NSMutableDictionary alloc] init]];
    }
    
    NSMutableArray *tempArray = @[].mutableCopy;
    LLGroupRequest *groupRequest = [[LLGroupRequest alloc] init];
    configBlock(groupRequest);
    
    if (groupRequest.requestArray.count > 0) {
        if (completeBlock) {
            [groupRequest setValue:completeBlock forKey:@"_completeBlock"];
        }
        
        [groupRequest.responseArray removeAllObjects];
        for (LLRequest *request in groupRequest.requestArray) {
            
             NSString *taskID = [self sendRequest:request complete:^(LLResponse * _Nullable response) {
                if ([groupRequest onFinishedOneRequest:request response:response]) {
                    NSLog(@"finish");
                }
            }];
            [tempArray addObject:taskID];
        }
        NSString *uuid = [[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [self groupRequestDictionary][uuid] = tempArray.copy;
        return uuid;
    }
    return nil;
}

- (void)cancelGroupRequest:(NSString *)taskID {
    NSArray *group = [self groupRequestDictionary][taskID];
    for (NSString *tid in group) {
        [self cancelRequestWithRequestID:tid];
    }
}

@end
