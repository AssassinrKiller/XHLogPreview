//
//  ArtLogPreviewViewController.m
//  logPreviewDemo
//
//  Created by 许焕 on 2019/7/29.
//  Copyright © 2019 许焕. All rights reserved.
//

/**
 日志格式: 日期和时间 文件名 方法名 : 行数 <日志等级> 日志消息
 例子: 2019/07/29 16:57:26 ViewController -[ViewController viewDidLoad]_block_invoke : 24 <Verbose> 详细打印信息
 */

#import "ArtLogPreviewViewController.h"
#import "ArtDDLogReader.h"

#define defalutColor [UIColor greenColor]

@interface ArtLogPreviewViewController ()<
UIDocumentInteractionControllerDelegate,
UITextFieldDelegate>
@property (nonatomic, copy)NSString *filePath;
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, strong)UIDocumentInteractionController *documentController;
@end

@implementation ArtLogPreviewViewController

+ (instancetype)PreviewWithFilePath:(NSString *)filePath{
    ArtLogPreviewViewController *vc = [[ArtLogPreviewViewController alloc] initWithFilePath:filePath];
    return vc;
}

- (instancetype)initWithFilePath:(NSString *)filePath{
    if (self = [super init]) {
        self.filePath = filePath;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.filePath lastPathComponent];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubviews];
    [self refreshData];
}

- (void)refreshData{
    NSString *resut = [ArtDDLogReader readLogFileWithPath:self.filePath];
    if (resut && resut.length) {
        [self.textView setText:resut];
    }
}

- (void)setupSubviews{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction)];
    [self.view addSubview:self.textView];
}

- (void)shareAction{
    self.documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:self.filePath]];
    self.documentController.delegate = self;
    self.documentController.UTI = [self getUTI:self.filePath.pathExtension];
    [self.documentController presentOpenInMenuFromRect:CGRectZero
                                                inView:self.view
                                              animated:YES];
}

- (NSString *)getUTI:(NSString *)pathExtension{
    NSString *typeStr = [self getFileTypeStr:pathExtension];
    
    if ([typeStr isEqualToString:@"PDF"]) {
        return @"com.adobe.pdf";
    }
    if ([typeStr isEqualToString:@"Word"]){
        return @"com.microsoft.word.doc";
    }
    if ([typeStr isEqualToString:@"PowerPoint"]){
        return @"com.microsoft.powerpoint.ppt";
    }
    if ([typeStr isEqualToString:@"Excel"]){
        return @"com.microsoft.excel.xls";
    }
    return @"public.data";
}
#pragma mark - 文件类型
- (NSString *)getFileTypeStr:(NSString *)pathExtension{
    if ([pathExtension isEqualToString:@"pdf"] || [pathExtension isEqualToString:@"PDF"]) {
        return @"PDF";
    }
    if ([pathExtension isEqualToString:@"doc"] || [pathExtension isEqualToString:@"docx"] || [pathExtension isEqualToString:@"DOC"] || [pathExtension isEqualToString:@"DOCX"]) {
        return @"Word";
    }
    if ([pathExtension isEqualToString:@"ppt"] || [pathExtension isEqualToString:@"PPT"]) {
        return @"PowerPoint";
    }
    if ([pathExtension isEqualToString:@"xls"] || [pathExtension isEqualToString:@"XLS"]) {
        return @"Excel";
    }
    return @"public";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [UITextView new];
        _textView.editable = NO;
        _textView.frame = self.view.frame;
    }
    return _textView;
}

@end
