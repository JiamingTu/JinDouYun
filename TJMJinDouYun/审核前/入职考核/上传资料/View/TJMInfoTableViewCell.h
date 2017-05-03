//
//  TJMInfoTableViewCell.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/3.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJMUserInfoModel.h"

@interface TJMInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *infoTextField;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starRightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldHeightConstraint;

- (void)setViewInfoWith:(TJMUserInfoModel *)model;

@end

