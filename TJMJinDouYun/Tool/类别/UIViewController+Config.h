//
//  UIViewController+Config.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/28.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Config)
- (void)setTitle:(NSString *)title fontSize:(CGFloat)size colorHexValue:(int)value;

- (void)resetHorizontalConstrains:(NSLayoutConstraint *)constrain, ... NS_REQUIRES_NIL_TERMINATION;
- (void)resetVerticalConstrains:(NSLayoutConstraint *)constrain, ... NS_REQUIRES_NIL_TERMINATION;

@end
