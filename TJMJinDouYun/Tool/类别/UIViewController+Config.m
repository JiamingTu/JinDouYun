//
//  UIViewController+Config.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/28.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "UIViewController+Config.h"
#import "TJMInfoTableViewCell.h"
#import "TJMPickerView.h"
const char *kTJMAppDelegateKey = "AppDelegateKey";
@implementation UIViewController (Config)
#pragma  mark 增加AppDelegate 属性
- (void)setAppDelegate:(AppDelegate *)appDelegate {
    objc_setAssociatedObject(self, kTJMAppDelegateKey, appDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (AppDelegate *)appDelegate {
    self.appDelegate = TJMAppDelegate;
    return objc_getAssociatedObject(self, kTJMAppDelegateKey);
}


- (void)setTitle:(NSString *)title fontSize:(CGFloat)size colorHexValue:(int)value {
    self.title = title;
    UIFont *font = [UIFont systemFontOfSize:size];
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSForegroundColorAttributeName:TJMFUIColorFromRGB(value)};
    self.navigationController.navigationBar.titleTextAttributes = dic;
}




#pragma  mark - 设置导航左右按钮(返回)
- (void)setBackNaviItem {
    UIImage *itemImage = [UIImage imageNamed:@"nav_btn_back"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (itemImage) {
        [button setBackgroundImage:itemImage forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, itemImage.size.width * TJMHeightRatio, itemImage.size.height * TJMHeightRatio);
    }
    [button addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
}
- (void)itemAction:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  mark 设置右导航按钮
- (UIButton *)setRightNaviItemWithImageName:(NSString *)imageName orTitle:(NSString *)title titleColorHexValue:(int)value fontSize:(CGFloat)fontSize {
    UIImage *itemImage = [UIImage imageNamed:imageName];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (itemImage) {
        [button setBackgroundImage:itemImage forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, itemImage.size.width * TJMHeightRatio, itemImage.size.height * TJMHeightRatio);
    } else {
        [button setTitle:title forState:UIControlStateNormal];
        UIFont *font = [UIFont systemFontOfSize:15];
        button.frame = CGRectMake(0, 0, font.pointSize * title.length + 2, font.pointSize + 2);
        button.titleLabel.font = font;
        [button setTitleColor:TJMFUIColorFromRGB(value) forState:UIControlStateNormal];
    }

    [button addTarget:self action:@selector(rightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    return button;
}
- (void)rightItemAction:(UIButton *)button {
    
}

#pragma  mark 设置左导航按钮尺寸(首页左导航)
- (void)setNaviLeftButtonFrameWithButton:(UIButton *)button {
    CGFloat titleLabelInset = 10.5 * TJMWidthRatio;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -titleLabelInset, 0, titleLabelInset);
    //字的宽度 字体长度 * 字体尺寸 + （图片宽度 + UI偏移量 - titleLabel偏移量）* 比例系数
    CGFloat imageInset = button.currentTitle.length * button.titleLabel.font.pointSize + (button.currentImage.size.width + 6.5 - titleLabelInset) * TJMWidthRatio;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, imageInset, 0, -imageInset);
    CGFloat width = button.currentImage.size.width + button.currentTitle.length * button.titleLabel.font.pointSize + 6.5 * TJMWidthRatio;
    CGFloat height = button.titleLabel.font.pointSize + 2;
    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, width, height);
}



#pragma  mark - 设置阴影
- (void)setShadowWithView:(UIView *)view shadowColor:(UIColor *)color {
    //设置阴影
    view.layer.shadowColor = color.CGColor;
    view.layer.shadowOpacity = 0.3;
    //路径阴影
    float width = view.bounds.size.width;
    float height = view.bounds.size.height;
    float x = view.bounds.origin.x;
    float y = view.bounds.origin.y;
    float addWH = 8 * TJMHeightRatio;
    
    UIBezierPath* aPath = [UIBezierPath bezierPathWithRect:CGRectMake(x, y + height - 3, width, addWH)];
    //设置阴影路径
    view.layer.shadowPath = aPath.CGPath;
}

#pragma  mark - 弹窗提示
- (void)alertViewWithTag:(NSInteger)tag delegate:(id<TDAlertViewDelegate>)delegate title:(NSString *)title cancelItem:(NSString *)cancel sureItem:(NSString *)sure {
    TDAlertItem *sureItem = [[TDAlertItem alloc]initWithTitle:sure titleColor:TJMFUIColorFromRGB(0x666666)];
    TDAlertItem *cancelItem = [[TDAlertItem alloc]initWithTitle:cancel titleColor:TJMFUIColorFromRGB(0xffdf22)];
    NSArray *items = nil;
    if (cancel == nil) {
        items = @[sureItem];
    } else if (sure == nil) {
        items = @[cancelItem];
    } else {
        items = @[sureItem,cancelItem];
    }
    TDAlertView *alertView = [[TDAlertView alloc]initWithTitle:title message:nil items:items delegate:delegate];
    alertView.tag = tag;
    alertView.alertWidth = 280 * TJMHeightRatio;
    alertView.optionsRowHeight = 45 * TJMHeightRatio;
    [alertView show];
}

#pragma  mark - 选择框弹出
- (void)showPickerViewWithTableView:(UITableView *)tableView successObj:(id)successObj indexPaht:(NSIndexPath *)indexPath parameters:(NSMutableDictionary *)parameters {
    //显示 pickView
    TJMPickerView *pickerView = [[TJMPickerView alloc]initWithModel:successObj];
    [self.view addSubview:pickerView];
    //获取当前cell
    TJMInfoTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //pickerView 的回调
    pickerView.selectResult = ^(NSDictionary *info){
        //判断cell的inputType 根据对象做不同操作
        if ([cell.inputType isEqualToString:@"areaId"]) {
            //得到选择的对象
            TJMProvince *province   = info[@"province"];
            TJMCity *city           = info[@"city"];
            TJMArea *area           = info[@"area"];
            cell.infoTextField.text = [NSString stringWithFormat:@"%@-%@-%@",province.provinceName,city.cityName,area.areaName];
            [parameters setObject:area.areaId forKey:cell.inputType];
        } else if([cell.inputType isEqualToString:@"toolId"]) {
            TJMVehicle *vehicle = info[@"vehicle"];
            cell.infoTextField.text = vehicle.toolName;
            [parameters setObject:vehicle.toolId forKey:cell.inputType];
        } else if ([cell.inputType isEqualToString:@"bankId"]) {
            //得到选择的对象
            TJMBankModel *bankModel = info[@"bank"];
            cell.infoTextField.text = bankModel.bankName;
            [parameters setObject:bankModel.bankId forKey:cell.inputType];
        }
    };
}

#pragma  mark - pop到指定界面的界面
- (__kindof UIViewController *)popTargetViewControllerWithViewControllerNumber:(NSInteger)number {
    
    NSArray *viewControllerArray = self.navigationController.viewControllers;
    if (viewControllerArray.count != 0 && viewControllerArray.count >= number + 1) {
        UIViewController *VC = viewControllerArray[viewControllerArray.count - number - 1];

        return VC;
    }
    return nil;
}

#pragma - mark alert 调起相机 相册
- (void)alertSelectImagePickerVCSourceTypeWithImagePickerVC:(UIImagePickerController *)imagePickerVC {
    // 创建一个警告控制器
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选取图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 设置警告响应事件
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 设置照片来源为相机
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        
        // 展示选取照片控制器
        [self presentViewController:imagePickerVC animated:YES completion:^{}];
    }];
    
    UIAlertAction *photosAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerVC animated:YES completion:^{}];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // 添加警告按钮
        [alert addAction:cameraAction];
    }
    [alert addAction:photosAction];
    [alert addAction:cancelAction];
    // 展示警告控制器
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)deleteCarrierInfo {
    //退出登录
    TJMRequestH.tokenModel = nil;
    self.appDelegate.personInfo = nil;
    [[SDWebImageManager sharedManager].imageCache clearDiskOnCompletion:nil];
    [TJMSandBoxManager deleteTokenModel];
    [TJMSandBoxManager deleteModelFromInfoPlistWithKey:kTJMFreeManInfo];
    [TJMSandBoxManager deleteModelFromInfoPlistWithKey:kTJMPersonInfo];
    [TJMSandBoxManager deleteModelFromInfoPlistWithKey:kTJMPerformanceInfo];
    [TJMSandBoxManager deleteModelFromInfoPlistWithKey:kTJMIsChangePersonInfo];
    [TJMSandBoxManager deleteMessages];
    [self.appDelegate setAlias];//清空别名
}

@end
