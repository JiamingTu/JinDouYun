//
//  TJMHUDHandle.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/13.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMHUDHandle.h"
#import <MBProgressHUD.h>
@implementation TJMHUDHandle

+ (void)transientNoticeAtView:(UIView *)view withMessage:(NSString *)message {
    MBProgressHUD *progerssHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    progerssHUD.mode = MBProgressHUDModeText;
    progerssHUD.label.text = message;
    progerssHUD.label.font = [UIFont systemFontOfSize:15];
    progerssHUD.alpha = 0.8;
    progerssHUD.removeFromSuperViewOnHide = YES;//隐藏后从父视图移除
    progerssHUD.animationType = MBProgressHUDAnimationFade;//动画类型
    // 关闭绘制的"性能开关",如果alpha不为1,最好将opaque设为NO,让绘图系统优化性能
    progerssHUD.opaque = NO;
    [progerssHUD hideAnimated:YES afterDelay:1.5];
}

@end
