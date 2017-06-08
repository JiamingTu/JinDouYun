//
//  TJMHUDHandle.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/13.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TJMHUDHandle : NSObject

+ (void)transientNoticeAtView:(UIView *)view withMessage:(NSString *)message;
/** 菊花加文字 */
+ (MBProgressHUD *)showRequestHUDAtView:(UIView *)view message:(NSString *)message;
+ (void)hiddenHUDForView:(UIView *)view;
/**圆圈进度条*/
+ (MBProgressHUD *)showProgressHUDAtView:(UIView *)view message:(NSString *)message;
@end
