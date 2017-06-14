//
//  TJMBrowserViewController.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/6/13.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJMBrowserViewController : UIViewController

@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic, weak) UICollectionView *sourceImagesContainerView;
@property (nonatomic,strong) NSIndexPath *currentIndexPath;
- (void)show;

@end
