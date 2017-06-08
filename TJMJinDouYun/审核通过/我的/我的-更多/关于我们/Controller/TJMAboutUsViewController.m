//
//  TJMAboutUsViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/24.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMAboutUsViewController.h"

@interface TJMAboutUsViewController ()
//约束
//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoImageViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoImageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoImageViewBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *versionLabelBottomConstraint;


@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;


@end

@implementation TJMAboutUsViewController
#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"关于我们" fontSize:17 colorHexValue:0x333333];
    [self adjustFonts];
    [self configViews];
    [self resetConstraints];
}

#pragma  mark - 页面设置
- (void)resetConstraints {
    [self tjm_resetVerticalConstraints:self.logoImageViewTopConstraint,self.logoImageViewHeightConstraint,self.logoImageViewBottomConstraint,self.versionLabelBottomConstraint, nil];
}
- (void)adjustFonts {
    [self tjm_adjustFont:14 forView:self.versionLabel,self.introduceLabel, nil];
}
- (void)configViews {
    //设置label 缩进 行间距
    NSString *labelString = self.introduceLabel.text;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:labelString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    CGFloat fontSize = self.introduceLabel.font.pointSize;
    //行间距
    [paragraphStyle setLineSpacing:15 * TJMHeightRatio];
    //第一行头缩进
    [paragraphStyle setFirstLineHeadIndent:fontSize * 2];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, labelString.length)];
    self.introduceLabel.attributedText = attributedStr;
    [self.introduceLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    //获取版本信息
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //当前应用名
    NSString *appCurName = [[[NSBundle mainBundle] infoDictionary]  objectForKey:@"CFBundleDisplayName"];
    self.versionLabel.text = [NSString stringWithFormat:@"%@ V%@",appCurName,version];
    //设置 返回按钮
    [self setBackNaviItem];
    
}

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
