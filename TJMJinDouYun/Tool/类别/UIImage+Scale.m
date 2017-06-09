//
//  UIImage+Scale.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/27.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage (Scale)

- (UIImage *)scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (CGRect)getImageRect:(UIImage *)tempImage {
    CGRect rect;
    if (tempImage.size.width > tempImage.size.height) {
        rect = CGRectMake((tempImage.size.width-tempImage.size.height)/2, 0, tempImage.size.height, tempImage.size.height);
    } else if (tempImage.size.width < tempImage.size.height) {
        rect = CGRectMake(0, (tempImage.size.height-tempImage.size.width)/2, tempImage.size.width, tempImage.size.width);
    } else {
        rect = CGRectMake(0, 0, tempImage.size.width, tempImage.size.width);
    }
    return rect;
}

- (UIImage *)getCropImage {
    CGRect rect = [self getImageRect:self];
    rect = CGRectMake(ceilf(rect.origin.x), ceilf(rect.origin.y), ceilf(rect.size.width), ceilf(rect.size.height));
    UIGraphicsBeginImageContext(rect.size);
    [self drawAtPoint:CGPointMake(-rect.origin.x, -rect.origin.y)];
    UIImage *cropImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return cropImage;
}

@end
