//
//  UIViewController+NNAppearLog.m
//  NNLetter
//
//  Created by shizhi on 2017/6/6.
//  Copyright © 2017年 niannian. All rights reserved.
//

#import "UIViewController+NNUMengEvent.h"
#import "NSObject+NNMethodSwizzling.h"
#import <objc/runtime.h>
#import "NNMuseumRequest.h"

@implementation UIViewController (NNUMengEvent)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      [UIViewController nn_methodSwizzling:@selector(viewWillAppear:) descSel:@selector(nn_viewWillAppear:)];
      [UIViewController nn_methodSwizzling:@selector(viewWillDisappear:) descSel:@selector(nn_viewWillDisappear:)];
    });
}

- (void)nn_viewWillAppear:(BOOL)animated
{
    
    if (![NSStringFromClass([self class]) isEqualToString:@"RTContainerController"]
        && ![NSStringFromClass([self class]) isEqualToString:@"RTContainerNavigationController"]
        && ![NSStringFromClass([self class]) hasPrefix: @"UI"])
    {
        NSLog(@"------------------------------------------------");
        NSLog(@"nn_viewWillAppear: %@", [self className]);
        NSLog(@"------------------------------------------------");
    }

    if (self.pageID)
    {
        [MobClick beginLogPageView:self.pageID];
    }

    [self nn_viewWillAppear:animated];
}

- (void)nn_viewWillDisappear:(BOOL)animated
{
    if (self.pageID)
    {
        [MobClick endLogPageView:self.pageID];
    }

    [self nn_viewWillDisappear:animated];
}

- (void)setPageID:(NSString *)pageID
{
    objc_setAssociatedObject(self, @selector(pageID), pageID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)pageID
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)nn_shareAnasisyWithSourceId:(NSString *)sourceId type:(NSString *)type{
    NNMuseumRequest *request = [[NNMuseumRequest alloc] init_userShareArticleWithSourceId:sourceId type:type];
    
    [[NNURLManager manager] sendRequest:request complete:^(NNResponse * _Nullable response) {
        if (response.status == NNResponseStatusSuccess) {
            NSLog(@"\n==========分享统计%@==========\n", sourceId);
        }
    }];
}

@end
