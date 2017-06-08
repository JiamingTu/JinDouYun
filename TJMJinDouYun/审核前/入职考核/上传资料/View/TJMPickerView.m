//
//  TJMPickerView.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/25.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMPickerView.h"
static const CGFloat _pickerViewAnimationTime = 0.25;
@interface TJMPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    CGFloat _pickerViewHeight;
    CGFloat _bgViewHeight;
    CGFloat _toolsViewHeith;
}
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,assign) NSInteger type;

@property (nonatomic,copy) NSArray *firstCompArray;
@property (nonatomic,copy) NSArray *secondCompArray;
@property (nonatomic,copy) NSArray *thirdCompArray;


@property (nonatomic, strong) UIButton *sureButton;        /** 确认按钮 */
@property (nonatomic, strong) UIButton *cancelButton;      /** 取消按钮 */
@property (nonatomic, strong) UIView *toolsView;           /** 自定义标签栏 */
@property (nonatomic, strong) UIView *bgView;              /** 背景view */

@end


@implementation TJMPickerView
#pragma  mark - lazy loading
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, _bgViewHeight)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIPickerView *)pickerView{
    if (!_pickerView) {
        self.pickerView = ({
            UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, _bgViewHeight - _pickerViewHeight, TJMScreenWidth, _pickerViewHeight)];

            pickerView.backgroundColor = [UIColor whiteColor];
            //            [pickerView setShowsSelectionIndicator:YES];
            pickerView.delegate = self;
            pickerView.dataSource = self;
            pickerView;
        });
    }
    return _pickerView;
}

- (UIView *)toolsView{
    
    if (!_toolsView) {
        _toolsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, _toolsViewHeith)];
        _toolsView.layer.borderWidth = 0.5;
        _toolsView.layer.borderColor = [UIColor grayColor].CGColor;
    }
    return _toolsView;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = ({
            UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelButton.frame = CGRectMake(20, 0, 50, _toolsViewHeith);
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            [cancelButton setTitleColor:TJMFUIColorFromRGB(0xffdf22) forState:UIControlStateNormal];
            [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
            cancelButton;
        });
    }
    return _cancelButton;
}

- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = ({
            UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 20 - 50, 0, 50, _toolsViewHeith)];
            [sureButton setTitle:@"确定" forState:UIControlStateNormal];
            [sureButton setTitleColor:TJMFUIColorFromRGB(0xffdf22) forState:UIControlStateNormal];
            [sureButton addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
            sureButton;
        });
    }
    return _sureButton;
}
#pragma  mark - init
- (instancetype)initWithModel:(id)model {
    self = [super init];
    if (self) {
        _pickerViewHeight = 200 * TJMHeightRatio;
        _bgViewHeight = 240 * TJMHeightRatio;
        _toolsViewHeith = 40 * TJMHeightRatio;
        
        [self initDataSourceWithModel:model];
        [self initSubviews];
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.toolsView];
        [self.toolsView addSubview:self.cancelButton];
        [self.toolsView addSubview:self.sureButton];
        [self.bgView addSubview:self.pickerView];
        
    }
    return self;
}

- (void)initSubviews {
    self.frame = CGRectMake(0, 64, TJMScreenWidth, TJMScreenHeight - 64);
    self.backgroundColor = TJMRGBColorAlpha(0, 0, 0, 0.0);
    [self showPickView];
}

- (void)initDataSourceWithModel:(id)model {
    if ([model isKindOfClass:[TJMProvinceData class]]) {
        _type = TJMPickerViewTypeProvince;
        TJMProvinceData *provinceData = (TJMProvinceData *)model;
        //省市区
        self.firstCompArray = provinceData.data;
        self.province = _firstCompArray[0];//设置初始值
        self.secondCompArray = _province.cities;
        self.city = _secondCompArray[0];//设置初始值
        self.thirdCompArray = _city.areas;
        self.area = _thirdCompArray[0];//设置初始值
        
    } else if ([model isKindOfClass:[TJMVehicleData class]]) {
        _type = TJMPickerViewTypeVehicle;
        TJMVehicleData *vehicleData = (TJMVehicleData *)model;
        //交通工具
        self.firstCompArray = vehicleData.data;
        self.vehicle = _firstCompArray[0];//设置初始值
    } else if ([model isKindOfClass:[TJMBankData class]]) {
        _type = TJMPickerViewTypeBank;
        TJMBankData *bankData = (TJMBankData *)model;
        //银行
        self.firstCompArray = bankData.data;
        self.bank = _firstCompArray[0];//设置初始值
        
        
    }
}

#pragma  mark - button action 
- (void)cancelButtonAction {
    [self hidePickView];
    
}

- (void)sureButtonAction {
    [self hidePickView];
    if (self.selectResult) {
        if (_type == TJMPickerViewTypeProvince) {
            self.selectResult(@{@"province":self.province,
                                @"city":self.city,
                                @"area":self.area});
        }  else if (_type == TJMPickerViewTypeVehicle) {
            self.selectResult(@{@"vehicle":self.vehicle});
        } else if (_type == TJMPickerViewTypeBank) {
            self.selectResult(@{@"bank":self.bank});
        }
    }
}

#pragma mark private methods
- (void)showPickView{
    [UIView animateWithDuration:_pickerViewAnimationTime animations:^{
        self.backgroundColor = TJMRGBColorAlpha(0, 0, 0, .5f);
        self.bgView.frame = CGRectMake(0, self.frame.size.height - _bgViewHeight, self.frame.size.width, _bgViewHeight);
    } completion:^(BOOL finished) {
        
    }];
}


- (void)hidePickView{
    
    [UIView animateWithDuration:_pickerViewAnimationTime animations:^{
        
        self.bgView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, _bgViewHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

#pragma  mark - UIPickerViewDataSource,UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (_type == TJMPickerViewTypeProvince) {
        return  3;
    }
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_type == TJMPickerViewTypeProvince) {
        //省市
        if (component == 0) {
            return _firstCompArray.count;
        } else if (component == 1) {
            NSInteger selectZeroComp = [pickerView selectedRowInComponent:component - 1];
            //第x个省份
            TJMProvince *province = _firstCompArray[selectZeroComp];
            //第x个省份的城市s
            self.secondCompArray = province.cities;
            self.city = _secondCompArray[0];
            return _secondCompArray.count;
        } else {
            NSInteger selectFirstComp = [pickerView selectedRowInComponent:component - 1];
            //第x个省份的第x个城市
            TJMCity *city = _secondCompArray[selectFirstComp];
            //第x个省份的第x个城市的区域s
            self.thirdCompArray = city.areas;
            self.area = _thirdCompArray[0];
            return _thirdCompArray.count;
        }
    } else {
        //交通工具或者银行
        return self.firstCompArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (_type == TJMPickerViewTypeProvince) {
        if (component == 0) {
            TJMProvince *province = _firstCompArray[row];
            return province.provinceName;
        } else if (component == 1) {
            TJMCity *city = _secondCompArray[row];
            return city.cityName;
        } else {
            TJMArea *area = _thirdCompArray[row];
            return area.areaName;
        }
    } else if (_type == TJMPickerViewTypeVehicle){
        TJMVehicle *vehicle = _firstCompArray[row];
        return vehicle.toolName;
    } else if (_type == TJMPickerViewTypeBank) {
        TJMBankModel *bank = _firstCompArray[row];
        return bank.bankName;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_type == TJMPickerViewTypeProvince) {
        if (component == 0) {
            self.province = _firstCompArray[row];
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        } else if (component == 1) {
            self.city = _secondCompArray[row];
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        } else {
            self.area = _thirdCompArray[row];
        }
    } else if (_type == TJMPickerViewTypeVehicle) {
        self.vehicle = _firstCompArray[row];
    } else if (_type == TJMPickerViewTypeBank) {
        self.bank = _firstCompArray[row];
    }
}

#pragma  mark - touches began
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if ([touches.anyObject.view isKindOfClass:[self class]]) {
        [self hidePickView];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
