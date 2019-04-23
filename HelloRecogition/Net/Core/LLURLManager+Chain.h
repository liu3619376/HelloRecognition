//
//  LLURLManager+Chain.h
//  LLNetWorking
//
//  Created by shizhi on 2017/6/13.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "LLURLManager.h"

NS_ASSUME_NONNULL_BEGIN
@interface LLURLManager (Chain)

- (NSString *)sendChainRequest:(nullable LLChainRequestConfigBlock)configBlock
                     complete:(nullable LLGroupResponseBlock)completeBlock;

- (void)cancelChainRequest:(NSString *)taskID;

@end

NS_ASSUME_NONNULL_END
