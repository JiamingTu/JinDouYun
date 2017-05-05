//
//  TJMHomeHeaerView.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/4.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMHomeHeaderView.h"

@implementation TJMHomeHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)layoutSubviews {
    [super layoutSubviews];
    NSLayoutConstraint *imageViewWidthConstraint = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:_imageView.image.size.width * TJMWidthRatio];
    NSLayoutConstraint *imageViewHeightConstraint = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:_imageView.image.size.height * TJMWidthRatio];
    NSLayoutConstraint *imageViewLeftConstraint = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:15 * TJMWidthRatio];
    NSLayoutConstraint *imageViewCenterYConstraint = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.contentView addConstraints:@[imageViewLeftConstraint,imageViewCenterYConstraint,imageViewWidthConstraint,imageViewHeightConstraint]];
    
    _label.font = [UIFont systemFontOfSize:12];
    _label.text = @"温馨提示：若出工状态有未接单的情况下，三分钟内未进行抢单操作系统将自动分配订单！";
    _label.textColor = TJMFUIColorFromRGB(0x666666);
    _label.numberOfLines = 2;
    NSLayoutConstraint *labelLeftConstraint = [NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_imageView attribute:NSLayoutAttributeRight multiplier:1 constant:5 * TJMWidthRatio];
    NSLayoutConstraint *labelRightConstraint = [NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-15 * TJMWidthRatio];
    NSLayoutConstraint *labelCenterYConstraint = [NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *labelHeightConstraint = [NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:_label.font.pointSize * 2 + 6];
    [self.contentView addConstraints:@[labelLeftConstraint,labelRightConstraint,labelCenterYConstraint,labelHeightConstraint]];
    
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = TJMFUIColorFromRGB(0xf5f5f5);
        UIImage *image = [UIImage imageNamed:@"list_icon_prompt-"];
        self.imageView = [[UIImageView alloc]initWithImage:image];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_imageView];
        
        
        self.label = [[UILabel alloc]init];
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_label];
        
        
    }
    return self;
}

@end
