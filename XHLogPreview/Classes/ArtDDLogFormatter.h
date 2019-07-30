//
//  ArtDDLogFormatter.h
//  logPreviewDemo
//
//  Created by 许焕 on 2019/7/29.
//  Copyright © 2019 许焕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
NS_ASSUME_NONNULL_BEGIN

@interface ArtDDLogFormatter : NSObject<DDLogFormatter>
{
    int atomicLoggerCount;
    NSDateFormatter *threadUnsafeDateFormatter;
}
@end

NS_ASSUME_NONNULL_END
