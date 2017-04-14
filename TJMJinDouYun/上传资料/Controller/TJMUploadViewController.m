//
//  TJMUploadViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/14.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMUploadViewController.h"

@interface TJMUploadViewController ()

@end

@implementation TJMUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [TJMRRequestH getUploadRelevantInfoWithType:TJMFreeManGetCityApi form:nil success:^(id successObj) {
        
    } fail:^(NSString *failString) {
        
    }];
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
