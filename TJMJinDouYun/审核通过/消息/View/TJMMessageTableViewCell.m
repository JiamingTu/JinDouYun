//
//  TJMMessageTableViewCell.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/5.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMMessageTableViewCell.h"

@interface TJMMessageTableViewCell ()
//约束
//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelBottomConstraint;



@end

@implementation TJMMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self configViews];
}

#pragma  mark - 设置页面
- (void)configViews {
    //约束
    [self tjm_resetVerticalConstraints:self.titleLabelTopConstraint,self.titleLabelBottomConstraint, nil];
    //设置字体
    [self tjm_adjustFont:15 forView:self.titleLabel, nil];
    [self tjm_adjustFont:13 forView:self.messageLabel, nil];
    [self tjm_adjustFont:12 forView:self.dateLabel, nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
