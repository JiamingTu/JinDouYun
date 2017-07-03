//
//  TJMMyOrderDetailTableViewCell.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/8.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMMyOrderDetailTableViewCell.h"

@interface TJMMyOrderDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneImageHeightConstraint;

@end

@implementation TJMMyOrderDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self configViews];
}


#pragma  mark - 设置页面
- (void)configViews {
    [self tjm_resetVerticalConstraints:self.nameLabelTopConstraint,self.nameLabelBottomConstraint,self.phoneImageHeightConstraint, nil];
    [self tjm_adjustFont:15 forView:self.titleLabel,self.nameLabel, nil];
}
#pragma  mark - 完成cell
- (void)setViewWithModel:(TJMOrderDetailInfoModel *)model {
    self.titleLabel.text = model.title;
    self.nameLabel.text = model.detail;
    self.telImageView.hidden = !model.isTel;
    if (model.isBigerFont) {
        self.nameLabel.font = [UIFont systemFontOfSize:20];
    } else {
        self.nameLabel.font = [UIFont systemFontOfSize:15];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
