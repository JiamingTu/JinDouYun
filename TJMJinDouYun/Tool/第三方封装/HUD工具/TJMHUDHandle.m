//
//  TJMHUDHandle.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/13.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMHUDHandle.h"


@interface TJMHUDHandle ()

@end

@implementation TJMHUDHandle
#pragma  mark 纯文字
+ (void)transientNoticeAtView:(UIView *)view withMessage:(NSString *)message {
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.label.text = message;
    progressHUD.label.font = [UIFont systemFontOfSize:15];
    progressHUD.alpha = 0.8;
    progressHUD.removeFromSuperViewOnHide = YES;//隐藏后从父视图移除
    progressHUD.animationType = MBProgressHUDAnimationFade;//动画类型
    // 关闭绘制的"性能开关",如果alpha不为1,最好将opaque设为NO,让绘图系统优化性能
    progressHUD.opaque = NO;
    [progressHUD hideAnimated:YES afterDelay:1.5];
}
#pragma  mark 轻触
+ (void)tapHUDWithTarget:(id)target atView:(UIView *)view withMessage:(NSString *)message  {
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.label.text = message;
    progressHUD.label.font = [UIFont systemFontOfSize:15];
    progressHUD.alpha = 0.8;
    progressHUD.removeFromSuperViewOnHide = YES;//隐藏后从父视图移除
    progressHUD.animationType = MBProgressHUDAnimationFade;//动画类型
    // 关闭绘制的"性能开关",如果alpha不为1,最好将opaque设为NO,让绘图系统优化性能
    progressHUD.opaque = NO;
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc]initWithTarget:target action:@selector(tap:)];
    bgTap.numberOfTapsRequired = 1;
    [progressHUD.backgroundView addGestureRecognizer:bgTap];
    UITapGestureRecognizer *HUDTap = [[UITapGestureRecognizer alloc]initWithTarget:target action:@selector(tap:)];
    HUDTap.numberOfTapsRequired = 1;
    [progressHUD addGestureRecognizer:HUDTap];
}
- (void)tap:(UIGestureRecognizer *)gestureRecognizer {
    
}

#pragma  mark 菊花加文字
+ (MBProgressHUD *)showRequestHUDAtView:(UIView *)view message:(NSString *)message {
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.label.text = message;
    progressHUD.label.font = [UIFont systemFontOfSize:15];
    progressHUD.alpha = 0.8;
    progressHUD.removeFromSuperViewOnHide = YES;//隐藏后从父视图移除
    progressHUD.animationType = MBProgressHUDAnimationFade;//动画类型
    // 关闭绘制的"性能开关",如果alpha不为1,最好将opaque设为NO,让绘图系统优化性能
    progressHUD.opaque = NO;
    return progressHUD;
}

+ (void)hiddenHUDForView:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:YES];
}
#pragma  mark 圆圈进度
+ (MBProgressHUD *)showProgressHUDAtView:(UIView *)view message:(NSString *)message {
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    progressHUD.mode = MBProgressHUDModeAnnularDeterminate;
    progressHUD.label.text = message;
    progressHUD.label.font = [UIFont systemFontOfSize:15];
    progressHUD.alpha = 0.8;
    progressHUD.removeFromSuperViewOnHide = YES;//隐藏后从父视图移除
    progressHUD.animationType = MBProgressHUDAnimationFade;//动画类型
    // 关闭绘制的"性能开关",如果alpha不为1,最好将opaque设为NO,让绘图系统优化性能
    progressHUD.opaque = NO;
    return progressHUD;
}


@end
