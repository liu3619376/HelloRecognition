//
//  UIViewController+NNAppearLog.h
//  NNLetter
//
//  Created by shizhi on 2017/6/6.
//  Copyright © 2017年 niannian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NNUMengEvent)

@property (nonatomic, copy) NSString *pageID;

/**
 分享统计

 @param sourceId id
 @param type 类型
 */
- (void)nn_shareAnasisyWithSourceId:(NSString *)sourceId type:(NSString *)type;
@end
