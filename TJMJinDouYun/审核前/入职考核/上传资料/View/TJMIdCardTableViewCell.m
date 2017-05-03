//
//  TJMIdCardTableViewCell.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/3.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMIdCardTableViewCell.h"

@implementation TJMIdCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self configViews];
}

#pragma  mark - 约束 字体等适配
- (void)configViews {
    [self resetHorizontalConstraints:self.starLeftConstraint,self.imageLeftConstraint,self.imageRightConstraint,self.imageBottomConstraint, nil];
    [self resetVerticalConstraints:self.self.idInfoTopConstraint,self.idInfoBottomConstraint,self.imageTopConstraint, nil];
    [self adjustFont:15 forView:self.titleLabel,self.starLabel, nil];
    [self adjustFont:11 forView:self.explainLabel, nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
