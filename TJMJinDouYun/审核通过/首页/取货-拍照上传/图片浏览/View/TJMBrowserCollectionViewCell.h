//
//  TJMBrowserCollectionViewCell.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/6/13.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>

//是否支持横屏
#define shouldSupportLandscape YES
#define kIsFullWidthForLandScape YES //是否在横屏的时候直接满宽度，而不是满高度，一般是在有长图需求的时候设置为YES

@protocol TJMBrowserCollectionViewCellDelegate <NSObject>

- (void)singleTap:(UITapGestureRecognizer *)recognizer;

@end


@interface TJMBrowserCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) BOOL beginLoadingImage;

@property (nonatomic,assign) id<TJMBrowserCollectionViewCellDelegate>delegate;



@end
