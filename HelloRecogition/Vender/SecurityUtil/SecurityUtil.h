//
//  SecurityUtil.h
//  Smile
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 Weconex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityUtil : NSObject 

#pragma mark - base64
+ (NSString*)encodeBase64String:(NSString *)input;
+ (NSString*)decodeBase64String:(NSString *)input;

+ (NSString*)encodeBase64Data:(NSData *)data;
+ (NSString*)decodeBase64Data:(NSData *)data;

+ (NSString*)webEncodeBase64Data:(NSData *)data;
+ (NSString*)webDecodeBase64Data:(NSData *)data;

+ (NSString*)webEncodeBase64String:(NSString *)string;
+ (NSString*)webDecodeBase64String:(NSString *)string;
#pragma mark - AES加密
//将string转成带密码的data
+ (NSString*)encryptAESData:(NSString*)string;

+(NSString*)encryptAESDataOne:(NSString*)string;
//将带密码的data转成string
+ (NSString*)decryptAESData:(NSString*)string;

//将string转成带密码的data
+ (NSString*)encryptWeb64AESData:(NSString*)string;

+(NSString*)encryptWeb64AESDataOne:(NSString*)string;
//将带密码的data转成string
+ (NSString*)decryptWeb64AESData:(NSString*)string;

@end
