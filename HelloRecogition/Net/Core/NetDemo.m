//
//  NetDemo.m
//  HelloRecogition
//
//  Created by 闪闪互动 on 2019/4/22.
//  Copyright © 2019 liuyang. All rights reserved.
//

#import "NetDemo.h"
#import "LLNetWorking.h"


@implementation NetDemo


-(void)Demo1
{
    //普通sw
    LLRequest *reques = [[LLRequest alloc] init];
    NSString *taskid = [[LLURLManager manager] sendRequest:reques complete:^(LLResponse * _Nullable response) {
        
    }];
    //取消请求
    [[LLURLManager manager] cancelRequestWithRequestID:taskid];
}

-(void)Demo2
{
    //多任务 异步请求
     LLGroupRequest *request = [[LLGroupRequest alloc] init];
     LLRequest *reques1 = [[LLRequest alloc] init];
     LLRequest *reques2 = [[LLRequest alloc] init];
    [request addRequest:reques1];
    [request addRequest:reques2];
    
    [[LLURLManager manager] sendGroupRequest:^(LLGroupRequest * _Nullable groupRequest) {
        groupRequest = request;
    } complete:^(NSArray<LLResponse *> * _Nullable responseObjects, BOOL isSuccess) {
        if (isSuccess) { // 所有请求都完成
            for (int i=0; i<responseObjects.count; i++) {
                LLResponse *resp = responseObjects[i];
                NSLog(@"%d ==FINISH== %ld", i, (long)resp.requestId);
            }
        }
    }];
 
}

-(void)Demo3
{
    //多任务顺序同步请求
    [[LLURLManager manager] sendChainRequest:^(LLChainRequest * _Nullable chainRequest) {
        [chainRequest onFirst:^(LLRequest * _Nullable request) {
            request.requestPath = @"";
        }];
        [chainRequest onNext:^(LLRequest * _Nullable request, LLResponse * _Nullable responseObject, BOOL * _Nullable isSent) {
             request.requestPath = @"/singlePoetry";
        }];
        [chainRequest onNext:^(LLRequest * _Nullable request, LLResponse * _Nullable responseObject, BOOL * _Nullable isSent) {
            request.requestPath = @"/singlePoetry";
        }];
    } complete:^(NSArray<LLResponse *> * _Nullable responseObjects, BOOL isSuccess) {
        if (isSuccess) { // 所有请求都完成
            for (int i=0; i<responseObjects.count; i++) {
                LLResponse *resp = responseObjects[i];
                NSLog(@"%d ==FINISH== %ld", i, (long)resp.requestId);
            }
        }
    }];
}
@end
