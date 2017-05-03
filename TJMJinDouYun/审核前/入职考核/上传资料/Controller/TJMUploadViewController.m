//
//  TJMUploadViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/14.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMUploadViewController.h"
#import "TJMPickerView.h"
#import "TJMInfoTableViewCell.h"
#import "TJMIdCardTableViewCell.h"
#import "TJMUserInfoModel.h"
@interface TJMUploadViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TJMPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) TJMUserInfos *userInfo;


@end

@implementation TJMUploadViewController
#pragma  mark - lazy loading 
- (TJMPickerView *)pickerView {
    if (!_pickerView) {
        self.pickerView = [[TJMPickerView alloc]init];
    }
    return _pickerView;
}
- (TJMUserInfos *)userInfo {
    if (!_userInfo) {
        self.userInfo = [[TJMUserInfos alloc]init];
    }
    return _userInfo;
}
#pragma  mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [TJMRequestH getUploadRelevantInfoWithType:TJMFreeManGetCity form:nil success:^(id successObj) {
//        
//    } fail:^(NSString *failString) {
//        
//    }];
    
//    UIImage *image1 = [UIImage imageNamed:@"11111"];
//    UIImage *image2 = [UIImage imageNamed:@"22222"];
//    UIImage *image3 = [UIImage imageNamed:@"33333"];
//    UIImage *image4 = [UIImage imageNamed:@"44444"];
//    NSDictionary *photos = @{@"photo":image1,@"personCardPhoto":image2,@"frontCardPhoto":image3,@"backCardPhoto":image4};
    
    NSDictionary *form = @{@"realName":@"小样",
                           @"idCard":@"350481199011200011",
                           @"concact":@"大样",
                           @"concactMobile":@"13345678901",
                           @"areaId":@(3),
                           @"toolId":@(1),
                           @"carrierId":@(3)};
    
//    [TJMRequestH uploadFreeManInfoWithForm:form photos:photos success:^(id successObj) {
//        
//    } fail:^(NSString *failString) {
//        
//    }];
    
    //获取自由人资料
//    [TJMRequestH getUploadRelevantInfoWithType:TJMFreeManGetInfo(@"3") form:nil success:^(id successObj) {
//    
//    } fail:^(NSString *failString) {
//        
//    }];
//    [self.view addSubview:self.pickerView];
    self.tableView.estimatedRowHeight = 50;
    
}
#pragma  mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TJMInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell" forIndexPath:indexPath];
        [cell setViewInfoWith:self.userInfo.infos[indexPath.row]];
        return cell;
    } else {
        TJMIdCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IdCardCell" forIndexPath:indexPath];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10 * TJMHeightRatio;
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
