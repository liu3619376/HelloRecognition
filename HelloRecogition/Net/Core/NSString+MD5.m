//
//  NSString+MD5.m
//  NNNetWorking
//
//  Created by shizhi on 2017/6/7.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "NSString+MD5.h"
#include <CommonCrypto/CommonDigest.h>


@implementation NSString (MD5)

- (NSString *)nn_md5 {
    NSData *inputData = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char outputData[CC_MD5_DIGEST_LENGTH];
    CC_MD5([inputData bytes], (unsigned int)[inputData length], outputData);

    NSMutableString *hashStr = [NSMutableString string];
    NSInteger i = 0;
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; ++i)
        [hashStr appendFormat:@"%02x", outputData[i]];

    return hashStr;
}

- (id)nn_jsonObject {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    id rslt = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves) error:nil];
    return rslt;
}



@end
