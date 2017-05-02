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


- (void)resetVerticalConstrains:(NSLayoutConstraint *)constrain, ... NS_REQUIRES_NIL_TERMINATION  {
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
- (void)resetHorizontalConstrains:(NSLayoutConstraint *)constrain, ... NS_REQUIRES_NIL_TERMINATION  {
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


@end
