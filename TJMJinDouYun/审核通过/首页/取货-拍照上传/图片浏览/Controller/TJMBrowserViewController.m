//
//  TJMBrowserViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/6/13.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMBrowserViewController.h"
#import "TJMBrowserCollectionViewCell.h"
#import "HZPhotoBrowserConfig.h"
@interface TJMBrowserViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,TJMBrowserCollectionViewCellDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,assign) BOOL hasShowedPhotoBrowser;
@property (nonatomic,strong) UILabel *indexLabel;
@property (nonatomic,strong) UIButton *deleteButton;

@end

@implementation TJMBrowserViewController
#pragma  mark - lazy loading
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        
        flowLayout.itemSize = [UIScreen mainScreen].bounds.size;
        flowLayout.minimumLineSpacing = 20;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 20);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGSize size = [UIScreen mainScreen].bounds.size;
        size.width += 20;
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height) collectionViewLayout:flowLayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setShowsVerticalScrollIndicator:NO];
        [_collectionView setDecelerationRate:0];
        [_collectionView registerClass:[TJMBrowserCollectionViewCell class] forCellWithReuseIdentifier:@"imageCell"];
    }
    return  _collectionView;
}
#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
    [_collectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    [self addToolbars];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.hasShowedPhotoBrowser) {
        [self showPhotoBrowser];
    }
}

#pragma mark - 设置页面
- (void)addToolbars {
    //序标
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont boldSystemFontOfSize:20];
    indexLabel.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
    indexLabel.bounds = CGRectMake(0, 0, 100, 40);
    indexLabel.center = CGPointMake(TJMScreenWidth * 0.5, 30);
    indexLabel.layer.cornerRadius = 15;
    indexLabel.clipsToBounds = YES;
    
    if (self.imageArray.count > 2) {
        indexLabel.text = [NSString stringWithFormat:@"%zd/%ld", _currentIndexPath.row + 1 ,(long)self.self.imageArray.count - 1];
        _indexLabel = indexLabel;
        [self.view addSubview:indexLabel];
    }
    
    // 2.保存按钮
    UIButton *deleteButton = [[UIButton alloc] init];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteButton.layer.borderWidth = 0.1;
    deleteButton.layer.borderColor = [UIColor whiteColor].CGColor;
    deleteButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
    deleteButton.layer.cornerRadius = 2;
    deleteButton.clipsToBounds = YES;
    [deleteButton addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.frame = CGRectMake(TJMScreenWidth - (30 + 55) * TJMWidthRatio, TJMScreenHeight - 70 * TJMHeightRatio, 55 * TJMWidthRatio, 30 * TJMHeightRatio);
    _deleteButton = deleteButton;
    [self.view addSubview:_deleteButton];
}
#pragma  mark - 按钮方法 删除
- (void)deleteImage:(UIButton *)button {
    [self.imageArray removeObjectAtIndex:_currentIndexPath.row];
    if (_imageArray.count == 1) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
    [self.collectionView deleteItemsAtIndexPaths:@[_currentIndexPath]];
    [self.sourceImagesContainerView deleteItemsAtIndexPaths:@[_currentIndexPath]];
    if (_currentIndexPath.row == _imageArray.count - 1) {
        //最后一个
        _currentIndexPath = [NSIndexPath indexPathForRow:_currentIndexPath.row - 1 inSection:0];
    } else {
        _currentIndexPath = [NSIndexPath indexPathForRow:_currentIndexPath.row + 1 inSection:0];
    }
    _indexLabel.text = [NSString stringWithFormat:@"%zd/%zd",_currentIndexPath.row + 1 ,self.imageArray.count - 1];
    
}

#pragma  mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count - 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TJMBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.imgView.image = self.imageArray[indexPath.row];
    return cell;
}
#pragma  mark UIScrollViewDelegate
#pragma mark - scrollview代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int index = (scrollView.contentOffset.x + _collectionView.bounds.size.width * 0.5) / _collectionView.bounds.size.width;
    
    _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageArray.count - 1];
    long left = index - 2;
    long right = index + 2;
    left = left > 0 ? left : 0;
    right = right > self.imageArray.count ? self.imageArray.count : right;
    

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger autualIndex = scrollView.contentOffset.x  / _collectionView.bounds.size.width;
    //设置当前下标
    _currentIndexPath = [NSIndexPath indexPathForRow:autualIndex inSection:0];
    
    
}
#pragma  mark - TJMBrowserCollectionViewCellDelegate 
- (void)singleTap:(UITapGestureRecognizer *)recognizer {
    [self hidePhotoBrowser:recognizer];
}
#pragma  mark - 弹出视图
- (void)show {
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self animated:NO completion:nil];
}
#pragma mark 单击隐藏图片浏览器
- (void)hidePhotoBrowser:(UITapGestureRecognizer *)recognizer {
    TJMBrowserCollectionViewCell *cell =  (TJMBrowserCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:_currentIndexPath];
    UIImageView *currentImageView = cell.imgView;
    
    UIView *sourceView = [self.sourceImagesContainerView cellForItemAtIndexPath:_currentIndexPath];
    UIView *parentView = self.sourceImagesContainerView.superview;
    CGRect targetTemp = [sourceView.superview convertRect:sourceView.frame toView:parentView];
    
    // 减去偏移量
    if ([parentView isKindOfClass:[UITableView class]]) {
        UITableView *tableview = (UITableView *)parentView;
        targetTemp.origin.y =  targetTemp.origin.y - tableview.contentOffset.y;
    }
    
    CGFloat appWidth;
    CGFloat appHeight;
    if (TJMScreenWidth < TJMScreenHeight) {
        appWidth = TJMScreenWidth;
        appHeight = TJMScreenHeight;
    } else {
        appWidth = TJMScreenHeight;
        appHeight = TJMScreenWidth;
    }
    
    UIImageView *tempImageView = [[UIImageView alloc] init];
    tempImageView.contentMode = UIViewContentModeScaleAspectFill;
    tempImageView.layer.masksToBounds = YES;
    tempImageView.image = currentImageView.image;
    if (tempImageView.image) {
        CGFloat tempImageSizeH = tempImageView.image.size.height;
        CGFloat tempImageSizeW = tempImageView.image.size.width;
        CGFloat tempImageViewH = (tempImageSizeH * appWidth)/tempImageSizeW;
        if (tempImageViewH < appHeight) {
            tempImageView.frame = CGRectMake(0, (appHeight - tempImageViewH)*0.5, appWidth, tempImageViewH);
        } else {
            tempImageView.frame = CGRectMake(0, 0, appWidth, tempImageViewH);
        }
    } else {
        tempImageView.backgroundColor = [UIColor whiteColor];
        tempImageView.frame = CGRectMake(0, (appHeight - appWidth)*0.5, appWidth, appWidth);
    }
    
    [self.view.window addSubview:tempImageView];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [UIView animateWithDuration:0.4 animations:^{
        tempImageView.frame = targetTemp;
        
    } completion:^(BOOL finished) {
        [tempImageView removeFromSuperview];
    }];
}

#pragma mark 显示图片浏览器
- (void)showPhotoBrowser {
    UIView *sourceView = [self.sourceImagesContainerView cellForItemAtIndexPath:_currentIndexPath];
    UIView *parentView = self.sourceImagesContainerView.superview;
    CGRect rect = [sourceView.superview convertRect:sourceView.frame toView:parentView];
    
    //如果是tableview，要减去偏移量
    if ([parentView isKindOfClass:[UITableView class]]) {
        UITableView *tableview = (UITableView *)parentView;
        rect.origin.y =  rect.origin.y - tableview.contentOffset.y;
    }
    
    UIImageView *tempImageView = [[UIImageView alloc] init];
    tempImageView.frame = rect;
    tempImageView.image = self.imageArray[_currentIndexPath.row];
    [self.view addSubview:tempImageView];
    tempImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGFloat placeImageSizeW = tempImageView.image.size.width;
    CGFloat placeImageSizeH = tempImageView.image.size.height;
    CGRect targetTemp;
    
    if (!kIsFullWidthForLandScape) {
        if (TJMScreenWidth < TJMScreenHeight) {
            CGFloat placeHolderH = (placeImageSizeH * TJMScreenWidth)/placeImageSizeW;
            if (placeHolderH <= TJMScreenHeight) {
                targetTemp = CGRectMake(0, (TJMScreenHeight - placeHolderH) * 0.5 , TJMScreenWidth, placeHolderH);
            } else {
                targetTemp = CGRectMake(0, 0, TJMScreenWidth, placeHolderH);
            }
        } else {
            CGFloat placeHolderW = (placeImageSizeW * TJMScreenHeight)/placeImageSizeH;
            if (placeHolderW < TJMScreenWidth) {
                targetTemp = CGRectMake((TJMScreenWidth - placeHolderW)*0.5, 0, placeHolderW, TJMScreenHeight);
            } else {
                targetTemp = CGRectMake(0, 0, placeHolderW, TJMScreenHeight);
            }
        }
    } else {
        CGFloat placeHolderH = (placeImageSizeH * TJMScreenWidth)/placeImageSizeW;
        if (placeHolderH <= TJMScreenHeight) {
            targetTemp = CGRectMake(0, (TJMScreenHeight - placeHolderH) * 0.5 , TJMScreenWidth, placeHolderH);
        } else {
            targetTemp = CGRectMake(0, 0, TJMScreenWidth, placeHolderH);
        }
    }
    
    _collectionView.hidden = YES;
    _indexLabel.hidden = YES;
    _deleteButton.hidden = YES;
    
    [UIView animateWithDuration:kPhotoBrowserShowDuration animations:^{
        tempImageView.frame = targetTemp;
    } completion:^(BOOL finished) {
        _hasShowedPhotoBrowser = YES;
        [tempImageView removeFromSuperview];
        _collectionView.hidden = NO;
        _indexLabel.hidden = NO;
        _deleteButton.hidden = NO;
    }];
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
