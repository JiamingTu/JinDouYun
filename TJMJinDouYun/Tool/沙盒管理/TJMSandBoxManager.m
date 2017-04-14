//
//  TJMSandBoxManager.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/13.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMSandBoxManager.h"

@implementation TJMSandBoxManager


#pragma  mark - 授权tokenModel操作
#pragma  mark 获取路径
+ (NSString *)getPath {
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"tokenModel.tjm"];
}
#pragma  mark 存入
+ (BOOL)saveTokenToPath:(TJMTokenModel *)tokenModel {
    //讲tokenModel存入document文件夹下
    NSLog(@"沙盒路径：%@",[self getPath]);
    BOOL result = [NSKeyedArchiver archiveRootObject:tokenModel toFile:[self getPath]];
    return result;
}
#pragma  mark 取出
+ (TJMTokenModel *)getTokenModel {
    TJMTokenModel *tokenModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getPath]];
    return tokenModel;
}
#pragma  mark 删除
+ (BOOL)deleteTokenModel {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self getPath]]) {
        NSError *error = nil;
        BOOL result = [fileManager removeItemAtPath:[self getPath] error:&error];
        if (result) {
            return YES;
        } else {
            NSLog(@"删除失败，%@",error);
            return NO;
        }
    } else {
        NSLog(@"token不存在，重新登录");
        return NO;
    }
}
@end
