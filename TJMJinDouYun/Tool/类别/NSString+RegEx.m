//
//  NSString+RegEx.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/12.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "NSString+RegEx.h"

@implementation NSString (RegEx)
#pragma  mark 判断是否手机号
- (BOOL)isMobileNumber {
    if (self.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
     * 电信号段: 133,149,153,170,173,177,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,155,156,170,171,175,176,185,186
     */
    NSString *CU = @"^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,149,153,170,173,177,180,181,189
     */
    NSString *CT = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";
    
    
    NSPredicate *regExtestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regExtestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regExtestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regExtestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regExtestmobile evaluateWithObject:self] == YES)
        || ([regExtestcm evaluateWithObject:self] == YES)
        || ([regExtestct evaluateWithObject:self] == YES)
        || ([regExtestcu evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma  mark 判断是否中文
- (BOOL)isChinese {
    NSString *chinese = @"[\u4e00-\u9fa5]";
    NSPredicate *regExChinese = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", chinese];
    if ([regExChinese evaluateWithObject:self] == YES) {
        if ([self containsString:@" "]) {
            return NO;
        }
        return YES;
    }else {
        return NO;
    }
    
}

- (BOOL)isNumber {
    NSString *number = @"^[0-9]*$";
    NSPredicate *regExNumber = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", number];
    if ([regExNumber evaluateWithObject:self] == YES) {
        if ([self containsString:@" "]) {
            return NO;
        }
        return YES;
    }else {
        return NO;
    }
}



@end
