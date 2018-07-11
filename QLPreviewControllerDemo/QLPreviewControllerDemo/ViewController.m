//
//  ViewController.m
//  QLPreviewControllerDemo
//
//  Created by 迪王 on 2018/7/11.
//  Copyright © 2018年 Jason. All rights reserved.
//

#import "ViewController.h"
#import "QLPreviewControllerService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    button.frame = CGRectMake(0, 220, self.view.bounds.size.width, 44);
   
    [button setBackgroundColor:[UIColor orangeColor]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"查看文件" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)buttonClick:(UIButton *)button {
    
    [[QLPreviewControllerService sharedInstance] loadPdfResource:@""];
}

@end
