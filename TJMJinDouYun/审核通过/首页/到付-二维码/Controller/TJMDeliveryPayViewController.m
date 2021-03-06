//
//  TJMDeliveryPayViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/17.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMDeliveryPayViewController.h"

@interface TJMDeliveryPayViewController ()<TDAlertViewDelegate>
//约束
//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRCodeImageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRCodeImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRCodeImageBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orLabelBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *helpPayButtonTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *helpPayButtonHeightConstraint;


//水平
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orLabelLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orLabelRightConstraint;

//
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UILabel *canNotPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *helpPayLabel;
@property (weak, nonatomic) IBOutlet UIButton *helpPayButton;


@end
//修改：
//1.签收时取消签收范围判断
@implementation TJMDeliveryPayViewController
#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *title = self.orderModel.orderStatus.integerValue == 7 ? @"商家扫码" : @"支付费用";
    [self setTitle:title fontSize:17 colorHexValue:0x333333];
    [self setBackNaviItem];
    [self configViews];
    //菊花转
    //获取地理位置，判断取货范围
    [TJMHUDHandle showRequestHUDAtView:self.view message:nil];
    //    [[TJMLocationService sharedLocationService] getFreeManLocationWith:TJMGetLocationTypeLocation target:CLLocationCoordinate2DMake(0, 0)];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDidChange:) name:kTJMLocationDidChange object:nil];
    //获取二维码
    [self getQRCode];
}



#pragma  mark - 设置页面
- (void)resetConstraints {
    [self tjm_resetVerticalConstraints:self.QRCodeImageTopConstraint,self.QRCodeImageHeightConstraint,self.QRCodeImageBottomConstraint,self.orLabelBottomConstraint,self.helpPayButtonTopConstraint,self.helpPayButtonHeightConstraint, nil];
    [self tjm_resetHorizontalConstraints:self.orLabelLeftConstraint,self.orLabelRightConstraint, nil];
}
- (void)adjustFonts {
    [self tjm_adjustFont:15 forView:self.orLabel, nil];
    [self tjm_adjustFont:12 forView:self.canNotPayLabel,self.helpPayLabel, nil];
    [self tjm_adjustFont:18 forView:self.helpPayButton, nil];
}
- (void)configViews {
    NSString *buttonTitle = self.orderModel.type == 0 ? @"代 付" : @"拒 收";
    [self.helpPayButton setTitle:buttonTitle forState:UIControlStateNormal];
}
#pragma  mark - 通知
//- (void)locationDidChange:(NSNotification *)notification {
//    if ([notification.userInfo[@"myLocation"] isKindOfClass:[NSString class]]) {
//        //定位失败
//        [self alertViewWithTag:10001 delegate:self title:@"定位失败，请退出重试" cancelItem:nil sureItem:@"确定"];
//        return;
//    }
//    BMKUserLocation *location = notification.userInfo[@"myLocation"];
//    CLLocationCoordinate2D toCoordinate = CLLocationCoordinate2DMake(_orderModel.receiverLat.doubleValue, _orderModel.receiverLng.doubleValue);
//    CLLocationDistance distance = [[TJMLocationService sharedLocationService] calculateDistanceFromMyLocation:location.location.coordinate toGetLocation:toCoordinate];
//    [TJMHUDHandle hiddenHUDForView:self.view];
//    if (distance > 1000) {
//        [self alertViewWithTag:10000 delegate:self title:@"不在签收范围" cancelItem:nil sureItem:@"确定"];
//    } else {
//        //获取二维码
//        [self getQRCode];
//    }
//}

//- (void)alertView:(TDAlertView *)alertView didClickItemWithIndex:(NSInteger)itemIndex {
//    if (alertView.tag == 10000) {
//        if (itemIndex == 0) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
//}

#pragma  mark - 获取到付二维码
- (void)getQRCode {
    if (_orderModel.type == 0) {
        self.orLabel.text = @"或";
        self.canNotPayLabel.text = @"收货人无法使用扫码支付时";
        self.helpPayLabel.text = @"快递员可帮忙代付";
        //到付
        [TJMRequestH getPayOnDeliveryQRCodeTextWithOrderNo:self.orderModel.orderNo success:^(id successObj, NSString *msg) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *image = [UIImage createQRCodeWithCodeText:successObj];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    self.QRCodeImageView.image = image;
                    [TJMHUDHandle hiddenHUDForView:self.view];
                }];
            });
        } fail:^(NSString *failString) {
            [TJMHUDHandle hiddenHUDForView:self.view];
        }];
    } else {
        if (_orderModel.orderStatus.integerValue == 7) {
            self.orLabel.text = @"温馨提示";
            self.canNotPayLabel.text = @"此单已被拒收";
            self.helpPayLabel.text = @"请将二维码提供给商家扫描确认";
            self.helpPayButton.hidden = YES;
            //商家扫描此二维码
            //代收货款拒绝
            [TJMRequestH collectPayRefuseWithOrderNo:_orderModel.orderNo success:^(id successObj, NSString *msg) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString *URLString = successObj;
                    NSURL *URL = [NSURL URLWithString:URLString];
                    NSData *imageData = [NSData dataWithContentsOfURL:URL];
                    UIImage *image = [UIImage imageWithData:imageData];
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        self.QRCodeImageView.image = image;
                        [TJMHUDHandle hiddenHUDForView:self.view];
                    }];
                });
            } fail:^(NSString *failString) {
                
            }];
        }else {
            self.orLabel.text = @"或";
            self.canNotPayLabel.text = @"收货人拒绝收货时，点击拒收";
            self.helpPayLabel.text = @"请谨慎选择";
            [TJMRequestH collectPayWithOrderNo:_orderModel.orderNo success:^(id successObj, NSString *msg) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImage *image = [UIImage createQRCodeWithCodeText:successObj];
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        self.QRCodeImageView.image = image;
                        [TJMHUDHandle hiddenHUDForView:self.view];
                    }];
                });
            } fail:^(NSString *failString) {
                [TJMHUDHandle hiddenHUDForView:self.view];
            }];
        }
        
    }
}

#pragma  mark - 代付按钮
- (IBAction)helpPayAction:(UIButton *)sender {
    [TJMHUDHandle showRequestHUDAtView:self.view message:nil];
    if (self.orderModel.type == 0) {
        [TJMRequestH getHelpPayInfoWithOrderNo:_orderModel.orderNo success:^(id successObj, NSString *msg) {
            PayReq *request = successObj;
            //判断是否安装微信，且微信版本是否支持当前API
            if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
                BOOL result = [WXApi sendReq:request];
                if (!result) {
                    [TJMHUDHandle hiddenHUDForView:self.view];
                }
            } else {
                [TJMHUDHandle hiddenHUDForView:self.view];
                [TJMHUDHandle transientNoticeAtView:self.view withMessage:@"未安装微信或微信版本过低"];
            }
        } fail:^(NSString *failString) {
            [TJMHUDHandle hiddenHUDForView:self.view];
        }];
    } else {
        [self alertViewWithTag:10000 delegate:self title:@"确认收货人拒收？" cancelItem:@"取消" sureItem:@"确认"];
    }
}

- (void)alertView:(TDAlertView *)alertView didClickItemWithIndex:(NSInteger)itemIndex {
    if (alertView.tag == 10000) {
        if (itemIndex == 0) {
            //代收货款拒绝
            [TJMRequestH collectPayRefuseWithOrderNo:_orderModel.orderNo success:^(id successObj, NSString *msg) {
                [TJMRequestH getSingleOrderWithOrderNumber:self.orderModel.orderNo success:^(id successObj, NSString *msg) {
                    TJMOrderModel *model = successObj;
                    _orderModel.orderStatus = model.orderStatus;
                    [self.navigationController popViewControllerAnimated:YES];
                    [TJMHUDHandle hiddenHUDForView:self.view];
                } fail:^(NSString *failString) {
                    
                }];
            } fail:^(NSString *failString) {
                
            }];
        }
    }
}


//#pragma  mark - 进入前台通知
//- (void)enterForeground {
//
//}


#pragma  mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.isViewLoaded && !self.view.window) {
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
