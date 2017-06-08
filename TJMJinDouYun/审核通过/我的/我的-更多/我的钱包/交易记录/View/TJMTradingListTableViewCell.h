//
//  TJMTradingListTableViewCell.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/8.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJMTradingListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)setViewWithModel:(TJMTradingRecordModel *)model;

@end
