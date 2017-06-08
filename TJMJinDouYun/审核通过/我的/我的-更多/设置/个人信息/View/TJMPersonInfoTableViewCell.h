//
//  TJMPersonInfoTableViewCell.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/24.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJMPersonInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detialLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (nonatomic,assign) BOOL isHeaderImageView;
@end
