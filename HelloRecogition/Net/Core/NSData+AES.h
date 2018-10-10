//
//  NSData+AES.h
//  NNNetWorking
//
//  Created by shizhi on 2017/6/7.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSString;

@interface NSData (Encryption)

- (NSData *)nn_AES128EncryptWithKey:(NSString *)key gIv:(NSString *)Iv;   //加密
- (NSData *)nn_AES128DecryptWithKey:(NSString *)key gIv:(NSString *)Iv;   //解密


/**
 特殊字符 `+/`

 @return base64 字符串
 */
- (NSString *)nn_safeBase64String;

/**
 特殊字符 `-_`

 @return base64 字符串
 */
- (NSString *)nn_base64String;

- (NSString *)nn_decodeSafeBase64String;

@end
