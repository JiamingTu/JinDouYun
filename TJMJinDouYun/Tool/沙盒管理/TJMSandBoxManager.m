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
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"tokenModel.jdy"];
}
#pragma  mark 存入
+ (BOOL)saveTokenToPath:(TJMTokenModel *)tokenModel {
    //讲tokenModel存入document文件夹下
    TJMLog(@"沙盒路径：%@",[self getPath]);
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
            TJMLog(@"删除失败，%@",error);
            return NO;
        }
    } else {
        TJMLog(@"token不存在，重新登录");
        return NO;
    }
}

#pragma  mark - 个人信息存储
+ (__kindof id)getModelFromInfoPlistWithKey:(NSString *)key {
    NSData *data =[[NSUserDefaults standardUserDefaults] dataForKey:key];
    if (data) {
        id model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return model;
    } else {
        return nil;
    }
}

+ (void)saveInInfoPlistWithModel:(id)model key:(NSString *)key {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    if (data) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    }
}
+ (void)deleteModelFromInfoPlistWithKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}
#pragma  mark - 消息存储
+ (NSString *)getMessagesPath {
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"messages.jdy"];
}
+ (BOOL)saveMessagesToPath:(NSArray *)data {
    BOOL result = [NSKeyedArchiver archiveRootObject:data toFile:[self getMessagesPath]];
    return result;
}
+ (NSArray *)getMessages {
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getMessagesPath]];
    return array;
}
+ (BOOL)deleteMessages {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self getMessagesPath]]) {
        NSError *error = nil;
        BOOL result = [fileManager removeItemAtPath:[self getMessagesPath] error:&error];
        if (result) {
            return YES;
        } else {
            TJMLog(@"删除失败，%@",error);
            return NO;
        }
    } else {
        TJMLog(@"消息文件不存在");
        return NO;
    }
}


@end
