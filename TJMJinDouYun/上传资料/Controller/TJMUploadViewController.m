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
//    [TJMRRequestH getUploadRelevantInfoWithType:TJMFreeManGetCity form:nil success:^(id successObj) {
//        
//    } fail:^(NSString *failString) {
//        
//    }];
    
    UIImage *image1 = [UIImage imageNamed:@"11111"];
    UIImage *image2 = [UIImage imageNamed:@"22222"];
    UIImage *image3 = [UIImage imageNamed:@"33333"];
    UIImage *image4 = [UIImage imageNamed:@"44444"];
    NSDictionary *photos = @{@"photo":image1,@"personCardPhoto":image2,@"frontCardPhoto":image3,@"backCardPhoto":image4};
    
    NSDictionary *form = @{@"realName":@"小样",
                           @"idCard":@"350481199011200011",
                           @"concact":@"大样",
                           @"concactMobile":@"13345678901",
                           @"areaId":@(3),
                           @"toolId":@(1),
                           @"carrierId":@(3)};
    
//    [TJMRRequestH uploadFreeManInfoWithForm:form photos:photos success:^(id successObj) {
//        
//    } fail:^(NSString *failString) {
//        
//    }];
    
    //获取自由人资料
//    [TJMRRequestH getUploadRelevantInfoWithType:TJMFreeManGetInfo(@"3") form:nil success:^(id successObj) {
//    
//    } fail:^(NSString *failString) {
//        
//    }];
    
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
