//
//  UINavigationBar+BackgroundColor.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/2.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "UINavigationBar+BackgroundColor.h"

@implementation UINavigationBar (BackgroundColor)

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, @"overlay");
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, @"overlay", overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)tjm_setBackgroundColor:(UIColor *)backgroundColor {
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        
        UIView *backgroundView = [self tjm_getBackgroundView];
        
        self.overlay = [[UIView alloc] initWithFrame:backgroundView.bounds];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

        [backgroundView insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = backgroundColor;
}

- (UIView *)tjm_getBackgroundView {
    //iOS10之前为 _UINavigationBarBackground, iOS10为 _UIBarBackground
    //_UINavigationBarBackground实际为UIImageView子类，而_UIBarBackground是UIView子类
    //之前setBackgroundImage直接赋值给_UINavigationBarBackground，现在则是设置后为_UIBarBackground增加一个UIImageView子控件方式去呈现图片
    if (TJMCurrentDevice >= 10.0) {
        UIView *_UIBackground;
        NSString *targetName = @"_UIBarBackground";
        Class _UIBarBackgroundClass = NSClassFromString(targetName);
        
        for (UIView *subview in self.subviews) {
            if ([subview isKindOfClass:_UIBarBackgroundClass.class]) {
                _UIBackground = subview;
                break;
            }
        }
        return _UIBackground;
    }
    else {
        UIView *_UINavigationBarBackground;
        NSString *targetName = @"_UINavigationBarBackground";
        Class _UINavigationBarBackgroundClass = NSClassFromString(targetName);
        
        for (UIView *subview in self.subviews) {
            if ([subview isKindOfClass:_UINavigationBarBackgroundClass.class]) {
                _UINavigationBarBackground = subview;
                break;
            }
        }
        return _UINavigationBarBackground;
    }
}

- (void)tjm_removeBackgroundView {
    if (self.overlay) {
        [self.overlay removeFromSuperview];
        self.overlay = nil;
        UIView *backgroundView = [self tjm_getBackgroundView];
        UIVisualEffectView *view = [[UIVisualEffectView alloc]initWithFrame:backgroundView.bounds];
        
    }
}

#pragma mark - shadow view
- (void)tjm_hideShadowImageOrNot:(BOOL)bHidden
{
    UIView *bgView = [self tjm_getBackgroundView];
    
    //shadowImage应该是只占一个像素，即1.0/scale
    for (UIView *subview in bgView.subviews) {
        if (CGRectGetHeight(subview.bounds) <= 1.0) {
            subview.hidden = bHidden;
        }
    }
}




@end
