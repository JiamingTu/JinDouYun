//
//  TJMMyOrderDetailHeaderView.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/8.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMMyOrderDetailHeaderView.h"

@implementation TJMMyOrderDetailHeaderView
#pragma  mark - lazy loading
- (UILabel *)label {
    if (!_label) {
        self.label = [[UILabel alloc]init];
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        _label.textColor = TJMFUIColorFromRGB(0x666666);
        UIFont *font = [UIFont systemFontOfSize:12];
        _label.font = font;
    }
    return _label;
}

#pragma  mark - view
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.label];
        self.contentView.backgroundColor = TJMFUIColorFromRGB(0xf5f5f5);
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    ;
    NSLayoutConstraint *labelLeftConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:15 * TJMWidthRatio];
    NSLayoutConstraint *labelTopConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:15 * TJMHeightRatio];
    NSLayoutConstraint *labelBottomConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-10 * TJMHeightRatio];
    NSLayoutConstraint *labelWidthConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:10];
    [self.contentView addConstraints:@[labelLeftConstraint,labelTopConstraint,labelBottomConstraint,labelWidthConstraint]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
