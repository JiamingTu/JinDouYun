//
//  TJMFeedBackViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/25.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMFeedBackViewController.h"

@interface TJMFeedBackViewController ()<UITextViewDelegate>
//约束
//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *placeholderLabelTopConstraint;


@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@property (nonatomic,copy) NSString *phoneNum;

@property (nonatomic,strong) MBProgressHUD *progressHUD;

@end

@implementation TJMFeedBackViewController
#pragma  mark - lazy loading

#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"问题反馈" fontSize:17 colorHexValue:0x333333];
    [self adjustFonts];
    [self configViews];
    [self resetConstraints];
    //
    self.progressHUD = [TJMHUDHandle showRequestHUDAtView:self.view message:nil];
    [self.appDelegate getFreeManInfoWithViewController:self fail:^(NSString *failMsg) {
        _progressHUD.label.text = failMsg;
        [_progressHUD hideAnimated:YES afterDelay:1.5];
    }];
    
}
- (void)dealloc {
    [self.appDelegate removeFreeManInfoWithViewController:self];
}
#pragma  mark - 设置页面
- (void)resetConstraints {
    [self tjm_resetVerticalConstraints:self.textViewHeightConstraint,self.placeholderLabelTopConstraint, nil];
}
- (void)adjustFonts {
    [self tjm_adjustFont:14 forView:self.textView,self.placeholderLabel, nil];
}
- (void)configViews {
    self.textView.textContainerInset = UIEdgeInsetsMake(15 * TJMHeightRatio, 10 *TJMWidthRatio, 0, 10 *TJMWidthRatio);
    //提交按钮
    [self setRightNaviItemWithImageName:nil orTitle:@"提交" titleColorHexValue:0x3333333 fontSize:15];
    //返回按钮
    [self setBackNaviItem];
}
#pragma  mark - 按钮绑定
- (void)rightItemAction:(UIButton *)button {
    if (self.textView.text.length != 0) {
        MBProgressHUD *progressHUD = [TJMHUDHandle showRequestHUDAtView:self.view message:@"请稍后"];
        [TJMRequestH feedBackQuestionWithContent:self.textView.text phoneNum:self.phoneNum success:^(id successObj, NSString *msg) {
            progressHUD.label.text = msg;
            [progressHUD hideAnimated:YES afterDelay:2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } fail:^(NSString *failString) {
            progressHUD.label.text = failString;
            [progressHUD hideAnimated:YES afterDelay:2];
        }];
    }
}
#pragma  mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
}
#pragma  mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kKVOFreeManInfo]) {
        TJMFreeManInfo *model = change[@"new"];
        self.phoneNum = model.mobile.description;
        [_progressHUD hideAnimated:YES];
    }
}
#pragma  mark - momory warning
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
