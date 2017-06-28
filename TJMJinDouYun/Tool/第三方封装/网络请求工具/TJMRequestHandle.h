//
//  TJMRequestHandle.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/13.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef void(^SuccessBlock)(id successObj,NSString *msg);
typedef void(^FailBlock)(NSString *failString);
typedef void(^ProgressBlock)(NSProgress *progress);


@interface TJMRequestHandle : NSObject



/*
 *创建单例
 *
 *
 */

SingletonH(RequestHandle)

@property (nonatomic,strong) TJMTokenModel *tokenModel;

#pragma  mrak - 登录、注册、忘记、修改密码
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
#pragma  mark - 上传资料、审核、考试

/**自由人获取已开通地域 和 交通工具*/
- (void)getUploadRelevantInfoWithType:(NSString *)type form:(NSDictionary *)form success:(SuccessBlock)success fail:(FailBlock)failure;
/**自由人上传资料*/
- (void)uploadFreeManInfoWithForm:(NSDictionary *)form photos:(NSDictionary *)photos progress:(ProgressBlock)progress success:(SuccessBlock)success fail:(FailBlock)failure;

/*
 *上传自由人定位
 */
- (void)updateFreeManLocationWithCoordinate:(CLLocationCoordinate2D)coordinate withType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)failure;
/**自由人随机生成题库*/
- (void)freeManRandomGenerationTestQuestionSuccess:(SuccessBlock)success fial:(FailBlock)failure;
/**自由人获取学习视频*/
- (void)getLearnResourceWithChapter:(NSString *)chapter success:(SuccessBlock)success fail:(FailBlock)failure;
/**学习、考试通过*/
- (void)passExamWithChapter:(NSString *)chapter success:(SuccessBlock)success fail:(FailBlock)failure;
#pragma  mark - 收工、开工、抢单
/**收工开工*/
- (void)putFreeManWorkingStatusWithType:(NSString *)type
                                success:(SuccessBlock)success
                                   fail:(FailBlock)failure;

/**获取开工时长等信息*/
- (void)getFreeManWorkingTimeWithType:(NSString *)type
                              success:(SuccessBlock)success
                                 fail:(FailBlock)failure;


/**获取订单列表*/
- (void)getOrderListWithType:(NSString *)type myLocation:(CLLocationCoordinate2D)coordinate page:(NSInteger)page size:(NSInteger)size sort:(NSString *)sort dir:(NSString *)dir status:(NSInteger)status cityName:(NSString *)cityName success:(SuccessBlock)success fial:(FailBlock)failure;
/**抢单*/
- (void)robOrderWithOrderId:(NSNumber *)orderId success:(SuccessBlock)success fail:(FailBlock)failure;
/**确认取货上传图片*/
- (void)upLoadPickedOrderImage:(NSArray<UIImage *> *)images orderNo:(NSString *)number pregress:(ProgressBlock)progress success:(SuccessBlock)success fail:(FailBlock)failure;
/**获取签收二维码（非到付）*/
- (void)getQRCodeTextWithOrderId:(NSNumber *)orderId success:(SuccessBlock)success fail:(FailBlock)failure;
/**获取到付二维码链接*/
- (void)getPayOnDeliveryQRCodeTextWithOrderNo:(NSString *)orderNo success:(SuccessBlock)success fail:(FailBlock)failure;
/**生成语音、短信验证码 & 签收*/
- (void)getSignInCodeOrSignWithType:(NSString *)type parameters:(NSDictionary *)parameters success:(SuccessBlock)success fail:(FailBlock)failure;
/**查询单个订单*/
- (void)getSingleOrderWithOrderNumber:(NSString *)orderNo success:(SuccessBlock)success fail:(FailBlock)failure;
#pragma  mark - 银行卡、提现
/**绑定银行卡*/
- (void)bindingBankCardWithParameters:(NSMutableDictionary *)parameters success:(SuccessBlock)success fail:(FailBlock)failure;
/**获取可用银行列表或者已绑定银行卡列表*/
- (void)getBankListOrBoundBankCarkListWithType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)failure;
/**删除银行卡 或 提现*/
- (void)deleteBankCardOrTransferOutWithType:(NSString *)type parameters:(NSMutableDictionary *)parameters success:(SuccessBlock)success fail:(FailBlock)failure;
/**获取交易记录*/
- (void)getTradingRecordWithPage:(NSInteger)page size:(NSInteger)size sort:(NSString *)sort dir:(NSString *)dir success:(SuccessBlock)success fail:(FailBlock)failure;
#pragma  mark - 获取个人信息、上传头像等
/**获取个人信息*/
- (void)getPersonInfoSuccess:(SuccessBlock)success fail:(FailBlock)failure;
/**上传头像*/
- (void)uploadHeaderPhotoWithPhoto:(UIImage *)photo progress:(ProgressBlock)progress success:(SuccessBlock)success fail:(FailBlock)failure;
/**问题反馈*/
- (void)feedBackQuestionWithContent:(NSString *)content phoneNum:(NSString *)phoneNum success:(SuccessBlock)success fail:(FailBlock)failure;
/**获取业绩 及 评价*/
- (void)getFreeManPerformanceSuccess:(SuccessBlock)success fail:(FailBlock)failure;
#pragma  mark - 获取消息列表
/**获取消息列表*/
- (void)getFreeManMessageListWithPage:(NSInteger)page size:(NSInteger)size sort:(NSString *)sort success:(SuccessBlock)success fail:(FailBlock)failure;
#pragma  mark - 热力图
/**获取热力图数据*/
- (void)heatMapDataSuccessWithDay:(NSInteger)day cityName:(NSString *)cityName success:(SuccessBlock)success fail:(FailBlock)failure;
@end
