//
//  ArtLogPreManager.m
//  logPreviewDemo
//
//  Created by 许焕 on 2019/7/29.
//  Copyright © 2019 许焕. All rights reserved.
//

#import "ArtLogPreManager.h"
#import "ArtDDLogFormatter.h"
#import "ArtLogListViewController.h"
#import "ArtLogFileManagerDefault.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height

#define kSafeAreaY 64
#define kSafeAreaX 40

static NSString *kLogHidden = @"isLogBtnHidden";
static NSString *logBtn_CenterX = @"logBtn_CenterX";
static NSString *logBtn_CenterY = @"logBtn_CenterY";

@interface  ArtLogPreManager()

@property (nonatomic, copy)NSString *folderPath;
@property (nonatomic, weak)ArtLogListViewController *listVC;
@property (nonatomic, weak)DDFileLogger *fileLogger;
@end

@implementation ArtLogPreManager

+ (instancetype)shareInstance{
    static ArtLogPreManager *instance = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init] ;
    });
    return instance;
}

- (void)setupDDLog{
    //控制台打印
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    //自定义文件名
    ArtLogFileManagerDefault *fileManager = [[ArtLogFileManagerDefault alloc] init];
    //本地文件日志
    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:fileManager];
    //自定义输出格式
    fileLogger.logFormatter = [[ArtDDLogFormatter alloc] init];
    fileLogger.rollingFrequency = 15; // 每15s创建一个新文件
    fileLogger.logFileManager.maximumNumberOfLogFiles = 20; //最多20个文件
    [DDLog addLogger:fileLogger];
    //记录logger
    self.fileLogger = fileLogger;
    //记录路径
    self.folderPath = fileLogger.logFileManager.logsDirectory;
    NSLog(@"%@",self.folderPath);
}

- (void)removeAllLogFiles{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [[NSArray alloc] init];
    fileList = [fileManager contentsOfDirectoryAtPath:self.folderPath error:NULL];
    for (NSString *fileName in fileList) {
        NSString *filePath = [self.folderPath stringByAppendingPathComponent:fileName];
        NSError *error = nil;
        [fileManager removeItemAtPath:filePath error:&error];
        if (error) {
            NSLog(@"删除DDLog日志文件失败:%@",error);
        }
    }
}

- (void)startServer{
    
    [self setupDDLog];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //添加按钮
        [[UIApplication sharedApplication].keyWindow addSubview:self.logBtn];
        
        id centerX = [[NSUserDefaults standardUserDefaults]objectForKey:logBtn_CenterX];
        id centerY = [[NSUserDefaults standardUserDefaults]objectForKey:logBtn_CenterY];
        id isHidden = [[NSUserDefaults standardUserDefaults]objectForKey:kLogHidden];
        
        if (centerX && centerY) {
            CGPoint center = CGPointMake([centerX floatValue], [centerY floatValue]);
            self.logBtn.center = center;
        }
        if (isHidden) {
            self.logBtn.hidden = [isHidden boolValue];
        }else{
            self.logBtn.hidden = NO;
        }
    });
}

- (void)stopServer{
    [DDLog removeAllLoggers];
    [self removeAllLogFiles];
}

- (void)clickBtn:(UIButton *)btn{
    if (!self.isShowLogVC) {
        [self showLogPreVC];
    }else{
        [self dismissLogPreVC];
    }
}

- (void)setIsShowLogVC:(BOOL)isShowLogVC{
    _isShowLogVC = isShowLogVC;
    self.logBtn.selected = _isShowLogVC;
}

- (void)panBtn:(UIPanGestureRecognizer *)ges{
    CGPoint point= [ges locationInView:[UIApplication sharedApplication].keyWindow];
    if (point.y < kSafeAreaY) {
        point.y = kSafeAreaY;
    }
    if (point.y > kScreenHeight - kSafeAreaY) {
        point.y = kScreenHeight - kSafeAreaY;
    }
    if (point.x < kSafeAreaX) {
        point.x = kSafeAreaX;
    }
    if (point.x > kScreenWidth - kSafeAreaX) {
        point.x = kScreenWidth - kSafeAreaX;
    }
    self.logBtn.center = point;
    if (ges.state==UIGestureRecognizerStateEnded) {
        //保存一下平移后的坐标
        [[NSUserDefaults standardUserDefaults]setObject:@(point.x) forKey:logBtn_CenterX];
        [[NSUserDefaults standardUserDefaults]setObject:@(point.y) forKey:logBtn_CenterY];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

- (void)showOrDismisLogButton{
    self.logBtn.hidden = !self.logBtn.hidden;
    [[NSUserDefaults standardUserDefaults]setObject:@(self.logBtn.hidden) forKey:kLogHidden];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)showLogPreVC{
    self.isShowLogVC = YES;
    ArtLogListViewController *vc = [ArtLogListViewController LogListWithFolderPath:self.folderPath];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVC presentViewController:nav animated:YES completion:nil];
    self.listVC = vc;
}

- (void)dismissLogPreVC{
    self.isShowLogVC = NO;
    [self.listVC dismissViewControllerAnimated:YES completion:nil];
}

- (UIButton *)logBtn{
    if (!_logBtn) {
        _logBtn = [UIButton buttonWithType:0];
        [_logBtn setTitle:@"ShowLog" forState:UIControlStateNormal];
        [_logBtn setTitle:@"DismissLog" forState:UIControlStateSelected];
        [_logBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _logBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _logBtn.frame = CGRectMake(300, 40, 100, 50);
        _logBtn.layer.cornerRadius = 25;
        [_logBtn setBackgroundColor:[UIColor blackColor]];
        [_logBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panBtn:)];
        [_logBtn addGestureRecognizer:pan];
    }
    return _logBtn;
}


@end
