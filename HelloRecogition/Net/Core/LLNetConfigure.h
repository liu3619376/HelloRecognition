//
//  LLNetConfigure.h
//  LLNetWorking
//
//  Created by shizhi on 2017/6/7.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 参数配置
@interface LLNetConfigure : NSObject

/**
 公共参数
 */
@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *generalParameters;

/**
 公共请求头
 */
@property (nonatomic, strong, nullable) NSDictionary<NSString *, NSString *> *generalHeaders;

/**
 服务器地址 默认：
 */
@property (nonatomic, copy, readwrite, nonnull) NSString *generalServer;

/**
 文件上传地址 默认：
 */
@property (nonatomic, copy, readwrite, nonnull) NSString *fileUploadURL;

/**
 图片上传地址 默认：
 */
@property (nonatomic, copy, readwrite, nonnull) NSString *imageUploadURL;


/**
 文件查看地址 默认：
 */
@property (nonatomic, copy, readwrite, nonnull) NSString *fileViewURL;

/**
 是否为调试模式（默认 false, 当为 true 时，会输出 网络请求日志）
 */
@property (nonatomic, readwrite) BOOL enableDebug;

+ (_Nonnull instancetype)share;

+ (void)addGeneralParameter:(NSString *)sKey value:(id)sValue;
+ (void)removeGeneralParameter:(NSString *)sKey;

@end
NS_ASSUME_NONNULL_END
