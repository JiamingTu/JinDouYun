//
//  TJMRequestHandle.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/13.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef void(^SuccessBlock)(id successObj);
typedef void(^FailBlock)(NSString *failString);
@interface TJMRequestHandle : NSObject



/*
 *创建单例
 *
 *
 */
+ (TJMRequestHandle *)shareRequestHandle;

/*
 *短息验证(注册、忘记密码、快捷登录验证)
 *@param number 电话号码
 *
 */
- (void)shrotMessageCheckRequestWithPhoneNumber:(NSString *)number getCodeType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)failure ;
/*
 *登录或者注册
 *@param form 表单
 *@param type 请求内容（注册、登录等等）
 */
- (void)accountCheckWithForm:(NSDictionary *)form checkType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)failure;

/*
 *自由人上传资料
 */
- (void)getUploadRelevantInfoWithType:(NSString *)type form:(NSDictionary *)form success:(SuccessBlock)success fail:(FailBlock)failure;
@end
