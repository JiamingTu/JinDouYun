//
//  TJMInfoTableViewCell.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/3.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJMUserInfoModel.h"
@class TJMInfoTableViewCell;
@protocol TJMInfoTableViewCellDelegate <NSObject>

- (void)getInfoValue:(NSString *)value cell:(TJMInfoTableViewCell *)cell;

@end


@interface TJMInfoTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *infoTextField;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starRightConstraint;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldHeightConstraint;

@property (nonatomic,copy) NSString *inputType;
@property (nonatomic,assign) id<TJMInfoTableViewCellDelegate>delegate;

- (void)setViewInfoWith:(TJMUserInfoModel *)model;

@end

