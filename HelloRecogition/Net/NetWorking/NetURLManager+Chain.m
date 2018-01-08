//
//  NetURLManager+Chain.m
//  HelloRecogition
//
//  Created by liuyang on 2017/12/8.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import "NetURLManager+Chain.h"
#import <objc/runtime.h>

@implementation NetURLManager (Chain)

-(NSMutableDictionary *)chainRequestDictionary
{
    return objc_getAssociatedObject(self, @selector(chainRequestDictionary));
}


-(void)setChainRequestDictionary:(NSMutableDictionary*)mutableDictionary
{
    objc_setAssociatedObject(self, @selector(chainRequestDictionary), mutableDictionary, OBJC_ASSOCIATION_RETAIN);
}

@end
