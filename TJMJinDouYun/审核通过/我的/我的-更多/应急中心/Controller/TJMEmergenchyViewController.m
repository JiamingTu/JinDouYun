//
//  TJMEmergenchyViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/24.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMEmergenchyViewController.h"

@interface TJMEmergenchyViewController ()<UIWebViewDelegate>

@end

@implementation TJMEmergenchyViewController
#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"应急中心" fontSize:17 colorHexValue:0x333333];
    [self setBackNaviItem];
}

#pragma  mark - 按钮方法
- (IBAction)callAction:(UIButton *)sender {
    //点击拨打电话
    [TJMHUDHandle showRequestHUDAtView:self.view message:nil];
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:0592-911006"];
    UIWebView *callWebview = [[UIWebView alloc] init];
    callWebview.delegate = self;
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

#pragma  mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [TJMHUDHandle hiddenHUDForView:self.view];
    return YES;
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
