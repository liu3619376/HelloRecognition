//
//  LLImageUploadRequest.h
//  Pods
//
//  Created by lt on 2016/12/13.
//
//

#import "LLUploadRequest.h"
@class CSFileObject;

 ///图片上传实体类
@interface LLImageUploadRequest : LLUploadRequest

/**
 上传本地图片

 @param imagePaths 文件路径 数组
 @param key 服务器端接受文件的 key 值
 @return LLImageUploadRequest 对象
 */
- (nonnull instancetype)initWithImagePaths:(nonnull NSArray<NSString *> *)imagePaths fileKey:(nullable NSString *)key;


/**
 上传图片文件

 @param images 图片文件对象 数组
 @param key 服务器端接受文件的 key 值
 @return LLImageUploadRequest 对象
 */
- (nonnull instancetype)initWithImages:(nonnull NSArray<CSFileObject *> *)images fileKey:(nullable NSString *)key;


/**
 根据图片名称获取小图的服务器地址 320x(*)

 @param sName 图片名
 @return 小图片图片对应于服务器的全地址
 */
+ (nullable NSString *)thumbImageWithName:(nullable NSString *)sName;

/**
 根据图片名称获取原图的服务器地址

 @param sName 图片名
 @return 原始图片对应于服务器的全地址
 */
+ (nullable NSString *)imageWithName:(nullable NSString *)sName;
@end
