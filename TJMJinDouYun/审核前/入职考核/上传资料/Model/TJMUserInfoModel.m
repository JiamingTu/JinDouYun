//
//  TJMUserInfoModel.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/3.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMUserInfoModel.h"

@implementation TJMUserInfoModel

@end

@implementation TJMUserInfos

- (instancetype)init {
    self = [super init];
    if (self) {
        TJMUserInfoModel * cityModel = [self setInfoWithTitle:@"所在城市" infoText:@"请选择省市区" isTextField:NO inputType:nil];
        TJMUserInfoModel * VehicleModel = [self setInfoWithTitle:@"交通工具" infoText:@"请选择交通工具" isTextField:NO inputType:nil];
        TJMUserInfoModel * nameModel = [self setInfoWithTitle:@"真实姓名" infoText:@"请输入真实姓名" isTextField:YES inputType:@"Chinese"];
        TJMUserInfoModel * idNumModel = [self setInfoWithTitle:@"身份证号" infoText:@"请输入身份证号" isTextField:YES inputType:@"Num"];
        self.infos = @[cityModel,VehicleModel,nameModel,idNumModel];
    }
    return self;
}

- (TJMUserInfoModel *)setInfoWithTitle:(NSString *)title infoText:(NSString *)text isTextField:(BOOL)isTextField inputType:(NSString *)type {
    TJMUserInfoModel *model = [[TJMUserInfoModel alloc]init];
    model.title = title;
    model.isTextField = isTextField;
    model.info = text;
    if (isTextField) {
        model.inputType = type;
    }
    return model;
}

@end
