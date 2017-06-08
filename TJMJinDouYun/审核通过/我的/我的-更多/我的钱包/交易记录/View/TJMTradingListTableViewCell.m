//
//  TJMTradingListTableViewCell.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/8.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMTradingListTableViewCell.h"

@implementation TJMTradingListTableViewCell
#pragma  mark -
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self configViews];
}
#pragma  mark - 页面设置
- (void)configViews {
    [self tjm_adjustFont:15 forView:self.titleLabel, nil];
    [self tjm_adjustFont:13 forView:self.timeLabel, nil];
}

#pragma  mark 根据model 完成页面
- (void)setViewWithModel:(TJMTradingRecordModel *)model {
    NSString *title = model.msg;
    NSString *symbol = model.positive ? @"+" : @"-";
    NSString *money = model.money;
    NSString *titleLabelText = [NSString stringWithFormat:@"%@ %@￥%@",title,symbol,money];
    self.titleLabel.text = titleLabelText;
    NSString *timeText = [NSString getTimeWithTimestamp:model.createTime.description formatterStr:@"yyyy-MM-dd HH:mm"];
    self.timeLabel.text = timeText;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
