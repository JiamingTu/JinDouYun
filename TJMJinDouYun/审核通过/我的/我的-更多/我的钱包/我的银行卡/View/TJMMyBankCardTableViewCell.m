//
//  TJMMyBankCardTableViewCell.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/22.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMMyBankCardTableViewCell.h"

@implementation TJMMyBankCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self adjuseFonts];
    [self resetConstraints];
}

#pragma  mark - 设置页面
- (void)resetConstraints {
    [self tjm_resetVerticalConstraints:self.bankCardLabelTopConstraint,self.bankCardLabelBottomConstraint,self.bankCardNumLabelBottomConstraint, nil];
}
- (void)adjuseFonts {
    [self tjm_adjustFont:15 forView:self.bankCardLabel, nil];
    [self tjm_adjustFont:13 forView:self.bankCardTypeLabel, nil];
    [self tjm_adjustFont:20 forView:self.bankCardNumLabel, nil];
}
- (void)setViewValueWithModel:(TJMBankCardModel *)model {
    self.bankCardLabel.text = model.bank.bankName;
//    self.bankCardTypeLabel
    NSString *bankNum = [NSString getNewBankNumWitOldBankNum:model.bankcard.description];
    self.bankCardNumLabel.text = bankNum;
}


#pragma  mark -
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
