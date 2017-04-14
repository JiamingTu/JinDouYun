//
//  NSString+RegEx.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/12.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegEx)
/*
 *判断是否是手机号
 */
- (BOOL)isMobileNumber;
/*
 *判断是否是中文
 */
- (BOOL)isChinese;
/*
 *判断是否是数字
 */
- (BOOL)isNumber;
@end
