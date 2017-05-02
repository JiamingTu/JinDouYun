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


+(UIFont *)adjustFont:(CGFloat)fontSize{
    UIFont *newFont=nil;
    newFont = [UIFont adjustFont:fontSize * [UIScreen mainScreen].bounds.size.width/YourUIScreen];
    return newFont;
}

+ (void)adjustFont:(CGFloat)fontSize forView:(id)view, ... NS_REQUIRES_NIL_TERMINATION  {
    if (view) {
        // 取出第一个参数
        [self setFont:fontSize accordingToClass:view];
        // 定义一个指向个数可变的参数列表指针；
        va_list args;
        // 用于存放取出的参数
        id arg;
        // 初始化变量刚定义的va_list变量，这个宏的第二个参数是第一个可变参数的前一个参数，是一个固定的参数
        va_start(args, view);
        // 遍历全部参数 va_arg返回可变的参数(a_arg的第二个参数是你要返回的参数的类型)
        while ((arg = va_arg(args, id))) {
            NSLog(@"%@", arg);
            [self setFont:fontSize accordingToClass:arg];
            
        }
        // 清空参数列表，并置参数指针args无效
        va_end(args);
    }
}

+ (void)setFont:(CGFloat)fontSize accordingToClass:(id)unknownClass {
    if([unknownClass isKindOfClass:[UIButton class]]){
        UIButton *button = unknownClass;
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    } else if ([unknownClass isKindOfClass:[UILabel class]]){
        UILabel *label = unknownClass;
        label.font = [UIFont systemFontOfSize:fontSize];
    } else if ([unknownClass isKindOfClass:[UITextField class]]) {
        UITextField *textField = unknownClass;
        textField.font = [UIFont systemFontOfSize:fontSize];
    }
}

@end
