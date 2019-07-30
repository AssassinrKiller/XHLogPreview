//
//  ArtLogPreManager.h
//  logPreviewDemo
//
//  Created by 许焕 on 2019/7/29.
//  Copyright © 2019 许焕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArtLogPreManager : NSObject

@property (nonatomic, assign)BOOL isShowLogVC;

@property (nonatomic, strong)UIButton *logBtn;

+ (instancetype)shareInstance;
/**开始服务*/
- (void)startServer;
/**删除log文件,删除后服务继续*/
- (void)removeAllLogFiles;
/**删除记录并停止服务*/
- (void)stopServer;
/**显示/隐藏*/
- (void)showOrDismisLogButton;

@end

NS_ASSUME_NONNULL_END
