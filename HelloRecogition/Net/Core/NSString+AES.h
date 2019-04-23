//
//  NSString+AES.h
//  NNNetWorking
//
//  Created by shizhi on 2017/6/7.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AES)

/**
 字符串 aes + base64 加密

 @return 加密数据
 */
- (NSString *)nn_encryptAESAndBase64Data;


/**
 字符串 aes + base64 解密

 @return 解密数据
 */
- (NSString *)nn_decryAESAndBase64Data;

@end
