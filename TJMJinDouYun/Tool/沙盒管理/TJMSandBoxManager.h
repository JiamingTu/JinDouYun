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
@end
