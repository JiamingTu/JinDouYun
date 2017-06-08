//
//  TJMUploadViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/14.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMUploadViewController.h"
#import "TJMEntryCheckViewController.h"
#import "TJMPickerView.h"
#import "TJMInfoTableViewCell.h"
#import "TJMIdCardTableViewCell.h"
#import "TJMUserInfoModel.h"
@interface TJMUploadViewController ()<UITableViewDelegate,UITableViewDataSource,TJMInfoTableViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIButton *_selectImageButton;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) TJMUserInfos *userInfo;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;
@property (weak, nonatomic) IBOutlet UIButton *userProtocolButton;
//约束
//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkBtnConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkBtnHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commitButtonHeightConstraint;

//水平
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userProtocolConstraint;

//
@property (nonatomic,strong) NSMutableDictionary *form;
@property (nonatomic,strong) NSMutableDictionary *photos;
@property (nonatomic,strong) TJMProvinceData *provinceData;
@property (nonatomic,strong) TJMVehicleData *vehicleData;
@property (nonatomic,strong) TJMTokenModel *tokenModel;
//手势
@property (nonatomic,strong) UITapGestureRecognizer *tap;
//相册
@property (nonatomic,strong) UIImagePickerController *imagePickerVC;
@end

@implementation TJMUploadViewController
#pragma  mark - lazy loading 
- (UIImagePickerController *)imagePickerVC {
    if (!_imagePickerVC) {
        self.imagePickerVC = [[UIImagePickerController alloc] init];
        //该代理需要遵循两个协议
        _imagePickerVC.delegate = self;
        //设置图片的来源
        //        _imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //设置选中的图片是否可编辑
        _imagePickerVC.allowsEditing = YES;
    }
    return _imagePickerVC;
}
- (NSMutableDictionary *)photos {
    if (!_photos) {
        self.photos = [NSMutableDictionary dictionary];
    }
    return _photos;
}
- (NSMutableDictionary *)form {
    if (!_form) {
        self.form = [NSMutableDictionary dictionary];
        [_form setObject:self.tokenModel.userId forKey:@"carrierId"];
    }
    return _form;
}
- (TJMTokenModel *)tokenModel {
    if (!_tokenModel) {
        self.tokenModel = [TJMSandBoxManager getTokenModel];
    }
    return _tokenModel;
}
- (TJMUserInfos *)userInfo {
    if (!_userInfo) {
        self.userInfo = [[TJMUserInfos alloc]initWithInfoType:TJMUserInfoTypeUploadInfo];
    }
    return _userInfo;
}
- (UITapGestureRecognizer *)tap {
    if (!_tap) {
        self.tap = ({
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            tap.numberOfTapsRequired = 1;
            tap.cancelsTouchesInView = NO;
            tap;
        });
    }
    return _tap;
}


#pragma  mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"完善资料" fontSize:17 colorHexValue:0x333333];
    [self adjustFonts];
    [self resetConstraints];
    [self configViews];
}
- (void)dealloc {
    [self.tableView removeGestureRecognizer:self.tap];
}
#pragma  mark - 设置页面
- (void)adjustFonts {
    //设置字体
    [self tjm_adjustFont:12 forView:self.reminderLabel, nil];
    [self tjm_adjustFont:13 forView:self.userProtocolButton, nil];
}
- (void)configViews {
    self.tableView.estimatedRowHeight = 50;
    //添加手势 收起键盘
    [self.tableView addGestureRecognizer:self.tap];
    [self setBackNaviItem];
    
}
- (void)resetConstraints {
    [self tjm_resetVerticalConstraints:self.checkBtnConstraint,self.checkBtnHeightConstraint,self.commitButtonHeightConstraint, nil];
    [self tjm_resetHorizontalConstraints:self.userProtocolConstraint, nil];
}

#pragma  mark - 界面按钮 手势
#pragma  mark 轻拍
- (void)tap:(UIGestureRecognizer *)gesture {
    [self.view endEditing:NO];
}
#pragma  mark - 选择照片
- (IBAction)takePhotoAction:(UIButton *)sender {
    _selectImageButton = sender;
    [self alertSelectImagePickerVCSourceTypeWithImagePickerVC:self.imagePickerVC];
}
#pragma  mark - 提交
- (IBAction)commitAction:(id)sender {
    //
    if (self.form.count == 7 && self.photos.count == 3) {
        NSString *realName = self.form[@"realName"];
        NSString *idCard = self.form[@"idCard"];
        NSString *concact = self.form[@"concact"];
        NSString *concactNum = self.form[@"concactMobile"];
        NSString *noticeString;
        TJMLog(@"%zd----%zd",[realName isChinese],[concact isChinese]);
        if (![realName isChinese] || ![concact isChinese]) {
            //请输入正确的姓名
            noticeString = @"请输入正确的姓名";
        } else {
            if (![idCard judgeIdentityStringValid]) {
                noticeString = @"请输入正确的身份证号";
            } else {
                if (![concactNum isMobileNumber]) {
                    noticeString = @"请输入正确的电话号码";
                } else if ([concactNum isEqualToString:self.freeManInfo.mobile.description]) {
                    noticeString = @"紧急联系人电话不可与账号一致";
                } else {
                    //提交
                    MBProgressHUD *progressHUD = [TJMHUDHandle showRequestHUDAtView:self.view message:@"提交中..."];
                    [TJMRequestH uploadFreeManInfoWithForm:self.form photos:self.photos progress:^(NSProgress *progress) {
                        
                    } success:^(id successObj, NSString *msg) {
                        progressHUD.label.text = msg;
                        [progressHUD hideAnimated:YES afterDelay:1.5];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            TJMEntryCheckViewController *entryCheckVC = [self popTargetViewControllerWithViewControllerNumber:1];
                            //状态修改为 审核中
                            entryCheckVC.freeManInfo.materialStatus = @(1);
                            [self.navigationController popToViewController:entryCheckVC animated:YES];
                        });
                    } fail:^(NSString *failString) {
                        progressHUD.label.text = failString;
                        [progressHUD hideAnimated:YES afterDelay:1.5];
                    }];
                }
            }
        }
        if (noticeString != nil) {
            [TJMHUDHandle transientNoticeAtView:self.view withMessage:noticeString];
        }
    } else {
        //请完善资料
    }
    
}





#pragma  mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    [_selectImageButton setBackgroundImage:image forState:UIControlStateNormal];
    NSString *keyString;
    if (_selectImageButton.tag == 100) keyString = @"frontCardPhoto";
    else if (_selectImageButton.tag == 101) keyString = @"backCardPhoto";
    else keyString = @"personCardPhoto";
    [self.photos setObject:image forKey:keyString];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}



#pragma  mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.userInfo.infos.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TJMInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell" forIndexPath:indexPath];
        [cell setViewInfoWith:self.userInfo.infos[indexPath.row]];
        cell.delegate = self;
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
    if (section == 0) {
        return 10 * TJMHeightRatio;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TJMInfoTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    if (indexPath.section == 0) {
        if (!cell.infoTextField.enabled) {
            [self selectCityOrVehicleWithRow:indexPath];
        }
    }
}

#pragma  mark - 选择城市、交通工具
- (void)selectCityOrVehicleWithRow:(NSIndexPath *)indexPath {
    //如果row == 0 ， 选择城市
    NSString *type = indexPath.row == 0 ? TJMFreeManGetCity : TJMFreeManGetVehicle;
    NSObject *unknowObj = indexPath.row == 0 ? self.provinceData : self.vehicleData;
    //如果对象存在 则不用网络请求
    if (!unknowObj) {
        [TJMRequestH getUploadRelevantInfoWithType:type form:nil success:^(id successObj, NSString *msg) {
            if (indexPath.row == 0) {
                self.provinceData = successObj;
            } else {
                self.vehicleData = successObj;
            }
            [self showPickerViewWithTableView:self.tableView successObj:successObj indexPaht:indexPath parameters:self.form];
        } fail:^(NSString *failString) {
            
        }];
    } else {
        [self showPickerViewWithTableView:self.tableView successObj:unknowObj indexPaht:indexPath parameters:self.form];
    }
}



#pragma  mark - cell delegate 传回填写的信息
- (void)getInfoValue:(NSString *)value cell:(TJMInfoTableViewCell *)cell {
    [self.form setObject:value forKey:cell.inputType];
    TJMLog(@"%@",self.form);
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
