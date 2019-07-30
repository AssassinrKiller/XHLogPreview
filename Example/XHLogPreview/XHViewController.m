//
//  XHViewController.m
//  XHLogPreview
//
//  Created by ios_service@126.com on 07/30/2019.
//  Copyright (c) 2019 ios_service@126.com. All rights reserved.
//

#import "XHViewController.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface XHViewController ()

@end

@implementation XHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    static const DDLogLevel ddLogLevel = DDLogLevelAll;
    
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        DDLogVerbose(@"详细打印信息");
        DDLogDebug(@"正常debug打印信息");
        DDLogInfo(@"Info");
        DDLogWarn(@"⚠️警告");
        DDLogError(@"Error,错误");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
