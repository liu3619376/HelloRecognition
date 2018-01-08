//
//  SecurityUtil.h
//  Smile
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 Weconex. All rights reserved.
//

#import "SecurityUtil.h"
#import <QN_GTM_Base64.h>
#import "NSData+AES.h"

#define Iv          @"0851649102654985" //偏移量,可自行修改
#define KEY         @"1aacZgxFh9OQpbeL" //key，可自行修改

@implementation SecurityUtil

/*
 使用方法
 NSString *str = @"[{\"request_no\":\"1001\",\"service_code\":\"FS0001\",\"contract_id\":\"100002\",\"order_id\":\"0\",\"phone_id\":\"13913996922\",\"plat_offer_id\":\"100094\",\"channel_id\":\"1\",\"activity_id\":\"100045\"}]";
 
 加密
 NSString *encryptDate=[SecurityUtil encryptAESData:str];
 NSLog(@"base64EncryptDate %@",encryptDate);
 
 解密
 NSString *strDecrypt=@"5z9WEequVr7qtd+WoxV+Kw==";
 NSString *strDecrypt = encryptDate;
 NSString *decodeData=[SecurityUtil decryptAESData:strDecrypt];
 NSLog(@"decodeData %@",decodeData);
 
 */
#pragma mark - base64
+ (NSString*)encodeBase64String:(NSString * )input { 
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; 
    data = [QN_GTM_Base64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return base64String;
    
}

+ (NSString*)decodeBase64String:(NSString * )input { 
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; 
    data = [QN_GTM_Base64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return base64String;
} 

+ (NSString*)encodeBase64Data:(NSData *)data {
	data = [QN_GTM_Base64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return base64String;
}

+ (NSString*)webEncodeBase64Data:(NSData *)data {
    data = [QN_GTM_Base64 webSafeEncodeData:data padded:YES];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)webDecodeBase64Data:(NSData *)data {
    data = [QN_GTM_Base64 webSafeDecodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)webEncodeBase64String:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [QN_GTM_Base64 webSafeEncodeData:data padded:YES];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([base64String containsString:@"="]) {
        base64String = [base64String stringByReplacingOccurrencesOfString:@"=" withString:@"@"];
    }
    return base64String;
}

+ (NSString*)webDecodeBase64String:(NSString *)string {
    NSString *inputString = string;
    if ([inputString containsString:@"@"]) {
        inputString = [inputString stringByReplacingOccurrencesOfString:@"@" withString:@"="];
    }
    NSData *data = [inputString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [QN_GTM_Base64 webSafeDecodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)decodeBase64Data:(NSData *)data {
	data = [QN_GTM_Base64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return base64String;
}

#pragma mark - AES加密
//将string转成带密码的data
+ (NSString*)encryptAESData:(NSString*)string
{
    //将nsstring转化为nsdata
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //使用密码对nsdata进行加密
    NSData *encryptedData = [data AES128EncryptWithKey:KEY gIv:Iv];
    //返回进行base64进行转码的加密字符串
    return [self webEncodeBase64Data:encryptedData];
//    return [self encodeBase64Data:encryptedData];
    
//    return [self byteToString:encryptedData];//data转16进制string
}

+(NSString*)encryptAESDataOne:(NSString*)string
{
    //将nsstring转化为nsdata
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //使用密码对nsdata进行加密
    NSData *encryptedData = [data AES128EncryptWithKey:@"" gIv:@"1"];
    //返回进行base64进行转码的加密字符串
    
    return [[NSString alloc] initWithData:encryptedData encoding:NSUTF8StringEncoding];
}

//将string转成带密码的data
+ (NSString*)encryptWeb64AESData:(NSString *)string
{
    //将nsstring转化为nsdata
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //使用密码对nsdata进行加密
    NSData *encryptedData = [data AES128EncryptWithKey:KEY gIv:Iv];
    //返回进行base64进行转码的加密字符串
    NSString *encryptString = [self webEncodeBase64Data:encryptedData];
    if ([encryptString containsString:@"="]) {
        encryptString = [encryptString stringByReplacingOccurrencesOfString:@"=" withString:@"@"];
    }
    return encryptString;
}

+(NSString*)encryptWeb64AESDataOne:(NSString *)string
{
    //将nsstring转化为nsdata
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //使用密码对nsdata进行加密
    NSData *encryptedData = [data AES128EncryptWithKey:@"" gIv:@"1"];
    //返回进行base64进行转码的加密字符串
    NSString *encryptString = [self webEncodeBase64Data:encryptedData];
    if ([encryptString containsString:@"="]) {
        encryptString = [encryptString stringByReplacingOccurrencesOfString:@"=" withString:@"@"];
    }
    return encryptString;
}

+(NSString*)byteToString:(NSData*)data
{
    Byte *plainTextByte = (Byte *)[data bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",plainTextByte[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return [hexStr uppercaseString];
}

+(NSData*)stringToByte:(NSString*)string
{
    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2!=0) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}

#pragma mark - AES解密
//将带密码的data转成string
+(NSString*)decryptAESData:(NSString *)string
{
    NSData *hexData = [self stringToByte:string];//字符串转16进行data
    
    //使用密码对data进行解密
    NSData *decryData = [hexData AES128DecryptWithKey:KEY gIv:Iv];
    
    //将解了密码的nsdata转化为nsstring
    NSString *str = [[NSString alloc] initWithData:decryData encoding:NSUTF8StringEncoding];
    return str;
}

//将带密码的data转成string
+(NSString*)decryptWeb64AESData:(NSString *)string{
    //base64解密
    NSData *decodeBase64Data=[QN_GTM_Base64 webSafeDecodeString:string];
    //使用密码对data进行解密
    NSData *decryData = [decodeBase64Data AES128DecryptWithKey:KEY gIv:Iv];
    
    //将解了密码的nsdata转化为nsstring
    NSString *str = [[NSString alloc] initWithData:decryData encoding:NSUTF8StringEncoding];
    return str;
}

@end
