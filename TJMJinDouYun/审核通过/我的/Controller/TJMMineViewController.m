//
//  TJMMineViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/27.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMMineViewController.h"
#import "TJMMineTableViewCell.h"
#import "TJMMyWalletViewController.h"
@interface TJMMineViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *settingView;
@property (weak, nonatomic) IBOutlet UIView *naviBgView;

//约束
//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneNumLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneNumLabelBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *evaluateValueLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *evaluateValuLabelBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *evaluateLabelBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstSectionHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondSectionHeightConstraint;


//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myOrderImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myWalletImageHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emergencyImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aboutOursImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingImageHeightConstraint;
//不计算
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviBgViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviBgViewTopConstraint;


//水平
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myOrderConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myWalletConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emergencyCenterConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aboutOursConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingConstraint;
//导航背景宽
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviBgWidthConstraint;


@property (nonatomic,strong) TJMPerformanceModel *performanceModel;

//菊花
@property (nonatomic,strong) MBProgressHUD *progressHUD;
@end

@implementation TJMMineViewController
#pragma  mark - lazy loading
- (TJMPerformanceModel *)performanceModel {
    if (!_performanceModel) {
        id unknownObj = [TJMSandBoxManager getModelFromInfoPlistWithKey:kTJMPerformanceInfo];
        if (![unknownObj isEqual:[NSNull null]] || !unknownObj) {
            self.performanceModel = unknownObj;
        }
    }
    return _performanceModel;
}

#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"我的" fontSize:17 colorHexValue:0x333333];
    self.naviBgView.backgroundColor = [UIColor whiteColor];
    
    [self adjustFonts];
    [self resetConstraints];
    [self congfigViews];
    
    if (self.performanceModel) {
        self.evaluateValueLabel.text = _performanceModel.starCount;
        self.totalOrderNumLabel.text = _performanceModel.orderCount;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //获取个人信息并监听
    self.progressHUD = [TJMHUDHandle showRequestHUDAtView:self.view message:nil];
    [self.appDelegate getFreeManInfoWithViewController:self fail:^(NSString *failMsg) {
        _progressHUD.label.text = failMsg;
        [_progressHUD hideAnimated:YES afterDelay:1.5];
    }];
    
    self.naviBgWidthConstraint.constant = TJMScreenWidth;
    self.navBarBgAlpha = @"0.0";
    [self.navigationController.navigationBar tjm_hideShadowImageOrNot:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //移除个人信息的监听
    [self.appDelegate removeFreeManInfoWithViewController:self];
    [UIView animateWithDuration:0.35 animations:^{
        self.naviBgWidthConstraint.constant = 0;
        [self.navigationController.navigationBar tjm_hideShadowImageOrNot:NO];
    }];
    self.navBarBgAlpha = @"1.0";
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.naviBgWidthConstraint.constant = TJMScreenWidth;
    CGFloat expectedValue = CGRectGetMaxY(self.settingView.frame) + 40 * TJMHeightRatio;
    CGFloat minValue = TJMScreenHeight - 64 - 49 + 1;
    self.scrollViewContentHeightConstraint.constant = expectedValue > minValue ? expectedValue : minValue;
    //设置头像圆角
    CGFloat height = self.headerButton.frame.size.height;
    self.headerButton.layer.cornerRadius = height / 2;
    self.headerButton.layer.masksToBounds = YES;
}
#pragma  mark - 设置页面
- (void)resetConstraints {
    [self tjm_resetVerticalConstraints:self.headerImageTopConstraint,self.headerImageHeightConstraint,self.headerImageBottomConstraint,self.nameLabelHeightConstraint,self.nameLabelHeightConstraint,self.phoneNumLabelBottomConstraint,self.phoneNumLabelHeightConstraint,self.evaluateValueLabelTopConstraint,self.evaluateValuLabelBottomConstraint,self.evaluateLabelBottomConstraint,self.cellHeightConstraint,self.myOrderImageHeightConstraint,self.myWalletImageHeightConstraint,self.emergencyImageHeightConstraint,self.aboutOursImageHeightConstraint,self.settingImageHeightConstraint,self.firstSectionHeightConstraint,self.secondSectionHeightConstraint, nil];
    [self tjm_resetHorizontalConstraints:self.myOrderConstraint,self.myWalletConstraint,self.emergencyCenterConstraint,self.aboutOursConstraint,self.settingConstraint, nil];
}
- (void)adjustFonts {
    [self tjm_adjustFont:16 forView:self.nameLabel, nil];
    [self tjm_adjustFont:13 forView:self.phoneNumLabel, nil];
    [self tjm_adjustFont:20 forView:self.evaluateValueLabel,self.totalOrderNumLabel, nil];
    [self tjm_adjustFont:15 forView:self.myWalletLabel,self.emergencyLabel,self.aboutOursLabel,self.settingLabel, nil];
    [self tjm_adjustFont:14 forView:self.evaluateLabel,self.totalOrderLabel,self.myOrderLabel, nil];
}
- (void)congfigViews {
    
    
}
#pragma  mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.naviBgViewHeightConstraint.constant = 64 - scrollView.contentOffset.y;
    self.naviBgViewTopConstraint.constant = -64 + scrollView.contentOffset.y;

}
#pragma  mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kKVOFreeManInfo]) {
        TJMFreeManInfo *freeManInfo = change[@"new"];
        if (![freeManInfo isEqual:[NSNull null]] && freeManInfo != nil) {
            //头像
            if (freeManInfo.photo != nil) {
                NSString *path = [NSString stringWithFormat:@"%@%@",TJMPhotoBasicAddress,freeManInfo.photo];
                [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:path] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    image = [image getCropImage];
                    
                    [self.headerButton setBackgroundImage:image ? image : [UIImage imageNamed:@"image"] forState:UIControlStateNormal];
                }];
            }
            //
            self.nameLabel.text = freeManInfo.realName;
            self.phoneNumLabel.text = freeManInfo.mobile.description;
            //获取评价、成交单数
            [TJMRequestH getFreeManPerformanceSuccess:^(id successObj, NSString *msg) {
                self.performanceModel = successObj;
                if (self.performanceModel) {
                    NSString *starCount = _performanceModel.starCount;
                    if (![starCount containsString:@"."]) {
                        starCount = [NSString stringWithFormat:@"%@.0",starCount];
                    }
                    self.evaluateValueLabel.text = starCount;
                    self.totalOrderNumLabel.text = _performanceModel.orderCount;
                }
                [TJMHUDHandle hiddenHUDForView:self.view];
            } fail:^(NSString *failString) {
                _progressHUD.label.text = failString;
                [_progressHUD hideAnimated:YES afterDelay:1.3];
            }];
        }
    }
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
    if ([segue.identifier isEqualToString:@"MyWallet"]) {
        //我的钱包，得到余额
    }
}


@end
