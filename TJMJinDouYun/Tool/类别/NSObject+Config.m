//
//  NSObject+Config.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/3.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "NSObject+Config.h"

@implementation NSObject (Config)


- (void)resetVerticalConstraints:(NSLayoutConstraint *)constrain, ... NS_REQUIRES_NIL_TERMINATION  {
    if (constrain) {
        // 取出第一个参数
        constrain.constant *= TJMHeightRatio;
        // 定义一个指向个数可变的参数列表指针；
        va_list args;
        // 用于存放取出的参数
        id arg;
        // 初始化变量刚定义的va_list变量，这个宏的第二个参数是第一个可变参数的前一个参数，是一个固定的参数
        va_start(args, constrain);
        // 遍历全部参数 va_arg返回可变的参数(a_arg的第二个参数是你要返回的参数的类型)
        while ((arg = va_arg(args, NSLayoutConstraint *))) {
            NSLayoutConstraint *layoutConstraint = arg;
            layoutConstraint.constant *= TJMHeightRatio;
        }
        // 清空参数列表，并置参数指针args无效
        va_end(args);
    }
}
- (void)resetHorizontalConstraints:(NSLayoutConstraint *)constrain, ... NS_REQUIRES_NIL_TERMINATION  {
    if (constrain) {
        // 取出第一个参数
        constrain.constant *= TJMWidthRatio;
        // 定义一个指向个数可变的参数列表指针；
        va_list args;
        // 用于存放取出的参数
        id arg;
        // 初始化变量刚定义的va_list变量，这个宏的第二个参数是第一个可变参数的前一个参数，是一个固定的参数
        va_start(args, constrain);
        // 遍历全部参数 va_arg返回可变的参数(a_arg的第二个参数是你要返回的参数的类型)
        while ((arg = va_arg(args, NSLayoutConstraint *))) {
            NSLayoutConstraint *layoutConstraint = arg;
            layoutConstraint.constant *= TJMWidthRatio;
        }
        // 清空参数列表，并置参数指针args无效
        va_end(args);
    }
}


#pragma  mark - 设置字体
- (void)adjustFont:(CGFloat)fontSize forView:(id)view, ... NS_REQUIRES_NIL_TERMINATION  {
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
            [self setFont:fontSize accordingToClass:arg];
        }
        // 清空参数列表，并置参数指针args无效
        va_end(args);
    }
}

- (void)setFont:(CGFloat)fontSize accordingToClass:(id)unknownClass {
    if([unknownClass isKindOfClass:[UIButton class]]){
        UIButton *button = unknownClass;
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    } else if ([unknownClass isKindOfClass:[UILabel class]]){
        UILabel *label = unknownClass;
        label.font = [UIFont systemFontOfSize:fontSize];
    } else if ([unknownClass isKindOfClass:[UITextField class]]) {
        UITextField *textField = unknownClass;
        textField.font = [UIFont systemFontOfSize:fontSize];
    }else if ([unknownClass isKindOfClass:[UITextView class]]) {
        UITextView *textView = unknownClass;
        textView.font = [UIFont systemFontOfSize:fontSize];
    }
}




@end
