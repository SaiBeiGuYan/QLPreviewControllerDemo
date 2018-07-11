//
//  QLPreviewControllerService.h
//  PDFPreViewDemo
//
//  Created by 迪王 on 2018/7/5.
//  Copyright © 2018年 yangdeming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLPreviewControllerService : NSObject

-(void)loadPdfResource:(NSString *)url;

+ (instancetype)sharedInstance;

@end
