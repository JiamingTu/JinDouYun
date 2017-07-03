//
//  TJMRequestHandle.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/13.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMRequestHandle.h"

#import <CoreLocation/CoreLocation.h>

#define TJMRightCode [responseObject[@"code"] isEqualToNumber:@(200)]
#define TJMResponseMessage responseObject[@"msg"]
@interface TJMRequestHandle ()

@property (nonatomic,strong) AFHTTPSessionManager *httpRequestManager;
@property (nonatomic,strong) AFHTTPSessionManager *jsonRequestManager;

@end

@implementation TJMRequestHandle

#pragma  mark - lazy loading
#pragma  mark 请求参数格式为二进制
- (AFHTTPSessionManager *)httpRequestManager {
    if (!_httpRequestManager) {
        self.httpRequestManager = [AFHTTPSessionManager manager];
        AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
//        jsonResponseSerializer.removesKeysWithNullValues = YES;
        _httpRequestManager.responseSerializer = jsonResponseSerializer;
        _httpRequestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        // 设置超时时间
        [_httpRequestManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _httpRequestManager.requestSerializer.timeoutInterval = 10.0f;
        [_httpRequestManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
    return _httpRequestManager;
}
#pragma  mark 请求参数格式为json
- (AFHTTPSessionManager *)jsonRequestManager {
    if (!_jsonRequestManager) {
        self.jsonRequestManager = [AFHTTPSessionManager manager];
        AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
//        jsonResponseSerializer.removesKeysWithNullValues = YES;
        _jsonRequestManager.responseSerializer = jsonResponseSerializer;

        _jsonRequestManager.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置超时时间
        [_jsonRequestManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _jsonRequestManager.requestSerializer.timeoutInterval = 10.0f;
        [_jsonRequestManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
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

#pragma  mark - 基础Api拼接
- (NSString *)basicApiAppend:(NSString *)query {
    return [NSString stringWithFormat:@"%@%@",TJMApiBasicAddress,query];
}

#pragma  mark - 请求方法
#pragma  mark - 自由人登录、注册、验证码
#pragma  mark 获取短信验证码
- (void)shrotMessageCheckRequestWithPhoneNumber:(NSString *)number getCodeType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)failure {
    //拼接得到请求路径
    NSString *URLString = [self basicApiAppend:type];
    //没有sign的请求参数
    NSDictionary *noSignParameters = @{@"mobile":number};
    //得到最终的请求参数
    NSDictionary *parameters = [self signWithDictionary:noSignParameters needTimestamp:YES];
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
            TJMLog(@"%@",responseObject[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma  mark 注册or登录
- (void)accountCheckWithForm:(NSDictionary *)form checkType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)failure {
    //拼接得到请求路径
    NSString *URLStirng = [self basicApiAppend:type];
    //得到完整的请求参数
    NSDictionary *parameters = [self signWithDictionary:form needTimestamp:YES];
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
            TJMLog(@"%@",TJMResponseMessage);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //网络问题
        failure(error.localizedDescription);
        TJMLog(@"请求失败");
    }];
    
    
}
#pragma  mark sign 处理
- (NSDictionary *)signWithDictionary:(NSDictionary *)dictionary needTimestamp:(BOOL)isNeed {
    //变为可变数组
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    //加入时间戳
    if (isNeed) {
        [parameters setObject:TJMTimestamp forKey:@"timestamp"];
    }
    //MD5 加密
    NSString *pswd = parameters[@"pwd"];
    pswd = [pswd MD5];
    parameters[@"pwd"] = pswd;
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

#pragma  mark - 开工/收工
- (void)putFreeManWorkingStatusWithType:(NSString *)type
                                success:(SuccessBlock)success
                                   fail:(FailBlock)failure {
    if (self.tokenModel) {
        NSString *carrierId = self.tokenModel.userId.description;
        NSString *path = [type isEqualToString:@"Start"] ? TJMStartWork(carrierId) : TJMStopWork(carrierId);
        NSString *URLString = [self basicApiAppend:path];
        
        //设置请求头
        [self.httpRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        [_httpRequestManager PUT:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (TJMRightCode) {
                TJMLog(@"%@",TJMResponseMessage);
                success(responseObject,TJMResponseMessage);
            } else {
                TJMLog(@"%@",TJMResponseMessage);
                failure(TJMResponseMessage);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            TJMLog(@"%@",error.localizedDescription);
            failure(error.localizedDescription);
        }];
    }
}
- (void)getFreeManWorkingTimeWithType:(NSString *)type
                              success:(SuccessBlock)success
                                 fail:(FailBlock)failure {
    NSString *carrierId = self.tokenModel.userId.description;
    NSString *path = [NSString stringWithFormat:@"/carrier/users/%@/%@",type,carrierId];
    NSString *URLString = [self basicApiAppend:path];
    //设置请求头
    [self.httpRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
    [_httpRequestManager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (TJMRightCode) {
            success(responseObject,TJMResponseMessage);
        } else {
            failure(TJMResponseMessage);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma  mark - 自由人上传资料
#pragma  mark 获取已开通省市县接口
#pragma  mark 获取所有的交通工具接口
#pragma  mark 获取自由人信息
- (void)getUploadRelevantInfoWithType:(NSString *)type form:(NSDictionary *)form success:(SuccessBlock)success fail:(FailBlock)failure  {
    NSString *URLString = [self basicApiAppend:type];
    if (self.tokenModel) {
        //token存在 继续获取
        TJMLog(@"token存在，上传资料");
        //设置请求头
        [self.jsonRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        [self.jsonRequestManager GET:URLString parameters:form progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (TJMRightCode) {
                //如果code == 200
                if ([type isEqualToString:TJMFreeManGetCity]) {
                    //省市
                    TJMProvinceData *provinceData = [TJMProvinceData mj_objectWithKeyValues:responseObject];
                    success(provinceData,TJMResponseMessage);
                } else if ([type isEqualToString:TJMFreeManGetVehicle]) {
                    //交通工具
                    TJMVehicleData *vehicleData = [TJMVehicleData mj_objectWithKeyValues:responseObject];
                    success(vehicleData,TJMResponseMessage);
                } else {
                    TJMFreeManInfo *freeManInfo = [TJMFreeManInfo mj_objectWithKeyValues:responseObject[@"data"]];
                    //存入userdefault
                    [TJMSandBoxManager saveInInfoPlistWithModel:freeManInfo key:kTJMFreeManInfo];
                    success(freeManInfo,TJMResponseMessage);
                }
            }else {
                failure(TJMResponseMessage);
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            TJMLog(@"请求失败，%@",error);
            failure(error.localizedDescription);
        }];
    } else {
        //token不存在 重新登录
        TJMLog(@"token不存在 重新登录");
    }
}
#pragma mark 上传自由人资料信息
- (void)uploadFreeManInfoWithForm:(NSDictionary *)form photos:(NSDictionary *)photos progress:(ProgressBlock)progress success:(SuccessBlock)success fail:(FailBlock)failure {
    if (self.tokenModel) {
        [self.jsonRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        //获取路径
        NSString *URLString = [self basicApiAppend:TJMFreeManUploadInfo];
        
        [self.jsonRequestManager POST:URLString parameters:form constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //拼接图片
            [photos.allValues enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                NSString *imageName = photos.allKeys[idx];
                [formData appendPartWithFileData:imageData name:imageName fileName:[NSString stringWithFormat:@"%@.jpeg",imageName] mimeType:@"image/jpeg"];
            }];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            progress(uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (TJMRightCode) {
                success(responseObject,TJMResponseMessage);
            } else {
                if ([TJMResponseMessage isEqual:[NSNull null]]) {
                    failure(@"未知错误");
                } else {
                    failure(TJMResponseMessage);
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            TJMLog(@"%@",error);
            failure(error.localizedDescription);
        }];
    } else {
        //token不存在 重新登录
        TJMLog(@"token不存在 重新登录");
    }
    
    
}



#pragma  mark - 自由人定位、客户定位定位
- (void)updateFreeManLocationWithCoordinate:(CLLocationCoordinate2D)coordinate withType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)failure {
    NSString *URLString = [self basicApiAppend:type];
    //三元运算，根据type 得到不同的请求参数
    NSDictionary *parameters = @{@"lat":@(coordinate.latitude),
                                 @"lng":@(coordinate.longitude),
                                 @"carrierId":self.tokenModel.userId};
    //三元运算，根据type 设置请求头
    [self.httpRequestManager.requestSerializer setValue:self.tokenModel.token forHTTPHeaderField:@"Authorization"];
    [self.httpRequestManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (TJMRightCode) {
            TJMLog(@"code正确，定位%@",TJMResponseMessage);
            //处理
            success(responseObject,responseObject[@"msg"]);
        }else {
            TJMLog(@"code错误，定位%@",TJMResponseMessage);
            failure(TJMResponseMessage);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TJMLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
}
#pragma  mark - 入职考核
#pragma  mark 自由人获取库
- (void)freeManRandomGenerationTestQuestionSuccess:(SuccessBlock)success fial:(FailBlock)failure {
    NSString *URLString = [self basicApiAppend:TJMRandomGenerationTestQuestion];
    if (self.tokenModel) {
        [self.httpRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        NSDictionary *parameters = @{@"carrierId":self.tokenModel.userId};
        [self.httpRequestManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (TJMRightCode) {
                //code码正确
                TJMTestQuestionData *tqd = [TJMTestQuestionData mj_objectWithKeyValues:responseObject[@"data"]];
                success(tqd,TJMResponseMessage);
            } else {
                failure(TJMResponseMessage);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error.localizedRecoverySuggestion);
        }];
    }
}
#pragma  mark 考试通过
- (void)passExamWithChapter:(NSString *)chapter success:(SuccessBlock)success fail:(FailBlock)failure {
    if (self.tokenModel) {
        NSString *path = [self basicApiAppend:TJMPassExam(chapter)];
        [self.httpRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        [self.httpRequestManager PUT:path parameters:@{@"carrierId":_tokenModel.userId} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (TJMRightCode) {
                success(responseObject,TJMResponseMessage);
            } else {
                failure(TJMResponseMessage);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error.localizedDescription);
        }];
    }
}

- (void)getLearnResourceWithChapter:(NSString *)chapter success:(SuccessBlock)success fail:(FailBlock)failure {
    if (self.tokenModel) {
        NSString *path = [self basicApiAppend:TJMGetLearnResource(chapter)];
        [self.httpRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        [self.httpRequestManager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (TJMRightCode) {
                TJMStudyResource *studyResource = [TJMStudyResource mj_objectWithKeyValues:responseObject[@"data"]];
                success(studyResource,TJMResponseMessage);
            } else {
                failure(TJMResponseMessage);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error.localizedDescription);
        }];
        
        
        
        
    }
}



#pragma  mark -  获取订单
#pragma  mark 查询可抢单列表
#pragma  mark 根据订单状态查询自由人订单
- (void)getOrderListWithType:(NSString *)type myLocation:(CLLocationCoordinate2D)coordinate page:(NSInteger)page size:(NSInteger)size sort:(NSString *)sort dir:(NSString *)dir status:(NSInteger)status cityName:(NSString *)cityName success:(SuccessBlock)success fial:(FailBlock)failure {
    if (self.tokenModel) {
        NSString *path = [self basicApiAppend:type];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        if (page) [parameters setObject:@(page) forKey:@"page"];
        if (size) [parameters setObject:@(size) forKey:@"size"];
        if (sort) [parameters setObject:sort forKey:@"sort"];
        if (dir) [parameters setObject:dir forKey:@"dir"];
        
        if ([type isEqualToString:TJMStatusOrder]) {
            //如果type 为 TJMStatusOrder 需要增加参数 carrierId、status
            [parameters setObject:self.tokenModel.userId forKey:@"carrierId"];
            [parameters setObject:@(status) forKey:@"status"];
        } else if ([type isEqualToString:TJMFreeManAllOrder]) {
            //如果type 为 TJMFreeManAllOrder 需要增加参数 carrierId
            [parameters setObject:self.tokenModel.userId forKey:@"carrierId"];
        } else if ([type isEqualToString:TJMWaitRobOrder]) {
            //如果type 为 TJMWaitRobOrder 需要增加参数 cityName
            [parameters setObject:cityName forKey:@"cityName"];
        }
        [self.httpRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        [self.httpRequestManager GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            TJMLog(@"获取订单列表：%@",TJMResponseMessage);
            if (TJMRightCode) {
                if ([type isEqualToString:TJMFreeManAllOrder]) {
                    TJMMyOrderData *myOrderData = [TJMMyOrderData mj_objectWithKeyValues:responseObject];
                    [self addDistanceWithModelData:myOrderData myLocation:coordinate reslut:^(id successObj, NSString *msg) {
                        success(successObj,TJMResponseMessage);
                    }];
                } else {
                    TJMOrderData *orderData = [TJMOrderData mj_objectWithKeyValues:responseObject[@"data"]];
                    [self addDistanceWithModelData:orderData myLocation:coordinate reslut:^(id successObj, NSString *msg) {
                        success(successObj,TJMResponseMessage);
                    }];
                }
            } else {
                failure(TJMResponseMessage);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error.localizedDescription);
            TJMLog(@"获取订单列表：%@",error.localizedDescription);
        }];
    }
}

- (void)addDistanceWithModelData:(id)data myLocation:(CLLocationCoordinate2D)coordinate reslut:(SuccessBlock)result {
    //创建组
    dispatch_group_t group = dispatch_group_create();
    //创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    __block NSInteger count = 0;
    dispatch_group_async(group, queue, ^{
        //创建信号量
//        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSArray *array = [data isKindOfClass:[TJMOrderData class]] ? ((TJMOrderData *)data).content : ((TJMMyOrderData *)data).data;
        [array enumerateObjectsUsingBlock:^(TJMOrderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TJMLog(@"这时还没有回调----%zd------%@",idx,[NSThread currentThread]);
            [[TJMLocationService sharedLocationService] calculateDriveDistanceWithStartPoint:coordinate endPoint:CLLocationCoordinate2DMake(obj.consignerLat.doubleValue, obj.consignerLng.doubleValue)];
            [TJMLocationService sharedLocationService].routeResult = ^(double distance){
                obj.getDistance = distance;
                TJMLog(@"回调了回调了-----%zd------%@",idx,[NSThread currentThread]);
                NSInteger index = [array indexOfObject:obj];
                TJMLog(@"%zd++++++++%zd",index,idx);
//                dispatch_semaphore_signal(semaphore);
            };
//            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            usleep(200000);
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            TJMLog(@"-----距离计算完成-----");
            result(data,@"成功");
        }];
    });
}

/*
- (void)addDistanceWithModelData:(id)data myLocation:(CLLocationCoordinate2D)coordinate reslut:(SuccessBlock)result {
    //创建组
    dispatch_group_t group = dispatch_group_create();
    //创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(group, queue, ^{
        //创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSArray *array = [data isKindOfClass:[TJMOrderData class]] ? ((TJMOrderData *)data).content : ((TJMMyOrderData *)data).data;
        [array enumerateObjectsUsingBlock:^(TJMOrderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [[TJMLocationService sharedLocationService] calculateDriveDistanceWithStartPoint:coordinate endPoint:CLLocationCoordinate2DMake(obj.consignerLat.doubleValue, obj.consignerLng.doubleValue)];
            [TJMLocationService sharedLocationService].routeResult = ^(double distance){
                obj.getDistance = distance;
                TJMLog(@"%zd",idx);
                //回调成功后，标记1
                dispatch_semaphore_signal(semaphore);
            };
            //若标记为0，一直等待
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }];
        dispatch_group_notify(group, queue, ^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                result(data,@"成功");
            }];
        });
    });
}
*/
#pragma  mark 抢单
- (void)robOrderWithOrderId:(NSNumber *)orderId success:(SuccessBlock)success fail:(FailBlock)failure {
    if (self.tokenModel) {
        NSString *path = [self basicApiAppend:TJMFreeManRobOrder];
        NSDictionary *parameters = @{@"carrierId":self.tokenModel.userId,@"orderId":orderId};
        [self.httpRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        [self.httpRequestManager PUT:path parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (TJMRightCode) {
                success(responseObject,TJMResponseMessage);
            } else {
                failure(TJMResponseMessage);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error.localizedDescription);
        }];
    }
}
#pragma  mark 确认取货
- (void)upLoadPickedOrderImage:(NSMutableArray<UIImage *> *)images orderNo:(NSString *)number pregress:(ProgressBlock)progress success:(SuccessBlock)success fail:(FailBlock)failure {
    if (self.tokenModel) {
        [self.jsonRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        NSString *path = [self basicApiAppend:TJMSurePickUp];
        NSDictionary *parameters = @{@"orderNo":number,@"carrierId":_tokenModel.userId};
        [images removeLastObject];
        [self.jsonRequestManager POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //遍历上传图片
            [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSData *imageData = UIImageJPEGRepresentation(obj, 0.3);
                [formData appendPartWithFileData:imageData name:@"photos" fileName:[NSString stringWithFormat:@"%zd.jpeg",idx] mimeType:@"image/jpeg"];
            }];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            TJMLog(@"progress：%f",uploadProgress.fractionCompleted);
            progress(uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (TJMRightCode) {
                TJMLog(@"%@",TJMResponseMessage);
                success(responseObject,TJMResponseMessage);
            } else {
                failure(TJMResponseMessage);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error.localizedDescription);
        }];
    }
}
#pragma  mark 生成签收二维码（非到付）
- (void)getQRCodeTextWithOrderId:(NSNumber *)orderId success:(SuccessBlock)success fail:(FailBlock)failure {
    if (self.tokenModel) {
        NSString *path = [self basicApiAppend:TJMQRCodeSignIn];
        NSDictionary *parameters = @{@"orderId":orderId};
        [self.httpRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        [self.httpRequestManager GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            TJMLog(@"%@",responseObject);
            if (TJMRightCode) {
                success(responseObject[@"data"],TJMResponseMessage);
            } else {
                failure(TJMResponseMessage);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error.localizedDescription);
        }];
    }
}
#pragma  mark 生成语音、短信验证码 & 签收
- (void)getSignInCodeOrSignWithType:(NSString *)type parameters:(NSDictionary *)parameters success:(SuccessBlock)success fail:(FailBlock)failure {
    if (self.tokenModel) {
        NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
        [mutableParameters setObject:_tokenModel.userId forKey:@"carrierId"];
        //判断type 如果是签收 需要sign
        if ([type isEqualToString:TJMSignInOrder]) {
            //签收
            parameters = [self signWithDictionary:mutableParameters needTimestamp:NO];
        } else {
            //获取验证码
            parameters = mutableParameters;
        }
        NSString *path = [self basicApiAppend:type];
        [self.httpRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        [self.httpRequestManager PUT:path parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            TJMLog(@"%@",responseObject);
            if (TJMRightCode) {
                success(responseObject,TJMResponseMessage);
            } else {
                failure(TJMResponseMessage);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error.localizedDescription);
        }];
    }
}
#pragma  mark 生成到付二维码
- (void)getPayOnDeliveryQRCodeTextWithOrderNo:(NSString *)orderNo success:(SuccessBlock)success fail:(FailBlock)failure {
    if (self.tokenModel) {
        NSString *path = [self basicApiAppend:TJMPayOnDeliveryQRCode];
        NSDictionary *parameters = @{@"orderNo":orderNo};
        [self.httpRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        [self.httpRequestManager PUT:path parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            TJMLog(@"到付二维码：%@",responseObject);
            if (TJMRightCode) {
                success(responseObject[@"data"],TJMResponseMessage);
            } else {
                failure(TJMResponseMessage);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error.localizedDescription);
        }];
    }
}
#pragma  mark 代付
- (void)getHelpPayInfoWithOrderNo:(NSString *)orderNo success:(SuccessBlock)success fail:(FailBlock)failure {
    if (self.tokenModel) {
        NSString *path = [self basicApiAppend:TJMHelpPay];
        NSDictionary *parameters = @{@"orderNo":orderNo};
        [self.httpRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        [self.httpRequestManager GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (TJMRightCode) {
                NSDictionary *data = responseObject[@"data"];
                if (data) {
                    PayReq *request = [[PayReq alloc]init];
//                    request.openID = data[@"appid"];
                    /** 商家向财付通申请的商家id */
                    request.partnerId = [data[@"partnerid"] description];
                    /** 预支付订单 */
                    request.prepayId = [data[@"prepayid"] description];
                    /** 商家根据财付通文档填写的数据和签名 */
                    request.package = [data[@"package"] description];
                    /** 随机串，防重发 */
                    request.nonceStr = [data[@"noncestr"] description];
                    /** 时间戳，防重发 */
                    request.timeStamp = [data[@"timestamp"] intValue];
                    /** 商家根据微信开放平台文档对数据做的签名 */
                    request.sign= data[@"sign"];
                    success(request,TJMResponseMessage);
                }
            } else if ([TJMResponseMessage isEqual:[NSNull null]]) {
                failure(@"未知错误");
            } else {
                failure(TJMResponseMessage);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error.localizedDescription);
        }];
    }
}
#pragma  mark 查询单个订单
- (void)getSingleOrderWithOrderNumber:(NSString *)orderNo success:(SuccessBlock)success fail:(FailBlock)failure {
    if (self.tokenModel) {
        NSString *query = TJMGetSingleOrder(orderNo);
        NSString *path = [self basicApiAppend:query];
        [self.httpRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        [self.httpRequestManager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (TJMRightCode) {
                
            } else if ([TJMResponseMessage isEqual:[NSNull null]]) {
                failure(@"未知错误");
            } else {
                failure(TJMResponseMessage);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error.localizedDescription);
        }];
    }
}
#pragma  mark - 我的钱包（银行卡、提现等）
#pragma  mark 获取可用银行

#pragma  mark 绑定银行卡
- (void)bindingBankCardWithParameters:(NSMutableDictionary *)parameters success:(SuccessBlock)success fail:(FailBlock)failure {
    if (self.tokenModel) {
        NSString *path = [self basicApiAppend:TJMBindingBankCard];
        [parameters setObject:self.tokenModel.userId forKey:@"carrierId"];
        [self.httpRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        [self.httpRequestManager POST:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (TJMRightCode) {
                success(responseObject,TJMResponseMessage);
            } else {
                failure(TJMResponseMessage);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error.localizedDescription);
        }];
    }
}
#pragma  mark 查询绑定银行卡列表
- (void)getBankListOrBoundBankCarkListWithType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)failure {
    if (self.tokenModel) {
        NSString *path = [self basicApiAppend:type];
        [self.httpRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        [self.httpRequestManager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (TJMRightCode) {
                if ([type isEqualToString:TJMGetBankList]) {
                    //获取可用银行列表
                    TJMBankData *data = [TJMBankData mj_objectWithKeyValues:responseObject];
                    success(data,TJMResponseMessage);
                } else {
                    //获取已绑定银行卡信息
                    TJMBankCardData *data = [TJMBankCardData mj_objectWithKeyValues:responseObject];
                    success(data,TJMResponseMessage);
                }
            } else {
                failure(TJMResponseMessage);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error.localizedDescription);
        }];
        
    }
}

#pragma  mark 删除银行卡 或 提现
- (void)deleteBankCardOrTransferOutWithType:(NSString *)type parameters:(NSMutableDictionary *)parameters success:(SuccessBlock)success fail:(FailBlock)failure {
    if (self.tokenModel) {
        NSString *path = [self basicApiAppend:type];
        [parameters setObject:_tokenModel.userId forKey:@"carrierId"];
        [self.httpRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        [self.httpRequestManager PUT:path parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (TJMRightCode) {
                success(responseObject,TJMResponseMessage);
            } else {
                failure(TJMResponseMessage);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error.localizedDescription);
        }];
    }
}
#pragma  mark 交易记录
- (void)getTradingRecordWithPage:(NSInteger)page size:(NSInteger)size sort:(NSString *)sort dir:(NSString *)dir success:(SuccessBlock)success fail:(FailBlock)failure {
    if (self.tokenModel) {
        NSString *path = [self basicApiAppend:TJMGetTradingRecord(self.tokenModel.userId.description)];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        if (page) [parameters setObject:@(page) forKey:@"page"];
        if (size) [parameters setObject:@(size) forKey:@"size"];
        if (sort) [parameters setObject:sort forKey:@"sort"];
        if (dir) [parameters setObject:dir forKey:@"dir"];
        [self.httpRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        [self.httpRequestManager GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (TJMRightCode) {
                TJMTradingRecordData *data = [TJMTradingRecordData mj_objectWithKeyValues:responseObject[@"data"]];
                success(data,TJMResponseMessage);
            } else if ([TJMResponseMessage isEqual:[NSNull null]]) {
                failure(@"未知错误");
            } else {
                failure(TJMResponseMessage);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}

#pragma  mark - 个人信息 修改头像 问题反馈（设置里的功能）
#pragma  mark 获取个人信息
- (void)getPersonInfoSuccess:(SuccessBlock)success fail:(FailBlock)failure {
    if (self.tokenModel) {
        NSString *path = [self basicApiAppend:TJMGetPersonInfo(self.tokenModel.userId.description)];
        [self.httpRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        [self.httpRequestManager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (TJMRightCode) {
                TJMPersonInfoModel *personInfoModel = [TJMPersonInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
                //存入 info
                [TJMSandBoxManager saveInInfoPlistWithModel:personInfoModel key:kTJMPersonInfo];
                success(personInfoModel,TJMResponseMessage);
            } else if ([TJMResponseMessage isEqual:[NSNull null]]) {
                failure(@"未知错误");
            } else {
                failure(TJMResponseMessage);
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error.localizedDescription);
        }];
    }
}
#pragma  mark 上传头像
- (void)uploadHeaderPhotoWithPhoto:(UIImage *)photo progress:(ProgressBlock)progress success:(SuccessBlock)success fail:(FailBlock)failure {
    if (self.tokenModel) {
        NSString *path = [self basicApiAppend:TJMUploadHeaderPhoto];
        NSString *parametersString = [NSString stringWithFormat: @"carrierId=%@",self.tokenModel.userId];
        path = [path stringByAppendingFormat:@"?%@",parametersString ];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] multipartFormRequestWithMethod:@"PUT" URLString:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData *data = UIImageJPEGRepresentation(photo, 0.5);
            [formData appendPartWithFileData:data name:@"photo" fileName:@"headerImage.jpeg" mimeType:@"image/jpeg"];
        } error:nil];
        [request setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
            progress(uploadProgress);
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (TJMRightCode) {
                success(responseObject,TJMResponseMessage);
            } else if ([TJMResponseMessage isEqual:[NSNull null]]){
                failure(@"未知错误");
            } else {
                failure(TJMResponseMessage);
            }
            if (error) {
                failure(error.localizedDescription);
            }
        }];
        [uploadTask resume];
    }
}

#pragma mark 问题反馈
- (void)feedBackQuestionWithContent:(NSString *)content phoneNum:(NSString *)phoneNum success:(SuccessBlock)success fail:(FailBlock)failure {
    if (self.tokenModel) {
        NSString *path = [self basicApiAppend:TJMFeedback];
        [self.jsonRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        
        NSDictionary *body = @{@"content":content,@"mobile":phoneNum,@"userId":_tokenModel.userId,@"type":@(0)};
        [self.jsonRequestManager POST:path parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (TJMRightCode) {
                success(responseObject,TJMResponseMessage);
            } else {
                failure(TJMResponseMessage);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error.localizedDescription);
        }];
    }
}
#pragma  mark 个人业绩 及 评价
- (void)getFreeManPerformanceSuccess:(SuccessBlock)success fail:(FailBlock)failure {
    if (self.tokenModel) {
        NSString *path = [self basicApiAppend:TJMFreeManPerformance(self.tokenModel.userId.description)];
        [self.httpRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        [self.httpRequestManager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (TJMRightCode) {
                TJMPerformanceModel *model = [TJMPerformanceModel mj_objectWithKeyValues:responseObject[@"data"]];
                [TJMSandBoxManager saveInInfoPlistWithModel:model key:kTJMPerformanceInfo];
                success(model,TJMResponseMessage);
            } else if ([TJMResponseMessage isEqual:[NSNull null]]) {
                failure(@"未知错误");
            } else {
                failure(TJMResponseMessage);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error.localizedDescription);
        }];
    }
}

#pragma  mark - 获取消息列表
- (void)getFreeManMessageListWithPage:(NSInteger)page size:(NSInteger)size sort:(NSString *)sort success:(SuccessBlock)success fail:(FailBlock)failure {
    if (self.tokenModel) {
        NSString *path = [self basicApiAppend:TJMGetMessageList(self.tokenModel.userId.description)];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        if (page) [parameters setObject:@(page) forKey:@"page"];
        if (size) [parameters setObject:@(size) forKey:@"size"];
        if (sort) [parameters setObject:sort forKey:@"sort"];
        [self.httpRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        [self.httpRequestManager GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (TJMRightCode) {
                [TJMSandBoxManager deleteMessages];
                TJMMessageData *data = [TJMMessageData mj_objectWithKeyValues:responseObject];
                [TJMSandBoxManager saveMessagesToPath:data.data];
                success(data,TJMResponseMessage);
            } else if ([TJMResponseMessage isEqual:[NSNull null]]) {
                failure(@"未知错误");
            } else {
                failure(TJMResponseMessage);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}

#pragma  mark - 热力图
- (void)heatMapDataSuccessWithDay:(NSInteger)day cityName:(NSString *)cityName success:(SuccessBlock)success fail:(FailBlock)failure {
    if (self.tokenModel) {
        NSString *path = [self basicApiAppend:TJMGetHeatMapData];
        [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *parameters = @{@"day":@(day),@"cityName":cityName};
        [self.httpRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        [self.httpRequestManager GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (TJMRightCode) {
                TJMHeatMapData *data = [TJMHeatMapData mj_objectWithKeyValues:responseObject];
                success(data,TJMResponseMessage);
            } else if ([TJMResponseMessage isEqual:[NSNull null]]) {
                failure(@"未知错误");
            } else {
                failure(TJMResponseMessage);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}

#pragma  mark - 版本更新
- (void)checkVersionSuccess:(SuccessBlock)success fail:(FailBlock)failure {
    if (_tokenModel) {
        NSString *path = [self basicApiAppend:TJMCheckVersion];
        [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *parameters = @{@"type":@"1"};
        [self.httpRequestManager.requestSerializer setValue:_tokenModel.token forHTTPHeaderField:@"Authorization"];
        [_httpRequestManager GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (TJMRightCode) {
                NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                NSString *newVersion = responseObject[@"data"][@"versionName"];
                if ([newVersion isEqualToString:appVersion]) {
                    success(nil,TJMResponseMessage);
                } else {
                    id linkUrl = responseObject[@"data"][@"linkUrl"];
                    //null 判断
                    if ([linkUrl isEqual:[NSNull null]]) {
                        success(nil,TJMResponseMessage);
                    } else {
                        success(linkUrl,TJMResponseMessage);
                    }
                    
                }
            } else if ([TJMResponseMessage isEqual:[NSNull null]]) {
                failure(@"未知错误");
            } else {
                failure(TJMResponseMessage);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error.localizedDescription);
        }];
    }
}


@end
