//
//  ArtDDLogReader.h
//  logPreviewDemo
//
//  Created by 许焕 on 2019/7/29.
//  Copyright © 2019 许焕. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArtDDLogReader : NSObject

+ (NSMutableArray *)readFolderWithPath:(NSString *)path;

+ (NSString *)readLogFileWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
