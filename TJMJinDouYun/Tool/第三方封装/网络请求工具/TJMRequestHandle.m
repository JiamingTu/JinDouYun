//
//  TJMRequestHandle.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/13.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMRequestHandle.h"
#import "NSString+MD5.h"

@interface TJMRequestHandle ()

@property (nonatomic,weak) AFHTTPSessionManager *manager;

@end

@implementation TJMRequestHandle

#pragma  mark - lazy loading
- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        self.manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return _manager;
}

#pragma  mark - 单例

+ (TJMRequestHandle *)shareRequestHandle {
    static TJMRequestHandle *_handle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _handle = [[TJMRequestHandle alloc]init];
    });
    return _handle;
}

#pragma  mark - 请求方法
#pragma  mark - 自由人登录、注册、验证码
#pragma  mark 获取短信验证码
- (void)shrotMessageCheckRequestWithPhoneNumber:(NSString *)number getCodeType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)failure {
    //拼接得到请求路径
    NSString *URLString = [TJMApiBasicAddress stringByAppendingString:type];
    //没有sign的请求参数
    NSDictionary *noSignParameters = @{@"mobile":number};
    //得到最终的请求参数
    NSDictionary *parameters = [self signWithDictionary:noSignParameters];
    
    [self.manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:@(200)]) {
            //操作成功
            success(responseObject);
            NSLog(@"%@",responseObject[@"msg"]);
        }else {
            //操作失败
            //失败原因
            failure(responseObject[@"msg"]);
            NSLog(@"获取验证码操作失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
        NSLog(@"请求错误，%@",error);
    }];
}

#pragma  mark 注册or登录
- (void)accountCheckWithForm:(NSDictionary *)form checkType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)failure {
    //拼接得到请求路径
    NSString *URLStirng = [TJMApiBasicAddress stringByAppendingString:type];
    //得到完整的请求参数
    NSDictionary *parameters = [self signWithDictionary:form];
    //网络请求
    [self.manager POST:URLStirng parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] isEqualToNumber:@(200)]) {
            //请求成功
            success(responseObject);
            NSLog(@"%@",responseObject[@"msg"]);
        } else {
            //非网络问题
            failure(responseObject[@"msg"]);
            NSLog(@"%@",responseObject[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //网络问题
        failure(error.localizedDescription);
        NSLog(@"请求失败");
    }];
    
    
}

#pragma  mark - 自由人上传资料
#pragma  mark 获取已开通省市县接口
#pragma  mark 获取所有的交通工具接口
#pragma  mark 获取自由人信息
- (void)getUploadRelevantInfoWithType:(NSString *)type form:(NSDictionary *)form success:(SuccessBlock)success fail:(FailBlock)failure  {
    NSString *URLString = [TJMApiBasicAddress stringByAppendingString:type];
    TJMTokenModel *tokenModel = [TJMSandBoxManager getTokenModel];
    if (tokenModel) {
        //token存在 继续获取
        NSLog(@"token存在");
        //设置请求头
        [self.manager.requestSerializer setValue:tokenModel.token forHTTPHeaderField:@"Authorization"];
        [self.manager GET:URLString parameters:form progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            //省市
            ProvinceData *provinceData = [ProvinceData mj_objectWithKeyValues:responseObject];
            Province *province = [provinceData.data firstObject];
            City *city = province.cities[0];
            Area *area = city.areas[0];
            NSLog(@"%@--%@--%@",province.provinceName,city.cityName,area.areaName);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败，%@",error);
        }];
    } else {
        //token不存在 重新登录
        NSLog(@"token不存在 重新登录");
    }
}
#pragma mark - 上传自由人资料信息
- (void)uploadFreeManInfoWithForm:(NSDictionary *)form photos:(NSDictionary *)photos success:(SuccessBlock)success fail(FailBlock)FailBlock {
    
    [self.manager.requestSerializer setValue:tokenModel.token forHTTPHeaderField:@"Authorization"];
    
}


#pragma  mark - sign 处理
- (NSDictionary *)signWithDictionary:(NSDictionary *)dictionary {
    //变为可变数组
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    //加入时间戳
    [parameters setObject:TJMTimestamp forKey:@"timestamp"];
    
    //升序得到 健值对应的两个数组
    NSArray *allKeyArray = [parameters allKeys];
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
    //通过排列的key值获取value
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortsing in afterSortKeyArray) {
        NSString *valueString = [parameters objectForKey:sortsing];
        [valueArray addObject:valueString];
    }
    //健值合并
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0 ; i < afterSortKeyArray.count; i++) {
        NSString *keyValue = [NSString stringWithFormat:@"%@%@",afterSortKeyArray[i],valueArray[i]];
        [signArray addObject:keyValue];
    }
    //signString用于签名的原始参数集合
    NSString *signString = [signArray componentsJoinedByString:@""];
    //秘钥拼接
    signString = [NSString stringWithFormat:@"%@%@%@",TJMSecretKey,signString,TJMSecretKey];
    //MD5加密
    signString = [signString MD5];
    //添加健值  sign
    [parameters setObject:signString forKey:@"sign"];
    return parameters;
    
}



@end
