//
//  NSString+MD5.h
//  NNNetWorking
//
//  Created by shizhi on 2017/6/7.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

/**
 字符串 md5
 
 @return NSString
 */
- (NSString *)nn_md5;

- (id) nn_jsonObject;

- (NSString *)nn_md5Base64String;
@end
