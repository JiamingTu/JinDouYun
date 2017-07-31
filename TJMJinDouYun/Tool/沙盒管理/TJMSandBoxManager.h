//
//  TJMSandBoxManager.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/13.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TJMTokenModel;
@interface TJMSandBoxManager : NSObject

+ (BOOL)saveTokenToPath:(TJMTokenModel *)tokenModel;

+ (TJMTokenModel *)getTokenModel;

+ (BOOL)deleteTokenModel;
//增删改查info.plist
+ (__kindof id)getModelFromInfoPlistWithKey:(NSString *)key;
+ (void)saveInInfoPlistWithModel:(id)model key:(NSString *)key;
+ (void)deleteModelFromInfoPlistWithKey:(NSString *)key;

//储存消息列表
+ (BOOL)saveMessagesToPath:(NSArray *)data;

+ (NSArray *)getMessages;

+ (BOOL)deleteMessages;

/**每两周清理一次缓存*/
+ (BOOL)isScratchTimeWithDays:(NSInteger)days;
/**清理缓存*/
+ (void)clearCache;
@end
