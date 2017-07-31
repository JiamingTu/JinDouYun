//
//  UIViewController+Config.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/28.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonBlock)(UIButton *button);

@interface UIViewController (Config)<TDAlertViewDelegate>

@property (nonatomic,strong) AppDelegate *appDelegate;

- (void)setTitle:(NSString *)title fontSize:(CGFloat)size colorHexValue:(int)value;
//设置导航按钮
- (void)setBackNaviItem;
- (UIButton *)setRightNaviItemWithImageName:(NSString *)imageName orTitle:(NSString *)title titleColorHexValue:(int)value fontSize:(CGFloat)fontSize;
- (void)rightItemAction:(UIButton *)button;
/**设置首页左导航按钮尺寸*/
//- (void)setNaviLeftButtonFrameWithButton:(UIButton *)button;

/**设置视图阴影*/
- (void)setShadowWithView:(UIView *)view shadowColor:(UIColor *)color;
/**alert弹窗*/
- (void)alertViewWithTag:(NSInteger)tag delegate:(id<TDAlertViewDelegate>)delegate title:(NSString *)title cancelItem:(NSString *)cancel sureItem:(NSString *)sure;
/**弹出选择框*/
- (void)showPickerViewWithTableView:(UITableView *)tableView successObj:(id)successObj indexPaht:(NSIndexPath *)indexPath parameters:(NSMutableDictionary *)parameters;
/**得到想要pop到指定界面 的界面*/
- (__kindof UIViewController *)popTargetViewControllerWithViewControllerNumber:(NSInteger)number;
/**调起alert 选择相册或相机*/
- (void)alertSelectImagePickerVCSourceTypeWithImagePickerVC:(UIImagePickerController *)imagePickerVC;

/**删除储存数据*/
- (void)deleteCarrierInfo;
@end
