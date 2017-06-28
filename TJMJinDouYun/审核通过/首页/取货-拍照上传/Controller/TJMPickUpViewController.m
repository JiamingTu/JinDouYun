//
//  TJMPickUpViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/16.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMPickUpViewController.h"
#import "TJMPickUpCollectionViewCell.h"
#import "TJMBrowserViewController.h"
#import "TJMPhotoManager.h"
@interface TJMPickUpViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TDAlertViewDelegate>
//约束
//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noticeLabelBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noticeImageHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commitButtonHeightConstraint;

//水平
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noticeImageRightConstraint;
//不调整
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataSourceArray;
@property (weak, nonatomic) IBOutlet UILabel *noticLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

@end

@implementation TJMPickUpViewController
#pragma  mark - lazy loading
- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        self.dataSourceArray = [NSMutableArray array];
        UIImage *image = [UIImage imageNamed:@"img_photo"];
        [_dataSourceArray addObject:image];
    }
    return _dataSourceArray;
}

#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"拍照验货" fontSize:17 colorHexValue:0x333333];
    [self adjustFonts];
    [self configViews];
    [self resetConstraints];
    //获取地理位置，判断取货范围
    [[TJMLocationService sharedLocationService] getFreeManLocationWith:TJMGetLocationTypeLocation target:CLLocationCoordinate2DMake(0, 0)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDidChange:) name:kTJMLocationDidChange object:nil];
}
#pragma  mark - 设置页面
- (void)resetConstraints {
    [self tjm_resetVerticalConstraints:self.noticeLabelBottomConstraint,self.noticeImageHeightConstraint,self.collectionViewTopConstraint,self.commitButtonHeightConstraint, nil];
    [self tjm_resetHorizontalConstraints:self.noticeImageRightConstraint, nil];
}
- (void)adjustFonts {
    [self tjm_adjustFont:12 forView:self.noticLabel, nil];
    [self tjm_adjustFont:11 forView:self.promptLabel, nil];
}
- (void)configViews {
    [self setBackNaviItem];
    [self setRightNaviItemWithImageName:@"delete_pic" orTitle:nil titleColorHexValue:0 fontSize:0];
}
#pragma  mark - 按钮方法
- (IBAction)commitAction:(UIButton *)sender {
    MBProgressHUD *progressHUD = [TJMHUDHandle showProgressHUDAtView:self.view message:@"正在上传"];
    NSMutableArray *images = [self.dataSourceArray mutableCopy];
    [TJMRequestH upLoadPickedOrderImage:images orderNo:self.orderModel.orderNo pregress:^(NSProgress *progress) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            progressHUD.progressObject = progress;
        }];
    } success:^(id successObj, NSString *msg) {
        progressHUD.label.text = msg;
        [progressHUD hideAnimated:YES afterDelay:1.5];
        //成功后返回
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } fail:^(NSString *failString) {
        progressHUD.label.text = failString;
        [progressHUD hideAnimated:YES afterDelay:0.8];
    }];
}

#pragma  mark - 通知
- (void)locationDidChange:(NSNotification *)notification {
    BMKUserLocation *location = notification.userInfo[@"myLocation"];
    CLLocationCoordinate2D toCoordinate = CLLocationCoordinate2DMake(_orderModel.consignerLat.doubleValue, _orderModel.consignerLng.doubleValue);
    CLLocationDistance distance = [[TJMLocationService sharedLocationService] calculateDistanceFromMyLocation:location.location.coordinate toGetLocation:toCoordinate];
    if (distance > 1000) {
        [TJMHUDHandle hiddenHUDForView:self.view];
        [self alertViewWithTag:1000 delegate:self title:@"不在取货范围" cancelItem:nil sureItem:@"确定"];
    } else {
        
    }
}

- (void)alertView:(TDAlertView *)alertView didClickItemWithIndex:(NSInteger)itemIndex {
    if (itemIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma  mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.collectionViewHeightConstraint.constant = ((self.dataSourceArray.count - 1) / 4 + 1) * (75 + 15)* TJMWidthRatio;
    
    return self.dataSourceArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TJMPickUpCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PickUpCell" forIndexPath:indexPath];
    cell.imageView.image = self.dataSourceArray[indexPath.item];
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //如果点击的是最后一个
    if (indexPath.item == self.dataSourceArray.count - 1) {
        if (indexPath.item >= 9) {
            //最多上传8张
            return;
        }
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    } else {
        //点击其他图片 预览
        TJMBrowserViewController *browserVC = [[TJMBrowserViewController alloc]init];
        browserVC.currentIndexPath = indexPath;
        browserVC.sourceImagesContainerView = collectionView;
        browserVC.imageArray = self.dataSourceArray;
        [browserVC show];
        
        
        
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15 * TJMWidthRatio;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 15 * TJMWidthRatio;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(75 * TJMWidthRatio, 75 * TJMWidthRatio);
}

#pragma  mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSInteger item = self.dataSourceArray.count - 1;
    [self.dataSourceArray insertObject:image atIndex:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
    [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
    [TJMPhotoManager savePhoto:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
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
