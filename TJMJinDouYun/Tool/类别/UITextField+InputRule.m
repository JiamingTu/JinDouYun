//
//  UITextField+InputRule.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/31.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "UITextField+InputRule.h"

@implementation UITextField (InputRule)

#pragma  mark - 输入规则
#pragma  mark - 银行卡 格式化
- (BOOL)bankCardInputRuleWithTextFieldShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    if (self) {
        NSString* text = self.text;
        //删除
        if([string isEqualToString:@""]){
            //删除一位
            if(range.length == 1){
                //最后一位,遇到空格则多删除一次
                if (range.location == text.length-1 ) {
                    if ([text characterAtIndex:text.length-1] == ' ') {
                        [self deleteBackward];
                    }
                    return YES;
                }
                //从中间删除
                else{
                    NSInteger offset = range.location;
                    
                    if (range.location < text.length && [text characterAtIndex:range.location] == ' ' && [self.selectedTextRange isEmpty]) {
                        [self deleteBackward];
                        offset --;
                    }
                    [self deleteBackward];
                    self.text = [self parseString:self.text];
                    UITextPosition *newPos = [self positionFromPosition:self.beginningOfDocument offset:offset];
                    self.selectedTextRange = [self textRangeFromPosition:newPos toPosition:newPos];
                    return NO;
                }
            }
            else if (range.length > 1) {
                BOOL isLast = NO;
                //如果是从最后一位开始
                if(range.location + range.length == self.text.length ){
                    isLast = YES;
                }
                [self deleteBackward];
                self.text = [self parseString:self.text];
                
                NSInteger offset = range.location + string.length;
                if (range.location == 4 || range.location == 9 || range.location == 14 || range.location == 19) {
                    offset ++;
                }
                if (isLast) {
                    //光标直接在最后一位了
                }else{
                    UITextPosition *newPos = [self positionFromPosition:self.beginningOfDocument offset:offset];
                    self.selectedTextRange = [self textRangeFromPosition:newPos toPosition:newPos];
                }
                
                return NO;
            }
            
            else{
                return YES;
            }
        }
        else if(string.length >0){
            //限制输入字符个数
            if (([self noneSpaseString:self.text].length + string.length - range.length > 19) ) {
                return NO;
            }
            //判断是否是纯数字(千杀的搜狗，百度输入法，数字键盘居然可以输入其他字符)
            if(![string isNumber]) {
                return NO;
            }
            [self insertText:string];
            self.text = [self parseString:self.text];
            
            NSInteger offset = range.location + string.length;
            if (range.location == 4 || range.location == 9 || range.location == 14 || range.location == 19) {
                offset ++;
            }
            UITextPosition *newPos = [self positionFromPosition:self.beginningOfDocument offset:offset];
            self.selectedTextRange = [self textRangeFromPosition:newPos toPosition:newPos];
            return NO;
        }else{
            return YES;
        }
        
    }
    
    return YES;
}

-(NSString*)noneSpaseString:(NSString*)string
{
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString*)parseString:(NSString*)string
{
    if (!string) {
        return nil;
    }
    NSMutableString* mStr = [NSMutableString stringWithString:[string stringByReplacingOccurrencesOfString:@" " withString:@""]];
    for (int i = 0; i < string.length / 4; i ++) {
        if (mStr.length != 0 && (mStr.length - i) / 4 > i) {
            [mStr insertString:@" " atIndex: (i+1) * 4 + i];
        }
    }
    
    
    return  mStr;
}

#pragma  mark - 只输入中文
- (BOOL)realNameInputRuleWithTextFieldShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 1) {
        if ([string isChinese]) {
            return YES;
        }
    } else if (string.length > 1) {
        for (int i = 0; i < string.length; i ++) {
            NSRange myRange = NSMakeRange(i, 1);
            NSString *myRangeString = [string substringWithRange:myRange];
            if ([myRangeString isChinese])[self insertText:myRangeString];
        }
        return NO;
    } else if (string.length == 0) {
        return YES;
    }
    return NO;
}
#pragma  mark 身份证号
- (BOOL)idCardInputRuleWithTextFieldShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //获取输入框 输入下一位之前的值
    NSMutableString *newValue = [self.text mutableCopy];
    //拼接 下一位 得到输入框输入完成后的值
    [newValue replaceCharactersInRange:range withString:string];
    if (newValue.length <= 17 && [newValue isNumber]) {
        return YES;
    } else if (newValue.length == 18 && [[newValue substringToIndex:16] isNumber] && ([[newValue substringFromIndex:17] isNumber] || [[newValue substringFromIndex:17] isEqualToString:@"X"] || [[newValue substringFromIndex:17] isEqualToString:@"x"])) {
        return YES;
    }
    return NO;
}
- (BOOL)phoneNumInpuRuleWithTextFieldShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //获取输入框 输入下一位之前的值
    NSMutableString *newValue = [self.text mutableCopy];
    //拼接 下一位 得到输入框输入完成后的值
    [newValue replaceCharactersInRange:range withString:string];
    if (newValue.length <= 13 && [newValue isNumber]) {
        return YES;
    }
    return NO;
}



@end
