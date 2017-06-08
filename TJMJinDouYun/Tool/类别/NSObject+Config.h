//
//  NSObject+Config.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/3.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSObject (Config)

- (void)tjm_resetHorizontalConstraints:(NSLayoutConstraint *)constrain, ... NS_REQUIRES_NIL_TERMINATION;
- (void)tjm_resetVerticalConstraints:(NSLayoutConstraint *)constrain, ... NS_REQUIRES_NIL_TERMINATION;
/**设置页面字体*/
- (void)tjm_adjustFont:(CGFloat)fontSize forView:(id)view, ... NS_REQUIRES_NIL_TERMINATION;

- (void)tjm_constructImaginaryLineWithView:(UIView *)view;
/**返回日期 格式(例：今天17:30)*/
- (NSString *)tjm_setDateFormatterWithTimestamp:(NSInteger)timestamp;
/**计算开工时间*/
- (NSString *)tjm_getTimeStringWithTimestamp:(NSInteger)timestamp;

@end
