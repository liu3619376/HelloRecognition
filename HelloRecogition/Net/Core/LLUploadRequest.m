//
//  LLUploadRequest.m
//  Pods
//
//  Created by lt on 2016/12/8.
//
//

#import "LLUploadRequest.h"
#import "LLNetConfigure.h"

@implementation CSFileObject

- (nonnull instancetype)initWithData:(nullable NSData *)aData
                                 url:(nullable NSString *)path
                                type:(nullable NSString *)aType
                                name:(nullable NSString *)sName
                                 ext:(nullable NSString *)aExt {
    self = [super init];
    
    NSAssert(aData.length > 0 || path.length > 0, @"data and url 不能同时为空");
    
    _fileData = aData;
    _filePath = path;
    _mineType = aType ? :@"multipart/form-data";
    _fileName = sName;
    _fileExt = aExt;
    
    if (aData.length <= 0) {
        _fileData = [NSData dataWithContentsOfFile:path];
        NSAssert(_fileData.length > 0, @"文件不存在");
    }
    
    if (_fileName.length <= 0) {
        _fileName = [self getFileNameWithPath:path] ? :@"";
    }
    
    if (_fileName.length <= 0 && _fileExt.length > 0) {
        _fileName = [NSString stringWithFormat:@"random.%@",_fileExt];
    }
    
    if (_fileExt.length <= 0) {
        _fileExt = [self getExtWithName:_fileName];
    }
    
    return self;
}

- (NSString *)getFileNameWithPath:(NSString *)sPath {
    return [[sPath componentsSeparatedByString:@"/"] lastObject];
}

- (NSString *)getExtWithName:(NSString *)fileName {
    return [[fileName componentsSeparatedByString:@"."] lastObject];
}

@end

@interface LLUploadRequest ()

@end

@implementation LLUploadRequest

- (nonnull instancetype)initWithFilePaths:(nonnull NSArray<NSString *> *)filePaths
                                  fileKey:(nullable NSString *)key {
    self = [super init];
    
    NSMutableArray<CSFileObject *> *temp = [NSMutableArray array];
    for (NSString *path in filePaths) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (data.length <= 0) {
            NSLog(@"file not exist at %@", path);
            continue;
        }
        [temp addObject:[[CSFileObject alloc] initWithData:data url:path type:nil name:nil ext:nil]];
    }
    _fileKey = key;
    _files = temp.copy;
    if (_fileKey.length <= 0) {
        _fileKey = @"uploadFile";
    }
    return self;
}

- (nonnull instancetype)initWithFiles:(nonnull NSArray<CSFileObject *> *)files
                              fileKey:(nullable NSString *)key {
    self = [super init];
    _fileKey = key;
    _files = files;
    
    if (_fileKey.length <= 0) {
        _fileKey = @"uploadFile";
    }
    
    return self;
}

- (NSString *)requestService {
    return @"";
}

- (NSString *)requestURLString {
    return [[LLNetConfigure share].fileUploadURL stringByAppendingString:@"?type=1"];
}

+ (nullable NSString *)fileWithName:(nullable NSString *)sName {
    if (sName.length <= 0) {
        return nil;
    }
    return [[LLNetConfigure share].fileViewURL stringByAppendingString:sName];
}
@end
