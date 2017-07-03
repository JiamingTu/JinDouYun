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
//http://www.qiaoqiao123.com/jdy/swagger-ui.html
// 秘钥
#define TJMSecretKey @"c7b302432e2a16f77ebdf44455585491"
//基础接口地址
#define TJMApiBasicAddress @"http://www.qiaoqiao123.com/jdy"
//图片基础地址（头像）
#define TJMPhotoBasicAddress @"http://www.qiaoqiao123.com/"

#pragma  mark - 自由人
/*
 *注册验证码 GET
 *Parameters
 *  mobile
 *  timestamp
 *  sign
 */
#define TJMGetRegisterCode @"/carrier/users/auth/register/code"
/*
 *注册 POST
 *Parameters
 *  mobile
 *  pwd
 *  timestamp
 *  code
 *  sign
 */
#define TJMRegister @"/carrier/users/auth/register"
/*
 *登录 POST
 *Parameters
 *  mobile
 *  pwd
 *  timestamp
 *  sign
 */
#define TJMLogin @"/carrier/users/auth/login"
/*
 *忘记密码验证码 GET
 *Parameters
 *  mobile
 *  timestamp
 *  sign
 */
#define TJMGetForgetSecretCode @"/carrier/users/auth/forget/code"
/*
 *快捷登录验证码 GET
 *Parameters
 *  mobile
 *  timestamp
 *  sign
 */
#define TJMGetLoginCode @"/carrier/users/auth/codeLogin/code"
/*
 *更改密码 POST
 *Parameters
 *  mobile
 *  pwd
 *  timestamp
 *  code
 *  sign
 */
#define TJMChageSecret @"/carrier/users/auth/codeModify"
/*
 *快捷登录 POST
 *Parameters
 *  mobile
 *  pwd
 *  timestamp
 *  code
 *  sign
 */
#define TJMCodeLogin @"/carrier/users/auth/codeLogin"

#pragma  mark 开工相关
/*
 *开工 PUT
 *Parameters
 *  carrierId          ->path
 */
#define TJMStartWork(carrierId) [NSString stringWithFormat:@"/carrier/users/start/%@",carrierId]
/*
 *收工 PUT
 *Parameters
 *  carrierId          ->path
 */
#define TJMStopWork(carrierId) [NSString stringWithFormat:@"/carrier/users/stop/%@",carrierId]


/*
 *获取当前开工时间 GET
 *Parameters
 *
 */
#define TJMCurrentWorkTime @"currentWorkTime"
/*
 *获取开工总时间 GET
 *Parameters
 *
 */
#define TJMTotalWorkTime @"totalWorkTime"
/*
 *个人中心业绩评价 GET
 *Parameters
 *
 */
#define TJMPerformance @"performance"
/*
 *获得今日收益、今日出工时长等 GET
 *Parameters
 *
 */
#define TJMTodayData @"todayData"



#pragma  mark - 自由人上传资料
/*
 *获取已开通省市接口 GET
 *Parameters
 *  Authorization     ->header
 */
#define TJMFreeManGetCity @"/carrier/info/area"
/*
 *获取交通工具接口 GET
 *Parameters
 *  Authorization     ->header
 */
#define TJMFreeManGetVehicle @"/carrier/info/tools"
/*
 *上传资料接口 POST
 *Parameters
 *  Authorization     ->header
 *  photo             ->formData
 *  personCardPhoto   ->formData
 *  frontCardPhoto    ->formData
 *  backCardPhoto     ->formData
 *  realName
 *  idCard
 *  concact
 *  concactMobile
 *  areaId
 *  toolId
 *  carrierId
 *
 */
#define TJMFreeManUploadInfo @"/carrier/info/upload"

/*
 *获取自由人信息接口 GET
 *Parameters
 *  Authorization     ->header
 *  CarrierId         ->path
 */
//[NSString stringWithFormat:@"/carrier/info/%@",CarrierId]
#define TJMFreeManGetInfo(carrierId) [NSString stringWithFormat:@"/carrier/info/%@",carrierId]

#pragma  mark - 自由人上传定位
/*
 *自由人上传定位 POST
 *Parameters
 *  lat
 *  lng
 *  carrierId
 */
#define TJMUploadFreeManLocation @"/carrier/locations"

#pragma  mark - 自由人获取题库
/*
 *随机生成题库 POST
 *Parameters
 *  carrierId
 */
#define TJMRandomGenerationTestQuestion @"/carrier/exams"

#define TJMPassExam(chapter) [NSString stringWithFormat:@"/carrier/exams/%@",chapter]

#define TJMGetLearnResource(chapter) [NSString stringWithFormat:@"/carrier/exams/resource/%@",chapter]

#pragma  mark - 用户定位
/*
 *用户定位 POST
 *Parameters
 *  lat
 *  lng
 */
#define TJMCustomerLocationNearby @"/customer/locations/auth/nearBy"

#pragma  mark - 订单
/*
 *查询可抢单列表 GET
 *Parameters
 *  page
 *  size
 *  sort
 *  dir  -> ASC or DESC
 */
#define TJMWaitRobOrder @"/orders/queryWaitOrder"
/*
 *根据状态查询自由人订单 GET
 *Parameters
 *  page
 *  size
 *  sort
 *  carrierId
 *  dir  -> ASC or DESC
 */
#define TJMStatusOrder @"/orders/queryOrders"
/**获取自由人所有订单*/
#define TJMFreeManAllOrder @"/orders/carrierOrder"

#pragma  mark 自由人抢单
#define TJMFreeManRobOrder @"/orders/grab"

#pragma  mark 自由人抢单后确认收货（拍照）
#define TJMSurePickUp @"/orders/pickup"

#pragma  mark 生成签收二维码
#define TJMQRCodeSignIn @"/orders/qrCodeSign"
#pragma  mark 生成语音、短信验证码签收
/*
 *生成短信验证码 PUT
 *Parameters
 *  Authorization     ->header
 *  carrierId         
 *  orderNo
 */
#define TJMMsgCodeSignIn @"/orders/sendSMSCode"
/*
 *生成语音验证码 PUT
 *Parameters
 *  Authorization     ->header
 *  carrierId
 *  orderNo
 */
#define TJMVoiceCodeSignIn @"/orders/sendVoiceCode"
/*
 *确认送达 PUT
 *Parameters
 *  Authorization     ->header
 *  carrierId
 *  orderNo
 *  code
 *  sign
 */
#define TJMSignInOrder @"/orders/signOrder"
#pragma  mark 到付
/*
 *获取到付二维码
 */
#define TJMPayOnDeliveryQRCode @"/pay/cod"
#pragma  mark 代付
/*
 *代付接口
 *  orderNo
 */
#define TJMHelpPay @"/pay/helpPay"

#pragma  mark 获取单个订单
/*
 *获取单个订单 GET
 *Parameters
 *  Authorization     ->header
 *  orderNo
 */
#define TJMGetSingleOrder(orderNo) [NSString stringWithFormat:@"/orders/auth/%@",orderNo]
#pragma  mark - 我的钱包（绑定银行卡、提现等）
/*
 *绑定银行卡 POST
 *Parameters
 *  Authorization     ->header
 *  carrierId
 *  bankcard
 *  realname
 *  bankId
 */
#define TJMBindingBankCard @"/carrier/users/bankCardVerify"
/*
 *查询绑定银行卡列表 GET
 *Parameters
 *  Authorization     ->header
 *  carrierId         ->path
 */
#define TJMGetBoundBankCardList(carrierId) [NSString stringWithFormat:@"/carrier/users/bankCards/%@",carrierId]
/*
 *获取可用银行列表 GET
 *
 */
#define TJMGetBankList @"/banks"
/*
 *删除绑定银行卡 PUT
 *Parameters
 *  Authorization     ->header
 *  carrierId
 *  bankCardId
 */
#define TJMDeleteBankCard @"/carrier/users/bankCards/close"
/*
 *删除绑定银行卡 PUT
 *Parameters
 *  Authorization     ->header
 *  carrierId
 *  bankcardId
 *  money
 */
#define TJMTransferOut @"/carrier/users/bankCardWithdraw"
/*
 *交易记录 GET
 *Parameters
 *  Authorization     ->header
 *  carrierId         ->path
 */
#define TJMGetTradingRecord(carrierId) [NSString stringWithFormat:@"/carrier/users/account/%@",carrierId]
#pragma  mark - 评论
/*
 *获取评论 GET
 *Parameters
 *  Authorization     ->header
 *  carrierId
 */
#define TJMGetCommentList @"/customer/comment/"

#pragma  mark - 个人信息 上传头像等
/*
 *获取个人信息 GET
 *Parameters
 *  Authorization     ->header
 *  carrierId         ->path
 */
#define TJMGetPersonInfo(carrierId) [NSString stringWithFormat:@"/carrier/users/info/%@",carrierId]
/*
 *修改头像 PUT
 *Parameters
 *  Authorization     ->header
 *  carrierId
 */
#define TJMUploadHeaderPhoto @"/carrier/info/headPhoto"
/*
 *上传评论 POST
 *Parameters
 *  Authorization     ->header
 *  content
 *  carrierId
 *  feedback          ->body
 */
#define TJMFeedback @"/carrier/feedback"

#pragma  mark - 获取评价 业绩
/*
 *获取评价、业绩 GET
 *Parameters
 *  Authorization     ->header
 *  carrierId         ->path
 */
#define TJMFreeManPerformance(carrierId) [NSString stringWithFormat:@"/carrier/users/performance/%@",carrierId]

#pragma  mark - 获取消息列表
/*
 *获取评价、业绩 GET
 *Parameters
 *  Authorization     ->header
 *  carrierId         ->path
 */
#define TJMGetMessageList(carrierId) [NSString stringWithFormat:@"/carrier/message/%@",carrierId]

#pragma  mark - 热力图
/*
 *获取热力图数据 GET
 *Parameters
 *  Authorization     ->header
 *  cityName          
 *  day（默认7日内热力图）
 */
#define TJMGetHeatMapData @"/carrier/locations/k_chart"

#pragma  mark - 版本控制
/*
 *获取热力图数据 GET
 *Parameters
 *  Authorization     ->header
 *  type
 */
#define TJMCheckVersion @"/carrier/version"





#endif /* TJMApi_h */
