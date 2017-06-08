//
//  UITextField+InputRule.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/31.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (InputRule)

/**只输入汉字*/
- (BOOL)realNameInputRuleWithTextFieldShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
/**身份证号格式化*/
- (BOOL)idCardInputRuleWithTextFieldShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
/**电话号码格式化*/
- (BOOL)phoneNumInpuRuleWithTextFieldShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
/**银行卡格式化*/
- (BOOL)bankCardInputRuleWithTextFieldShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
