//
//  UIFont+runtime.m
//  字体大小适配-runtime
//
//  Created by 刘龙 on 2017/3/23.
//  Copyright © 2017年 xixhome. All rights reserved.
//

#import "UIFont+runtime.h"
#import <objc/runtime.h>
@implementation UIFont (runtime)
+(void)load{
    //获取替换后的类方法
    Method newMethod = class_getClassMethod([self class], @selector(adjustFont:));
    //获取替换前的类方法
    Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
    //然后交换类方法
    method_exchangeImplementations(newMethod, method);
}


+ (UIFont *)adjustFont:(CGFloat)fontSize {
    UIFont *newFont=nil;
    newFont = [UIFont adjustFont:fontSize * [UIScreen mainScreen].bounds.size.width/YourUIScreen];
    return newFont;
}



@end
