//
//  LLUploadRequest.h
//  Pods
//
//  Created by lt on 2016/12/8.
//
//

#import "LLRequest.h"


/**
 文件对象
 */
@interface CSFileObject : NSObject

/**
 文件数据，一定不能为空
 */
@property (nonnull, nonatomic, strong, readonly) NSData *fileData;

/**
 文件路径
 */
@property (nullable, nonatomic, copy, readonly) NSString *filePath;

/**
 文件类型 eg: image/jpeg  image/gif
 /// See: [参考连接](http://www.w3school.com.cn/media/media_mimeref.asp)
 */
@property (nonnull, nonatomic, copy, readonly) NSString *mineType;

/**
 文件名称 eg: xxx.jpg  xxx.txt
 */
@property (nonnull, nonatomic, copy, readonly) NSString *fileName;

/**
 文件扩展名  eg: jpg  txt
 */
@property (nullable,nonatomic, copy, readonly) NSString *fileExt;

/**
 初始化 文件对象
 data 和 url 必须有一个不为空，若 data 为空时，url 指定的文件不能为空

 @param aData 文件数据
 @param path 文件路径
 @param aType 文件类型
 @param sName 文件名
 @param aExt 文件扩展
 @return CSFileObject
 */
- (nonnull instancetype)initWithData:(nullable NSData *)aData url:(nullable NSString *)path
                                  type:(nullable NSString *)aType name:(nullable NSString *)sName ext:(nullable NSString *)aExt;

@end


/**
 文件上传请求类
 */
@interface LLUploadRequest : LLRequest

/**
 服务器端接受文件的 key 值
 */
@property (nonnull, nonatomic, copy,readonly)NSString *fileKey;

/**
 文件对象 数组
 */
@property (nonnull, nonatomic, strong, readonly) NSArray<CSFileObject *> *files;
/**
 上传本地文件
 
 @param filePaths 文件路径 数组
 @param key 服务器端接受文件的 key 值
 @return LLUploadRequest 对象
 */
- (nonnull instancetype)initWithFilePaths:(nonnull NSArray<NSString *> *)filePaths fileKey:(nullable NSString *)key;
/**
 上传图片文件
 
 @param files 文件对象 数组
 @param key 服务器端接受文件的 key 值
 @return LLUploadRequest 对象
 */
- (nonnull instancetype)initWithFiles:(nonnull NSArray<CSFileObject *> *)files fileKey:(nullable NSString *)key;

+ (nullable NSString *)fileWithName:(nullable NSString *)sName;

@end
