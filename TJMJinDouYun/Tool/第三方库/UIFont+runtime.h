//
//  UIFont+runtime.h
//  字体大小适配-runtime
//
//  Created by 刘龙 on 2017/3/23.
//  Copyright © 2017年 xixhome. All rights reserved.
//

#import <UIKit/UIKit.h>
#define YourUIScreen 375  //自己UI设计原型图的手机尺寸宽度(6)
@interface UIFont (runtime)

+ (void)adjustFont:(CGFloat)fontSize forView:(id)view, ... NS_REQUIRES_NIL_TERMINATION;

@end
