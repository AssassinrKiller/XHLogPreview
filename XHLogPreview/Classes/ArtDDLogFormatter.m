//
//  ArtDDLogFormatter.m
//  logPreviewDemo
//
//  Created by 许焕 on 2019/7/29.
//  Copyright © 2019 许焕. All rights reserved.
//

#import "ArtDDLogFormatter.h"
#import <libkern/OSAtomic.h>

static NSString *const kDateFormatString = @"yyyy/MM/dd HH:mm:ss";

@implementation ArtDDLogFormatter

- (NSString *)stringFromDate:(NSDate *)date {
    int32_t loggerCount = OSAtomicAdd32(0, &atomicLoggerCount);
    if (loggerCount <= 1) {
        //单线程
        if (threadUnsafeDateFormatter == nil) {
            threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
            [threadUnsafeDateFormatter setDateFormat:kDateFormatString];
        }
        return [threadUnsafeDateFormatter stringFromDate:date];
    } else {
        //多线程
        NSString *key = @"MyCustomFormatter_NSDateFormatter";
        
        NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
        NSDateFormatter *dateFormatter = [threadDictionary objectForKey:key];
        
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:kDateFormatString];
            [threadDictionary setObject:dateFormatter forKey:key];
        }
        return [dateFormatter stringFromDate:date];
    }
}

#pragma mark - DDLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel; //日志等级
    switch (logMessage->_flag) {
        case DDLogFlagError    : logLevel = @"Error";   break;
        case DDLogFlagWarning  : logLevel = @"Warning"; break;
        case DDLogFlagInfo     : logLevel = @"Info";    break;
        case DDLogFlagDebug    : logLevel = @"Debug";   break;
        default                : logLevel = @"Verbose"; break;
    }
    //日期和时间
    NSString *dateAndTime = [self stringFromDate:(logMessage.timestamp)];
    NSString *logFileName = logMessage -> _fileName; // 文件名
    NSString *logFunction = logMessage -> _function; // 方法名
    NSUInteger logLine = logMessage -> _line;        // 行号
    NSString *logMsg = logMessage->_message;         // 日志消息
    
    // 日志格式：日期和时间 文件名 方法名 : 行数 <日志等级> 日志消息
    return [NSString stringWithFormat:@"%@ %@ %@ : %lu <%@> %@", dateAndTime, logFileName, logFunction, logLine, logLevel, logMsg];
}

- (void)didAddToLogger:(id <DDLogger>)logger {
    OSAtomicIncrement32(&atomicLoggerCount);
}

- (void)willRemoveFromLogger:(id <DDLogger>)logger {
    OSAtomicDecrement32(&atomicLoggerCount);
}
@end
