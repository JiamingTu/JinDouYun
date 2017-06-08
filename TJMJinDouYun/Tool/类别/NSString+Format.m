//
//  NSString+Format.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/23.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "NSString+Format.h"

@implementation NSString (Format)

#pragma  mark - 银行卡号加*
+ (NSString *)getNewBankNumWitOldBankNum:(NSString *)bankNum
{
    NSMutableString *mutableStr;
    if (bankNum.length) {
        mutableStr = [NSMutableString stringWithString:bankNum];
        for (int i = 0 ; i < mutableStr.length; i ++) {
            if (i>2&&i<mutableStr.length - 3) {
                [mutableStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
            }
        }
        NSString *text = mutableStr;
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        return newString;
    }
    return bankNum;
}

+ (NSString *)getTimeWithTimestamp:(NSString *)timestamp formatterStr:(NSString *)formatterStr {
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp.integerValue / 1000];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterStr];
    NSString *timeString = [formatter stringFromDate:confromTimesp];
    return timeString;
}

@end
