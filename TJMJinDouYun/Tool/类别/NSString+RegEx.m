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

#pragma  mark 判断是否中文（整段）
- (BOOL)isChinese {
    NSString *chinese = @"^[\u4E00-\u9FA5]+$";
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
#pragma  mark 判断是否数字
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

#pragma  mark 判断是否身份证号
- (BOOL)judgeIdentityStringValid {
    
    if (self.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";
    //  NSString *regex = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:self]) return NO;
    //** 开始进行校验 *//
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[self substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [self substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"] || ![idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}


@end
