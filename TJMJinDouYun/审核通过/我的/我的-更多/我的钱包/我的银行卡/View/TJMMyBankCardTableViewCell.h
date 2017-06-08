//
//  TJMMyBankCardTableViewCell.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/22.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJMMyBankCardTableViewCell : UITableViewCell
//约束
//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankCardLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankCardLabelBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankCardNumLabelBottomConstraint;
//
@property (weak, nonatomic) IBOutlet UILabel *bankCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankCardTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankCardNumLabel;

- (void)setViewValueWithModel:(TJMBankCardModel *)model;

@end
