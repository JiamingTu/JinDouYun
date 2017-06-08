//
//  TJMMyOrderDetailTableViewCell.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/8.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJMOrderDetailInfoModel.h"
@interface TJMMyOrderDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *telImageView;

- (void)setViewWithModel:(TJMOrderDetailInfoModel *)model;


@end
