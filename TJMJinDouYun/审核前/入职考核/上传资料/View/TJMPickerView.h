//
//  TJMPickerView.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/25.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectResult)(NSDictionary *info);


typedef enum : NSUInteger {
    TJMPickerViewTypeVehicle = 1,
    TJMPickerViewTypeBank = 2,
    TJMPickerViewTypeProvince = 3,
} TJMPickerViewType;


@interface TJMPickerView : UIView
- (instancetype)initWithModel:(id)model;
@property (nonatomic,strong) TJMProvince *province;
@property (nonatomic,strong) TJMCity *city;
@property (nonatomic,strong) TJMArea *area;
@property (nonatomic,copy) SelectResult selectResult;

@property (nonatomic,strong) TJMVehicle *vehicle;

@property (nonatomic,strong) TJMBankModel *bank;

@end
