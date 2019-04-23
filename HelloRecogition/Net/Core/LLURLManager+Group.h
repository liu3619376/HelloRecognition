//
//  LLURLManager+Group.h
//  LLNetWorking
//
//  Created by shizhi on 2017/6/13.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "LLURLManager.h"
#import "LLConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLURLManager (Group)

- (NSString *)sendGroupRequest:(nullable LLGroupRequestConfigBlock)configBlock
                     complete:(nullable LLGroupResponseBlock)completeBlock;


- (void)cancelGroupRequest:(NSString *)taskID;

@end

NS_ASSUME_NONNULL_END
