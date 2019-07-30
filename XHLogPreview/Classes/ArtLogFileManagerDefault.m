//
//  ArtLogFileManagerDefault.m
//  logPreviewDemo
//
//  Created by 许焕 on 2019/7/29.
//  Copyright © 2019 许焕. All rights reserved.
//

#import "ArtLogFileManagerDefault.h"

@implementation ArtLogFileManagerDefault

/**
 - (instancetype)initWithLogsDirectory:(NSString *)logsDirectory
 重写这个初始化方法可以指定日志的存储目录
 */

- (NSString *)newLogFileName{
    NSString *preName = @"DDLog-";
    NSString *timeStamp = [self getTimestamp];
    return [NSString stringWithFormat:@"%@%@.log",preName,timeStamp];
}

- (BOOL)isLogFile:(NSString *)fileName{
    return NO;
}

- (NSString *)getTimestamp{
    static dispatch_once_t onceToken;
    static NSDateFormatter *dateFormatter;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"YYYY.MM.dd-HH:mm:ss"];
    });
    return [dateFormatter stringFromDate:NSDate.date];
}



@end
