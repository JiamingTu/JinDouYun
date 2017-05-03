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


- (UIBarButtonItem *)setNaviItemWithImageName:(NSString *)imageName tag:(int)tag;


@end
