//
//  LLImageUploadRequest.m
//  Pods
//
//  Created by lt on 2016/12/13.
//
//

#import <CoreGraphics/CoreGraphics.h>
#import "LLImageUploadRequest.h"
#import "LLNetConfigure.h"


@implementation LLImageUploadRequest
- (nonnull instancetype)initWithImagePaths:(nonnull NSArray<NSString *> *)imagePaths
                                   fileKey:(nullable NSString *)key {
    self = [super initWithFilePaths:imagePaths fileKey:key];
    
    for (CSFileObject *file in self.files) {
        if (file.fileName.length <= 0) {
            [file setValue:@"random.jpg" forKey:@"fileName"];
        }
    }
    
    return self;
}
- (nonnull instancetype)initWithImages:(nonnull NSArray<CSFileObject *> *)images
                               fileKey:(nullable NSString *)key {
    return [super initWithFiles:images fileKey:key];
}

- (NSString *)requestURLString {
    return [[LLNetConfigure share].fileUploadURL stringByAppendingString:@"?type=2"];
}

+ (nullable NSString *)thumbImageWithName:(nullable NSString *)sName {
    if (sName.length <= 0) {
        return nil;
    }
    return [[[LLNetConfigure share].fileViewURL stringByAppendingString:@"gen320"] stringByAppendingString:sName];
}
+ (nullable NSString *)imageWithName:(nullable NSString *)sName {
    return [super fileWithName:sName];
}

@end
