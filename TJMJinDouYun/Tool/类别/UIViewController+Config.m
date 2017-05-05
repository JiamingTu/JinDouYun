//
//  UIViewController+Config.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/28.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "UIViewController+Config.h"

@implementation UIViewController (Config)



- (void)setTitle:(NSString *)title fontSize:(CGFloat)size colorHexValue:(int)value {
    self.title = title;
    UIFont *font = [UIFont systemFontOfSize:size];
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSForegroundColorAttributeName:TJMFUIColorFromRGB(value)};
    self.navigationController.navigationBar.titleTextAttributes = dic;
}




#pragma  mark - 设置导航左右按钮
- (UIBarButtonItem *)setNaviItemWithImageName:(NSString *)imageName tag:(int)tag {
    UIImage *itemImage = [UIImage imageNamed:imageName];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:itemImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    button.frame = CGRectMake(0, 0, itemImage.size.width, itemImage.size.height);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    return item;
}


#pragma  mark - 设置导航颜色
- (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}


@end
