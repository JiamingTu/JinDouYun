//
//  TJMApi.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/11.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#ifndef TJMApi_h
#define TJMApi_h
//接口地址
//http://116.62.47.61:8081/jdy/swagger-ui.html#!/carrier-controller/modifyUsingPOST
// 秘钥
#define TJMSecretKey @"c7b302432e2a16f77ebdf44455585491"
//基础接口地址
#define TJMApiBasicAddress @"http://116.62.47.61:8081/jdy"

#pragma  mark - 自由人
/*
 *注册验证码 GET
 *Parameters
 *    mobile
 *    timestamp
 *    sign
 */
#define TJMGetRegisterCode @"/carrier/users/auth/register/code"
/*
 *注册 POST
 *Parameters
 *    mobile
 *    pwd
 *    timestamp
 *    code
 *    sign
 */
#define TJMRegister @"/carrier/users/auth/register"
/*
 *登录 POST
 *Parameters
 *    mobile
 *    pwd
 *    timestamp
 *    sign
 */
#define TJMLogin @"/carrier/users/auth/login"
/*
 *忘记密码验证码 GET
 *Parameters
 *    mobile
 *    timestamp
 *    sign
 */
#define TJMGetForgetSecretCode @"/carrier/users/auth/forget/code"
/*
 *快捷登录验证码 GET
 *Parameters
 *    mobile
 *    timestamp
 *    sign
 */
#define TJMGetLoginCode @"/carrier/users/auth/codeLogin/code"
/*
 *更改密码 POST
 *Parameters
 *    mobile
 *    pwd
 *    timestamp
 *    code
 *    sign
 */
#define TJMChageSecret @"/carrier/users/auth/codeModify"
/*
 *快捷登录 POST
 *Parameters
 *    mobile
 *    pwd
 *    timestamp
 *    code
 *    sign
 */
#define TJMCodeLogin @"/carrier/users/auth/codeLogin"

#pragma  mark - 自由人上传资料
/*
 *获取已开通省市接口 GET
 *Parameters
 *    Authorization     ->header
 */
#define TJMFreeManGetCity @"/carrier/info/area"
/*
 *获取交通工具接口 GET
 *Parameters
 *    Authorization     ->header
 */
#define TJMFreeManGetVehicle @"/carrier/info/tools"
/*
 *上传资料接口 POST
 *Parameters
 *    Authorization     ->header
 *    photo             ->formData
 *    personCardPhoto   ->formData
 *    frontCardPhoto    ->formData
 *    backCardPhoto     ->formData
 *    realName
 *    idCard
 *    concact
 *    concactMobile
 *    areaId
 *    toolId
 *    carrierId
 *
 */
#define TJMFreeManUploadInfo @"/carrier/info/upload"

/*
 *获取自由人信息接口 GET
 *Parameters
 *    Authorization     ->header
 *    CarrierId         ->path
 */

#define TJMFreeManGetInfo(CarrierId) @"/carrier/info/"CarrierId

#endif /* TJMApi_h */
