//
//  NetURLManager+Chain.h
//  HelloRecogition
//
//  Created by liuyang on 2017/12/8.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import "NetURLManager.h"

NS_ASSUME_NONNULL_BEGIN
@interface NetURLManager (Chain)

- (NSString *)sendChainRequest:(nullable ChainRequestConfigBlock)configBlock
                      complete:(nullable GroupResponseBlock)completeBlock;

- (void)cancelChainRequest:(NSString *)taskID;


@end
NS_ASSUME_NONNULL_END
