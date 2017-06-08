//
//  TJMAnswerTableViewCell.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/26.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMAnswerTableViewCell.h"

@implementation TJMAnswerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma  mark - setter
- (void)setIsMulti:(BOOL)isMulti {
    _isMulti = isMulti;
    if (_isMulti) {
        self.selectImageView.image = [UIImage imageNamed:@"exam_multi_nor"];
        self.selectImageView.highlightedImage = [UIImage imageNamed:@"exam_multi_sel"];
    } else {
        self.selectImageView.image = [[UIImage imageNamed:@"exam_single_nor"] scaleToSize:CGSizeMake(18, 18)];
        self.selectImageView.highlightedImage = [[UIImage imageNamed:@"exam_single_sel"] scaleToSize: CGSizeMake(18, 18)];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
