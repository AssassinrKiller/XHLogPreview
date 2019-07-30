//
//  ArtDDLogReader.m
//  logPreviewDemo
//
//  Created by 许焕 on 2019/7/29.
//  Copyright © 2019 许焕. All rights reserved.
//

#import "ArtDDLogReader.h"

@implementation ArtDDLogReader

+ (NSMutableArray *)readFolderWithPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:path error:&error];
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    //在上面那段程序中获得的fileList中列出文件夹名
    for (NSString *file in fileList) {
        //文件名为bundleid+空格+日期.log
        NSString *filePath = [path stringByAppendingPathComponent:file];
        if ([fileManager fileExistsAtPath:filePath] && [file hasSuffix:@".log"]) {
            [resultList addObject:file];
        }
    }
    return resultList;
}

+ (NSString *)readLogFileWithPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExit = [fileManager fileExistsAtPath:path];
    if (isExit) {
        NSData * logData = [NSData dataWithContentsOfFile:path];
        NSString * logText = [[NSString alloc] initWithData:logData encoding:NSUTF8StringEncoding];
        return logText;
    }
    return nil;
}

@end
