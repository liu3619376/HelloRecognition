//
//  NSString+AES.m
//  NNNetWorking
//
//  Created by shizhi on 2017/6/7.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "NSString+AES.h"
#import <CommonCrypto/CommonCrypto.h>
#import "NSData+AES.h"
#import <QN_GTM_Base64.h>
#import "SecurityUtil.h"
#define Iv @"0851649102654985"  //偏移量,可自行修改
#define KEY @"1aacZgxFh9OQpbeL" // key，可自行修改

@implementation NSString (AES)

- (NSString *)nn_encryptAESAndBase64Data {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [data nn_AES128EncryptWithKey:KEY gIv:Iv];

    NSString *encryptString = [encryptedData nn_safeBase64String];
    if ([encryptString containsString:@"="]) {
        encryptString = [encryptString stringByReplacingOccurrencesOfString:@"=" withString:@"@"];
    }
    return encryptString;
}

- (NSString *)nn_decryAESAndBase64Data {
    NSString *temp = [self stringByURLDecode];
//    temp = [temp stringByReplacingOccurrencesOfString:@"%40" withString:@"="];
    NSData *decodeData = [QN_GTM_Base64 webSafeDecodeString:temp];
    NSData *decryData = [decodeData nn_AES128DecryptWithKey:KEY gIv:Iv];
    NSString *str = [[NSString alloc] initWithData:decryData encoding:NSUTF8StringEncoding];
    return str;
}

@end
