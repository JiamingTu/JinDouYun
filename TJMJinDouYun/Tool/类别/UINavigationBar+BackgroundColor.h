//
//  UINavigationBar+BackgroundColor.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/2.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (BackgroundColor)

@property (nonatomic,strong) UIView *overlay;
- (void)tjm_setBackgroundColor:(UIColor *)backgroundColor;
- (void)tjm_hideShadowImageOrNot:(BOOL)bHidden;


@end
