//
//  UIImage+QRCode.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/17.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QRCode)

+ (UIImage *)createNonInterpolatedUImageFormCIImage:(CIImage *)image withSize:(CGFloat)size;

@end
