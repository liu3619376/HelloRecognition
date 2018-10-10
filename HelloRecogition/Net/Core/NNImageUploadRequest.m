//
//  NNImageUploadRequest.m
//  Pods
//
//  Created by lt on 2016/12/13.
//
//

#import <CoreGraphics/CoreGraphics.h>
#import "NNImageUploadRequest.h"
#import "NNNetConfigure.h"


@implementation NNImageUploadRequest
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
    return [[NNNetConfigure share].fileUploadURL stringByAppendingString:@"?type=2"];
}

+ (nullable NSString *)thumbImageWithName:(nullable NSString *)sName {
    if (sName.length <= 0) {
        return nil;
    }
    return [[[NNNetConfigure share].fileViewURL stringByAppendingString:@"gen320"] stringByAppendingString:sName];
}
+ (nullable NSString *)imageWithName:(nullable NSString *)sName {
    return [super fileWithName:sName];
}
+(NSString *)imageByGetThumb_image:(NSString*)image size:(CGSize)imageSize  scaleStyle:(int)scaleStyle interlace:(int)interlace
{
    NSString *url;
    if ([image containsString:@"niannianyun"]) {
        NSString *thumb = [NSString stringWithFormat:@"?imageView2/%d/w/%g/h/%g/interlace/%d/q/100",scaleStyle,imageSize.width,imageSize.height,interlace];
        
        if ([image hasPrefix:@"http"]) {
            url = [image stringByAppendingString:thumb];
        }
        else {
            url = [NSString stringWithFormat:@"%@%@%@",[self retQiniuUrl],image,thumb];
        }
    }
    else {
        
        NSString * imageName = [[image componentsSeparatedByString:@"/"] lastObject];
        NSString *thumb = [NSString stringWithFormat:@"thumb_%@",imageName];
        
        if (![image hasPrefix:@"http"]) {
            url = [NSString stringWithFormat:@"%@%@",baseUrlStr,image];
        }
        else {
            url = image;
        }
        url = [url stringByReplacingOccurrencesOfString:imageName withString:thumb];
    }
    
    return url;
    
}
@end
