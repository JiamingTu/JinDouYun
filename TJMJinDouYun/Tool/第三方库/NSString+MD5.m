//
//  NSString+MD5.m
//  加密算法
//
//  Created by scn on 16/9/5.
//  Copyright © 2016年 TAnna. All rights reserved.
//

#import "NSString+MD5.h"
@implementation NSString (MD5)
//MD5只能称为一种不可逆的加密算法，只能用作一些检验过程，不能恢复其原文。
- (id)MD5
{
    //MD5加密都是通过C语言的函数来计算，所以需要将加密的字符串转换为C语言的字符串
    const char *cStr = [self UTF8String];
    //创建一个C语言的字符数组，用来接收加密结束之后的字符
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    //MD5计算（也就是加密）
    //第一个参数：需要加密的字符串
    //第二个参数：需要加密的字符串的长度
    //第三个参数：加密完成之后的字符串存储的地方
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    //将加密完成的字符拼接起来使用（16进制的）。
    //声明一个可变字符串类型，用来拼接转换好的字符
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    //遍历所有的result数组，取出所有的字符来拼接
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        //%02x：x 表示以十六进制形式输出，02 表示不足两位，前面补0输出；超出两位，不影响。当x小写的时候，返回的密文中的字母就是小写的，当X大写的时候返回的密文中的字母是大写的。
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}
@end
