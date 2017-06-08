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

- (instancetype)initWithInfoType:(TJMUserInfosType)type {
    self = [super init];
    if (self) {
        if (type == TJMUserInfoTypeUploadInfo) {
            TJMUserInfoModel * cityModel = [self setInfoWithTitle:@"所在城市" infoText:@"请选择省市区" isTextField:NO inputType:@"areaId"];
            TJMUserInfoModel * VehicleModel = [self setInfoWithTitle:@"交通工具" infoText:@"请选择交通工具" isTextField:NO inputType:@"toolId"];
            TJMUserInfoModel * nameModel = [self setInfoWithTitle:@"真实姓名" infoText:@"请输入真实姓名" isTextField:YES inputType:@"realName"];
            TJMUserInfoModel * idNumModel = [self setInfoWithTitle:@"身份证号" infoText:@"请输入身份证号" isTextField:YES inputType:@"idCard"];
            TJMUserInfoModel * emergencyContact = [self setInfoWithTitle:@"紧急联系人" infoText:@"紧急联系人姓名" isTextField:YES inputType:@"concact"];
            TJMUserInfoModel * emergencyNum = [self setInfoWithTitle:@"紧急联系人电话" infoText:@"请输入电话号码" isTextField:YES inputType:@"concactMobile"];
            self.infos = @[cityModel,VehicleModel,nameModel,idNumModel,emergencyContact,emergencyNum];
        } else {
            TJMUserInfoModel *bankNameModel = [self setInfoWithTitle:@"开户银行" infoText:@"请输入银行名称" isTextField:NO inputType:@"bankId"];
            TJMUserInfoModel *userNameModel = [self setInfoWithTitle:@"持卡人姓名" infoText:@"请输入持卡人姓名" isTextField:YES inputType:@"realname"];
            TJMUserInfoModel *bankNumModel = [self setInfoWithTitle:@"银行卡卡号" infoText:@"请输入银行卡卡号" isTextField:YES inputType:@"bankcard"];
            self.infos = @[bankNameModel,userNameModel,bankNumModel];
        }
        
    }
    return self;
}

- (TJMUserInfoModel *)setInfoWithTitle:(NSString *)title infoText:(NSString *)text isTextField:(BOOL)isTextField inputType:(NSString *)type {
    TJMUserInfoModel *model = [[TJMUserInfoModel alloc]init];
    model.title = title;
    model.isTextField = isTextField;
    model.info = text;
    model.inputType = type;
    return model;
}

@end
