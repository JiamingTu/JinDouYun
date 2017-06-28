//
//  TJMQRCodeSingInViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/17.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMQRCodeSingInViewController.h"
#import "TJMCodeSignInViewController.h"
@interface TJMQRCodeSingInViewController ()<TDAlertViewDelegate>
//约束
//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRCodeImageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRCodeImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRCodeImageBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weiChatImageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weiChatImageHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkImageBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanImageHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewBottomConstraint;

//水平
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signInStepLabelLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signInStepLabelRightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weiChatImageLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weiChatImageRightConstraint;
//视图
@property (weak, nonatomic) IBOutlet UILabel *signInStepLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkLabel;
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;
@property (weak, nonatomic) IBOutlet UILabel *openWeiChatLabel;
@property (weak, nonatomic) IBOutlet UILabel *openScanLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanLabel;

@property (weak, nonatomic) IBOutlet UILabel *remindMsgCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *msgCodeButton;




@end

@implementation TJMQRCodeSingInViewController
#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"扫码签收" fontSize:17 colorHexValue:0x333333];
    [self adjustFonts];
    [self configViews];
    [self resetConstraints];
    //获取地理位置，判断取货范围
    [[TJMLocationService sharedLocationService] getFreeManLocationWith:TJMGetLocationTypeLocation target:CLLocationCoordinate2DMake(0, 0)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDidChange:) name:kTJMLocationDidChange object:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:0.35 animations:^{
        self.navBarBgAlpha = @"0.0";
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"1.0";
}
#pragma  mark - 设置页面
- (void)resetConstraints {
    [self tjm_resetVerticalConstraints:self.QRCodeImageTopConstraint,self.QRCodeImageBottomConstraint,self.QRCodeImageHeightConstraint,self.weiChatImageTopConstraint,self.weiChatImageHeightConstraint,self.checkImageHeightConstraint,self.checkImageBottomConstraint,self.scanImageHeightConstraint,self.lineViewTopConstraint,self.lineViewBottomConstraint, nil];
}
- (void)adjustFonts {
    [self tjm_adjustFont:15 forView:self.signInStepLabel, nil];
    [self tjm_adjustFont:12 forView:self.checkLabel,self.remindLabel,self.openWeiChatLabel,self.openScanLabel,self.scanLabel, nil];
    [self tjm_adjustFont:14 forView:self.remindMsgCodeLabel,self.msgCodeButton, nil];
}
- (void)configViews {
    //设置返回按钮
    [self setBackNaviItem];
}

#pragma  mark - 通知
- (void)locationDidChange:(NSNotification *)notification {
    BMKUserLocation *location = notification.userInfo[@"myLocation"];
    CLLocationCoordinate2D toCoordinate = CLLocationCoordinate2DMake(_orderModel.receiverLat.doubleValue, _orderModel.receiverLng.doubleValue);
    CLLocationDistance distance = [[TJMLocationService sharedLocationService] calculateDistanceFromMyLocation:location.location.coordinate toGetLocation:toCoordinate];
    if (distance > 1000) {
        [self alertViewWithTag:1000 delegate:self title:@"不在签收范围" cancelItem:nil sureItem:@"确定"];
    } else {
        //获取二维码
        [self getQRCode];
    }
}

- (void)alertView:(TDAlertView *)alertView didClickItemWithIndex:(NSInteger)itemIndex {
    if (itemIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma  mark - 获取二维码
- (void)getQRCode {
    //请求 ->菊花 ->得到二维码字符串 ->菊花消失 ->跳转
    [TJMHUDHandle showRequestHUDAtView:self.view message:nil];
    [TJMRequestH getQRCodeTextWithOrderId:self.orderModel.orderId success:^(id successObj, NSString *msg) {
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
        [TJMHUDHandle hiddenHUDForView:self.view];
    }];
}


#pragma  mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.isViewLoaded && !self.view.window) {
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"MsgCodeSignIn"]) {
        TJMCodeSignInViewController *codeSignInVC = segue.destinationViewController;
        codeSignInVC.navBarBgAlpha = @"0.0";
        codeSignInVC.orderModel = self.orderModel;
    }
}


@end
