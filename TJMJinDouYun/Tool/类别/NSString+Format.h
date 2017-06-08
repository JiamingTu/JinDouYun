//
//  NSString+Format.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/23.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Format)
/**银行卡号加* */
+ (NSString *)getNewBankNumWitOldBankNum:(NSString *)bankNum;
/**时间戳 格式化*/
+ (NSString *)getTimeWithTimestamp:(NSString *)timestamp formatterStr:(NSString *)formatterStr;
@end
