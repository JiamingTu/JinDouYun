//
//  TJMServiceSignInViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/8/3.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMServiceSignInViewController.h"

@interface TJMServiceSignInViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *placeholderLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commitButtonHeightConstraint;


@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@end

@implementation TJMServiceSignInViewController
#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"客服签收" fontSize:17 colorHexValue:0x333333];
    [self setBackNaviItem];
    [self resetConstraints];
    [self adjustFonts];
    [self configViews];
}

#pragma mark - 页面设置
- (void)resetConstraints {
    [self tjm_resetVerticalConstraints:self.placeholderLabelTopConstraint,self.textViewHeightConstraint,self.commitButtonHeightConstraint, nil];
}
- (void)adjustFonts {
    [self tjm_adjustFont:14 forView:self.placeholderLabel,self.textView, nil];
}
- (void)configViews {
    self.textView.textContainerInset = UIEdgeInsetsMake(15 * TJMHeightRatio, 10 *TJMWidthRatio, 0, 10 *TJMWidthRatio);
}

#pragma  mark - 按钮方法
#pragma  mark 提交提交按钮
- (IBAction)commitAction:(UIButton *)sender {
    if (_textView.text != nil ) {
        NSString *string = _textView.text;
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (![string isEqualToString: @""]) {
            //提交请求
            [self commitUnusualOrderWithMessage:_textView.text];
        } else {
            [TJMHUDHandle transientNoticeAtView:self.view withMessage:@"请输入异常签收原因，以便客服处理"];
        }
    } else {
        [TJMHUDHandle transientNoticeAtView:self.view withMessage:@"请输入异常签收原因，以便客服处理"];
    }
}

- (void)commitUnusualOrderWithMessage:(NSString *)message {
    MBProgressHUD *progressHUD = [TJMHUDHandle showRequestHUDAtView:self.view message:nil];
    [TJMRequestH commitUnusualOrderWithMessage:message orderNo:self.orderModel.orderNo success:^(id successObj, NSString *msg) {
        progressHUD.label.text = msg;
        
        [TJMRequestH getSingleOrderWithOrderNumber:self.orderModel.orderNo success:^(id successObj, NSString *msg) {
            TJMOrderModel *newOrderModel = successObj;
            self.orderModel.orderStatus = newOrderModel.orderStatus;
            [progressHUD hideAnimated:YES afterDelay:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIViewController *VC = [self popTargetViewControllerWithViewControllerNumber:2];
                [self.navigationController popToViewController:VC animated:YES];
            });
        } fail:^(NSString *failString) {
            progressHUD.label.text = @"获取订单状态失败，请返回并刷新列表";
            [progressHUD hideAnimated:YES afterDelay:1.5];
        }];
    } fail:^(NSString *failString) {
        progressHUD.label.text = failString;
        [progressHUD hideAnimated:YES afterDelay:1.5];
    }];
}

#pragma  mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
}
#pragma  mark - touch 
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma  mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
