//
//  QLPreviewControllerService.m
//  PDFPreViewDemo
//
//  Created by 迪王 on 2018/7/5.
//  Copyright © 2018年 yangdeming. All rights reserved.
//

#import "QLPreviewControllerService.h"
#import <QuickLook/QuickLook.h>

@interface QLPreviewControllerService()<QLPreviewControllerDataSource,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>
{
    NSString *pdfFilePath;
}
@property(nonatomic,strong) NSMutableData *pdfData;
@property(nonatomic,strong) QLPreviewController *QLPVC;
@end

@implementation QLPreviewControllerService

static QLPreviewControllerService *instance = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        QLPreviewController *QLPVC = [[QLPreviewController alloc] init];
        QLPVC.dataSource = self;
        self.QLPVC = QLPVC;
    }
    return self;
}

#pragma mark --- 返回加载文件个数
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}
#pragma mark --- 返回加载路径
- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return  [NSURL fileURLWithPath:pdfFilePath]; 
}


-(void)loadPdfResource:(NSString *)url{
    NSURL *Url =  [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    pdfFilePath = [self getFullPathWithLastPathComponent:Url.lastPathComponent];
    NSFileManager *fileManager = [NSFileManager defaultManager];
   
    if(![fileManager fileExistsAtPath:pdfFilePath])
    {
//          下载pdf数据
//            [SVProgressHUD showWithStatus:@"loading..."];
        self.pdfData=[[NSMutableData alloc]init];
        NSURLSessionConfiguration *config =[NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *task = [session dataTaskWithURL:Url];
        [task resume];
    }else{
        // NSLog(@"文件存在");
        [self pushQLPreviewController];
    }

}
#pragma mark  ---  接收到数据调用

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    //允许继续响应
    completionHandler(NSURLSessionResponseAllow);
    //获取文件的总大小
    // NSInteger totalLength = response.expectedContentLength;
}

#pragma mark  --- 接收到数据调用

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
   didReceiveData:(NSData *)data
{
    
    //将每次接受到的数据拼接起来
    [self.pdfData  appendData:data];
    //计算当前下载的长度
    //  NSInteger nowlength = self.pdfData .length;
    //  CGFloat value = nowlength1.0/self.totalLength;
}

#pragma mark ---下载完成调用


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error{
    NSLog(@"self.pdfData:\n%@",self.pdfData);
//    NSString  *filename =[self getFullPath];
    [self.pdfData writeToFile:pdfFilePath atomically:YES];
    //    [SVProgressHUD dismiss];
    if (self.pdfData) {
        NSLog(@"OK");
        [self showPDFWebView:pdfFilePath];
    }else{
        NSLog(@"Sorry");
    }

    
}
-(void)showPDFWebView:(NSString *)filename{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:pdfFilePath])
    {
        NSLog(@"文件不存在");
    }else{
        NSLog(@"文件存在");
        [self pushQLPreviewController];
    }
    
}

-(void)pushQLPreviewController{
    
    UINavigationController *root = (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    [root pushViewController:self.QLPVC animated:YES];
    
}

- (NSString *)getFullPathWithLastPathComponent:(NSString *)lastPathComponent
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
   
    path = [NSString stringWithFormat:@"%@/%@",path,@"借款协议.pdf"];
    NSLog(@"filePath:%@",path);
    
   return  path;
}
@end
