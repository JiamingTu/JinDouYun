//
//  TJMRequestHandle.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/13.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMRequestHandle.h"
#import "NSString+MD5.h"
#import <CoreLocation/CoreLocation.h>

#define TJMRightCode [responseObject[@"code"] isEqualToNumber:@(200)]
#define TJMResponseMessage responseObject[@"msg"]
@interface TJMRequestHandle ()

@property (nonatomic,strong) AFHTTPSessionManager *httpRequestManager;
@property (nonatomic,strong) AFHTTPSessionManager *jsonRequestManager;
@property (nonatomic,strong) TJMTokenModel *tokenModel;
@end

@implementation TJMRequestHandle

#pragma  mark - lazy loading
#pragma  mark 请求参数格式为二进制
- (AFHTTPSessionManager *)httpRequestManager {
    if (!_httpRequestManager) {
        self.httpRequestManager = [AFHTTPSessionManager manager];
        _httpRequestManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _httpRequestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestManager.requestSerializer.timeoutInterval = 10;
    }
    return _httpRequestManager;
}
#pragma  mark 请求参数格式为json
- (AFHTTPSessionManager *)jsonRequestManager {
    if (!_jsonRequestManager) {
        self.jsonRequestManager = [AFHTTPSessionManager manager];
        _jsonRequestManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _jsonRequestManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _jsonRequestManager.requestSerializer.timeoutInterval = 10;
    }
    return _jsonRequestManager;
}
- (TJMTokenModel *)tokenModel {
    if (!_tokenModel) {
        self.tokenModel = [TJMSandBoxManager getTokenModel];
    }
    return _tokenModel;
}
#pragma  mark - 单例

SingletonM(RequestHandle)


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
    //清除auth请求头
    [self.httpRequestManager.requestSerializer clearAuthorizationHeader];
    [self.httpRequestManager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:@(200)]) {
            //操作成功
            success(responseObject,TJMResponseMessage);
            TJMLog(@"%@",responseObject[@"msg"]);
        }else {
            //操作失败
            //失败原因
            failure(responseObject[@"msg"]);
            TJMLog(@"获取验证码操作失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
        TJMLog(@"请求错误，%@",error);
    }];
}

#pragma  mark 注册or登录
- (void)accountCheckWithForm:(NSDictionary *)form checkType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)failure {
    //拼接得到请求路径
    NSString *URLStirng = [TJMApiBasicAddress stringByAppendingString:type];
    //得到完整的请求参数
    NSDictionary *parameters = [self signWithDictionary:form];
    //清除auth请求头
    [self.httpRequestManager.requestSerializer clearAuthorizationHeader];
    //网络请求
    [self.httpRequestManager POST:URLStirng parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] isEqualToNumber:@(200)]) {
            //请求成功
            success(responseObject,TJMResponseMessage);
            TJMLog(@"%@",responseObject[@"msg"]);
        } else {
            //非网络问题
            failure(responseObject[@"msg"]);
            TJMLog(@"%@",responseObject[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //网络问题
        failure(error.localizedDescription);
        TJMLog(@"请求失败");
    }];
    
    
}
#pragma  mark sign 处理
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

#pragma  mark 开工/收工
- (void)putFreeManWorkingStatusWithType:(NSString *)type
                                success:(SuccessBlock)success
                                   fail:(FailBlock)failure {
    NSString *carrierId = self.tokenModel.userId.description;
    NSString *path = [type isEqualToString:@"Start"] ? TJMStartWork(carrierId) : TJMStopWork(carrierId);
    NSString *URLString = [TJMApiBasicAddress stringByAppendingString:path];
    [self.httpRequestManager.requestSerializer clearAuthorizationHeader];
    [_httpRequestManager PUT:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (TJMRightCode) {
            TJMLog(@"%@",TJMResponseMessage);
        } else {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)getFreeManWorkingTimeWithType:(NSString *)type
                              success:(SuccessBlock)success
                                 fail:(FailBlock)failure {
    NSString *carrierId = self.tokenModel.userId.description;
    NSString *path = [type isEqualToString:@"CurrentTime"] ? TJMCurrentWorkTime(carrierId) : TJMTotalWorkTime(carrierId);
    NSString *URLString = [TJMApiBasicAddress stringByAppendingString:path];
    [self.httpRequestManager.requestSerializer clearAuthorizationHeader];
    [_httpRequestManager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (TJMRightCode) {
            TJMLog(@"%@",TJMResponseMessage);
        } else {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma  mark - 自由人上传资料
#pragma  mark 获取已开通省市县接口
#pragma  mark 获取所有的交通工具接口
#pragma  mark 获取自由人信息
- (void)getUploadRelevantInfoWithType:(NSString *)type form:(NSDictionary *)form success:(SuccessBlock)success fail:(FailBlock)failure  {
    NSString *URLString = [TJMApiBasicAddress stringByAppendingString:type];
    if (self.tokenModel) {
        //token存在 继续获取
        TJMLog(@"token存在");
        //设置请求头
        [self.jsonRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        [self.jsonRequestManager GET:URLString parameters:form progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            TJMLog(@"%@",responseObject);
            //省市
            TJMProvinceData *provinceData = [TJMProvinceData mj_objectWithKeyValues:responseObject];
            TJMProvince *province = [provinceData.data firstObject];
            TJMCity *city = province.cities[0];
            TJMArea *area = city.areas[0];
            TJMLog(@"%@--%@--%@",province.provinceName,city.cityName,area.areaId);
            
            //交通工具
            TJMVehicleData *vehicleData = [TJMVehicleData mj_objectWithKeyValues:responseObject];
            for (TJMVehicle *vehicle in vehicleData.data) {
                TJMLog(@"%@",vehicle.toolName);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            TJMLog(@"请求失败，%@",error);
        }];
    } else {
        //token不存在 重新登录
        TJMLog(@"token不存在 重新登录");
    }
}
#pragma mark 上传自由人资料信息
- (void)uploadFreeManInfoWithForm:(NSDictionary *)form photos:(NSDictionary *)photos success:(SuccessBlock)success fail:(FailBlock)FailBlock {
    if (self.tokenModel) {
        [self.jsonRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        
        //获取路径
        NSString *URLString = [TJMApiBasicAddress stringByAppendingString:TJMFreeManUploadInfo];
        
        [self.jsonRequestManager POST:URLString parameters:form constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //拼接图片
            [photos.allValues enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSData *imageData = UIImagePNGRepresentation(image);
                
                NSString *imageName = photos.allKeys[idx];
                [formData appendPartWithFileData:imageData name:imageName fileName:[NSString stringWithFormat:@"%@.png",imageName] mimeType:@"image/png"];
            }];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            TJMLog(@"%@",responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            TJMLog(@"%@",error);
        }];
    } else {
        //token不存在 重新登录
        TJMLog(@"token不存在 重新登录");
    }
    
    
}



#pragma  mark - 自由人定位、客户定位定位
- (void)freeManOrCustomerLocationWithCoordinate:(CLLocationCoordinate2D)coordinate withType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)failure {
    NSString *URLString = [TJMApiBasicAddress stringByAppendingString:type];
    //三元运算，根据type 得到不同的请求参数
    NSDictionary *parameters = [type isEqualToString:TJMUploadFreeManLocation] ?
    @{@"lat":@(coordinate.latitude),
      @"lng":@(coordinate.longitude),
@"carrierId":self.tokenModel.userId}
    :
    @{@"lat":@(coordinate.latitude),
      @"lng":@(coordinate.longitude)};
    //三元运算，根据type 设置请求头
    [type isEqualToString:TJMUploadFreeManLocation] ? [self.httpRequestManager.requestSerializer setValue:self.tokenModel.token forHTTPHeaderField:@"Authorization"] : [self.httpRequestManager.requestSerializer clearAuthorizationHeader];
    [self.httpRequestManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (TJMRightCode) {
            TJMLog(@"code正确，%@",TJMResponseMessage);
            //处理
            TJMLocationData *data = [TJMLocationData mj_objectWithKeyValues:responseObject];
            success(data,responseObject[@"msg"]);
        }else {
            NSLog(@"code错误，%@",TJMResponseMessage);
            failure(TJMResponseMessage);
        }
        NSLog(@"%@:%@",TJMResponseMessage,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TJMLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
}

#pragma  mark - 自由人获取题库
- (void)freeManRandomGenerationTestQuestion {
    NSString *URLString = [TJMApiBasicAddress stringByAppendingString:TJMRandomGenerationTestQuestion];
    if (self.tokenModel) {
        [self.httpRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        NSDictionary *parameters = @{@"carrierId":self.tokenModel.userId};
        [self.httpRequestManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (TJMRightCode) {
                //code码正确
                TJMLog(@"%@",responseObject);
                TJMTestQuestionData *tqd = [TJMTestQuestionData mj_objectWithKeyValues:responseObject[@"data"]];
                TJMQuestion *question = tqd.question[0];
                TJMLog(@"%@----%@",question,tqd.config.fullScore);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            TJMLog(@"%@",error.localizedDescription);
        }];
    }
}




@end
