//
//  NNURLManager+Chain.h
//  NNNetWorking
//
//  Created by shizhi on 2017/6/13.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "NNURLManager.h"

NS_ASSUME_NONNULL_BEGIN
@interface NNURLManager (Chain)

- (NSString *)sendChainRequest:(nullable NNChainRequestConfigBlock)configBlock
                     complete:(nullable NNGroupResponseBlock)completeBlock;

- (void)cancelChainRequest:(NSString *)taskID;

@end

NS_ASSUME_NONNULL_END
