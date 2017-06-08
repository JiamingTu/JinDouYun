//
//  TJMPersonInfoTableViewCell.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/24.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMPersonInfoTableViewCell.h"

@implementation TJMPersonInfoTableViewCell
#pragma  mark - set
- (void)setIsHeaderImageView:(BOOL)isHeaderImageView {
    _isHeaderImageView = isHeaderImageView;
    if (_isHeaderImageView) {
        self.headerImageView.hidden = NO;
        self.detialLabel.hidden = YES;
    } else {
        self.headerImageView.hidden = YES;
        self.detialLabel.hidden = NO;
    }
}
#pragma  mark -
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self configViews];
}
#pragma  mark - 页面设置
- (void)configViews {
    [self tjm_adjustFont:15 forView:self.titleLabel,self.detialLabel, nil];
    [self tjm_resetVerticalConstraints:self.headerImageHeightConstraint, nil];
    CGFloat height = self.headerImageView.frame.size.height;
    self.headerImageView.layer.cornerRadius = height / 2;
    self.headerImageView.layer.masksToBounds = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
