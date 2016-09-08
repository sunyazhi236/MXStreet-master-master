//
//  CacheService.m
//  mxj
//
//  Created by 齐乐乐 on 16/1/8.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "CacheService.h"
#define CACHE_DOC_NAME @"cache" //缓存数据保存目录名称

@implementation CacheService

//获取单例方法
+(instancetype)shareInstance
{
    static CacheService *shareInstance = nil;
    
    @synchronized(self) {
        if (!shareInstance) {
            shareInstance = [[self alloc] init];
        }
        return shareInstance;
    }
}

//读取缓存数据
+(NSObject *)readCacheData:(NSString *)viewCtrlName flag:(int)flag
{
    //获取沙盒路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = paths[0];
    NSString *cachePath = [documentPath stringByAppendingPathComponent:CACHE_DOC_NAME];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    BOOL isDirectoryOrFile = YES;
    //判断某一画面的缓存文件夹是否存在
    NSString *dataFilePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%d/%@%d.plist", viewCtrlName, flag, viewCtrlName, flag]];
    if ([fileManager fileExistsAtPath:dataFilePath isDirectory:&isDirectoryOrFile]) {
        NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:dataFilePath];
        if (array) {
            return array;
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:dataFilePath];
        return dict;
    }
    
    return nil;
}

//保存数据结构及图片
+(void)saveDataToSandBox:(NSString *)viewCtrlName data:(NSObject *)data flag:(int)flag imageFlag:(int)imageFlag
{
    //获取沙盒路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = paths[0];
    NSString *cachePath = [documentPath stringByAppendingPathComponent:CACHE_DOC_NAME];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    BOOL isDirectoryOrFile = YES;
    if (![fileManager fileExistsAtPath:cachePath isDirectory:&isDirectoryOrFile]) {
        //创建目录
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //判断某一画面的缓存目录是否存在
    NSString *dataFileDirectory = [cachePath stringByAppendingPathComponent:viewCtrlName];
    if ([fileManager fileExistsAtPath:dataFileDirectory isDirectory:&isDirectoryOrFile]) {
    } else {
        //创建目录
        [fileManager createDirectoryAtPath:dataFileDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //根据flag标记创建缓存文件夹（flag范围 0 - ..., 每个页面的目录下至少包含一个名称为0的子文件夹)
    NSString *cacheSubDirectory = [dataFileDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", flag]];
    if ([fileManager fileExistsAtPath:cacheSubDirectory isDirectory:&isDirectoryOrFile]) {
    } else {
        //创建子文件夹
        [fileManager createDirectoryAtPath:cacheSubDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //创建缓存文件（文字类数据）
    NSString *dataFilePath = [cacheSubDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d%@", viewCtrlName, flag, @".plist"]];
    
    //将数据转换为字典
    if ([data isKindOfClass:[NSMutableDictionary class]]) {
        NSMutableDictionary *dict = (NSMutableDictionary *)data;
        [dict writeToFile:dataFilePath atomically:YES];
    } else if ([data isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray *dataArray = (NSMutableArray *)data;
        //将数据写入文件
        [dataArray writeToFile:dataFilePath atomically:YES];
    } else if ([data isKindOfClass:[NSURL class]]) {
        NSURL *url = (NSURL *)data;
        //将图片下载至沙盒
        [[CacheService shareInstance] saveImageToSandBox:cacheSubDirectory data:url fileName:[NSString stringWithFormat:@"photo%d", imageFlag]];
    }
}

//清空缓存
+(void)removeCacheData
{
    //删除缓存目录(自定义的目录）
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = paths[0];
    NSString *cachePath = [documentPath stringByAppendingPathComponent:CACHE_DOC_NAME];
    NSFileManager *fileManger = [[NSFileManager alloc] init];
    BOOL isDirectoryOrFile = YES;
    if ([fileManger fileExistsAtPath:cachePath isDirectory:&isDirectoryOrFile]) {
        //删除目录
        [fileManger removeItemAtPath:cachePath error:nil];
    }
    
    //删除EGO缓存文件
    NSString* cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString* oldCachesDirectory = [[[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"fsCachedData"] copy];
    if([[NSFileManager defaultManager] fileExistsAtPath:oldCachesDirectory]) {
        [[NSFileManager defaultManager] removeItemAtPath:oldCachesDirectory error:NULL];
    }
    
    oldCachesDirectory = [[[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"EGOCache"] copy];
    if([[NSFileManager defaultManager] fileExistsAtPath:oldCachesDirectory]) {
        [[NSFileManager defaultManager] removeItemAtPath:oldCachesDirectory error:NULL];
    }
    
    NSString *newPath = [[[cachesDirectory stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] stringByAppendingPathComponent:@"fsCachedData"] copy];
    if ([[NSFileManager defaultManager] fileExistsAtPath:newPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:newPath error:NULL];
    }

    newPath = [[[cachesDirectory stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] stringByAppendingPathComponent:@"EGOCache"] copy];
    if ([[NSFileManager defaultManager] fileExistsAtPath:newPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:newPath error:NULL];
    }
}

//将数据转换为字典 TODO
-(NSMutableDictionary *)dataToDictionary:(NSString *)viewCtrlName data:(NSObject *)data
{
    if ([viewCtrlName isEqualToString:@"MainPageTabBarController"]) {         //首页
        //TODO
    } else if ([viewCtrlName isEqualToString:@"PersonDocViewController"]) {   //我的-个人资料
        //TODO
    } else if ([viewCtrlName isEqualToString:@"StreetPhotoViewController"]) { //街拍画面
        //TODO
    }
    return nil;
}

//将字典转换为数据 TODO
-(NSObject *)dictionaryToData:(NSString *)viewCtrlName dict:(NSMutableDictionary *)dict
{
    //TODO
    return nil;
}

//将图片下载至沙盒
-(void)saveImageToSandBox:(NSString *)filePath data:(NSURL *)url fileName:(NSString *)fileName
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSMutableData *imageData = [[NSMutableData alloc] init];
    __block float imageLenth = 0; //图片长度
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            DLog(@"erro:%@", connectionError.localizedDescription);
        } else {
            //清空图片数据
            [imageData setLength:0];
            NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
            imageLenth = [[resp.allHeaderFields objectForKey:@"Content-Length"] floatValue];
            //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [imageData appendData:data];
            UIImage *image = [UIImage imageWithData:imageData];
            //保存至沙盒
            BOOL result = [UIImageJPEGRepresentation(image, 1) writeToFile:[NSString stringWithFormat:@"%@/%@.jpg", filePath, fileName] atomically:YES];
            if (!result) {
                DLog(@"缓存图片失败");
            }
            //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}

@end