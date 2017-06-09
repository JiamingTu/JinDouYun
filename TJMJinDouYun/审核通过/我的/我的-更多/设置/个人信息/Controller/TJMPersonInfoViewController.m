//
//  TJMPersonInfoViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/24.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMPersonInfoViewController.h"
#import "TJMPersonInfoTableViewCell.h"

@interface TJMPersonInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UIImagePickerController *imagePickerVC;

@property (nonatomic,strong) UIImageView *headerImageView;
@property (nonatomic,copy) NSArray *titleArray;
@property (nonatomic,copy) NSArray<NSString *> *keyArray;
@property (nonatomic,strong) NSMutableDictionary *valueDict;
@end

@implementation TJMPersonInfoViewController
#pragma  mark - lazy loading
- (NSArray *)titleArray {
    if (!_titleArray) {
        self.titleArray = @[@"我的头像",@"手机号",@"真实姓名",@"身份证号",@"自由人认证"];
    }
    return _titleArray;
}
- (NSArray *)keyArray {
    if (!_keyArray) {
        self.keyArray = @[@"photo",@"tel",@"realName",@"idCard",@"status"];
    }
    return _keyArray;
}
- (NSMutableDictionary *)valueDict {
    if (!_valueDict) {
        if (self.personInfo != nil) {
            self.valueDict = [NSMutableDictionary dictionary];
            [self setValueDictionaryWithPersonInfoModel:self.personInfo];
        } else {
            self.valueDict = [NSMutableDictionary dictionary];
        }
    }
    return _valueDict;
}
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

#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"个人信息" fontSize:17 colorHexValue:0x333333];
    [self setBackNaviItem];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    MBProgressHUD *progressHUD = [TJMHUDHandle showRequestHUDAtView:self.view message:nil];
    [TJMRequestH getPersonInfoSuccess:^(id successObj, NSString *msg) {
        self.personInfo = (TJMPersonInfoModel *)successObj;
        [self setValueDictionaryWithPersonInfoModel:self.personInfo];
        [self.tableView reloadData];
        [TJMHUDHandle hiddenHUDForView:self.view];
    } fail:^(NSString *failString) {
        progressHUD.label.text = failString;
        [progressHUD hideAnimated:YES afterDelay:1.5];
    }];

}
#pragma  mark - 根据model 完成DataSourceDict（valueDict）
- (void)setValueDictionaryWithPersonInfoModel:(TJMPersonInfoModel *)model {
    //先移除
    [self.valueDict removeAllObjects];
    //再添加
    [self.keyArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *valueString = [model valueForKey:obj];
        if (valueString) {
            [self.valueDict setObject:valueString forKey:obj];
        }
    }];

    
}
#pragma  mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titleArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TJMPersonInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    NSString *key = self.keyArray[indexPath.row];
    NSString *valueString = [self.valueDict objectForKey:key];
    
    if (indexPath.row == 0) {
        self.headerImageView = cell.headerImageView;
        cell.isHeaderImageView = YES;
        if (valueString) {
            NSString *path = [TJMPhotoBasicAddress stringByAppendingFormat:@"%@",valueString];
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:path] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                image = [image getCropImage];
                cell.headerImageView.image = image;
            }];
        }
    } else {
        cell.isHeaderImageView = NO;
        if ([key isEqualToString:@"tel"]) {
            valueString = [valueString stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        } else if ([key isEqualToString:@"idCard"]) {
            valueString = [valueString stringByReplacingCharactersInRange:NSMakeRange(6, 8) withString:@"********"];
        }
        cell.detailLabel.text = valueString;
    }
    
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 70 * TJMHeightRatio;
    }
    return 50 * TJMHeightRatio;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return  0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10 *TJMHeightRatio;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        //修改头像
        [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
        [self alertSelectImagePickerVCSourceTypeWithImagePickerVC:self.imagePickerVC];
    } else {
        tableView.allowsSelection = NO;
        
    }

}


#pragma  mark - image picker VC delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    [TJMRequestH uploadHeaderPhotoWithPhoto:image progress:^(NSProgress *progress) {
    
    } success:^(id successObj, NSString *msg) {
        //记录 个人信息已经被更改
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kTJMIsChangePersonInfo];
        self.headerImageView.image = [image getCropImage];
        [[SDWebImageManager sharedManager].imageCache clearDiskOnCompletion:nil];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    } fail:^(NSString *failString) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
    
}


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
