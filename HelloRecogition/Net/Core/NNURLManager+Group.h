//
//  NNURLManager+Group.h
//  NNNetWorking
//
//  Created by shizhi on 2017/6/13.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "NNURLManager.h"
#import "NNConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface NNURLManager (Group)

- (NSString *)sendGroupRequest:(nullable NNGroupRequestConfigBlock)configBlock
                     complete:(nullable NNGroupResponseBlock)completeBlock;


- (void)cancelGroupRequest:(NSString *)taskID;

@end

NS_ASSUME_NONNULL_END
