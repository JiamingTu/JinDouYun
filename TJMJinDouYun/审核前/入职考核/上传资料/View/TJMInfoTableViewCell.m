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
}
#pragma  mark - 约束 字体等适配
- (void)configViews {
    [self resetHorizontalConstraints:self.starLeftConstraint,self.starRightConstraint, nil];
    [self resetVerticalConstraints:self.textFieldTopConstraint,self.textFieldBottomConstraint,self.textFieldHeightConstraint, nil];
    [self adjustFont:15 forView:self.infoTextField,self.titleLabel,self.starLabel, nil];
}

#pragma  mark - 设置页面内容
- (void)setViewInfoWith:(TJMUserInfoModel *)model {
    self.titleLabel.text = model.title;
    self.infoTextField.placeholder = model.info;
    self.accessoryType = model.isTextField ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
    self.infoTextField.enabled = model.isTextField;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

