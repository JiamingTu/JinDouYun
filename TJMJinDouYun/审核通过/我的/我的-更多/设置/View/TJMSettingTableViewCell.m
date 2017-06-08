//
//  TJMSettingTableViewCell.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/24.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMSettingTableViewCell.h"

@implementation TJMSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self tjm_adjustFont:15 forView:self.titleLabel, nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
