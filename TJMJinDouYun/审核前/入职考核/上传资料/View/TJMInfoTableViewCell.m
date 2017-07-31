//
//  TJMInfoTableViewCell.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/3.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMInfoTableViewCell.h"
@implementation TJMInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self configViews];
    [self setSelected:NO animated:YES];
}
#pragma  mark - 约束 字体等适配
- (void)configViews {
    [self tjm_resetHorizontalConstraints:self.starLeftConstraint,self.starRightConstraint, nil];
    [self tjm_resetVerticalConstraints:self.textFieldHeightConstraint, nil];
    [self tjm_adjustFont:15 forView:self.infoTextField,self.titleLabel,self.starLabel, nil];
    self.infoTextField.clearButtonMode = UITextFieldViewModeWhileEditing;}

#pragma  mark - 设置页面内容
- (void)setViewInfoWith:(TJMUserInfoModel *)model {
    self.titleLabel.text = model.title;
    self.infoTextField.placeholder = model.info;
    self.accessoryType = model.isTextField ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
    self.infoTextField.enabled = model.isTextField;
    self.inputType = model.inputType;
}

#pragma  mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(getInfoValue:cell:)]) {
        [self.delegate getInfoValue:textField.text cell:self];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.inputType isEqualToString:@"bankcard"]) {
        return [textField bankCardInputRuleWithTextFieldShouldChangeCharactersInRange:range replacementString:string];
    }else if ([self.inputType isEqualToString:@"realName"] || [self.inputType isEqualToString:@"concact"]) {
//        return  [textField realNameInputRuleWithTextFieldShouldChangeCharactersInRange:range replacementString:string];
        return YES;
    } else if ([self.inputType isEqualToString:@"idCard"]){
        return [textField idCardInputRuleWithTextFieldShouldChangeCharactersInRange:range replacementString:string];
    } else if ([self.inputType isEqualToString:@"concactMobile"]) {
        return [textField phoneNumInpuRuleWithTextFieldShouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

