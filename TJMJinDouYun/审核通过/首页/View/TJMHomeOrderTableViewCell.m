//
//  TJMHomeOrderTableViewCell.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/4.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMHomeOrderTableViewCell.h"

@interface TJMHomeOrderTableViewCell ()
//约束
//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeImageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeImageBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myLocationImageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myLocationImageHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myLocationImageBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startLabelBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startAndEndPointViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *robButtonHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkImageHeightConstraint;

//水平
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeImageRightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myLocationImageRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myLocationImageRightLineRightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getLocationImageLeftLineLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getLocationImageLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getLocationImageRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getLocationImageRightLineRightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendLocationLeftLineLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendLocationLeftConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startLabelRightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkImageRightConstraint;


@end

@implementation TJMHomeOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self configViews];
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
}
#pragma  mark - 设置页面
- (void)configViews {
    [self resetVerticalConstraints:self.titleLabelTopConstraint,self.titleLabelHeightConstraint,self.typeImageTopConstraint,self.typeImageHeightConstraint,self.typeImageBottomConstraint,self.myLocationImageTopConstraint,self.myLocationImageHeightConstraint,self.myLocationImageBottomConstraint,self.startLabelTopConstraint,self.startLabelHeightConstraint,self.startLabelBottomConstraint,self.remarkViewHeightConstraint,self.robButtonHeightConstraint,self.startAndEndPointViewHeightConstraint,self.remarkImageHeightConstraint, nil];
    [self resetHorizontalConstraints:self.typeImageRightConstraint,self.myLocationImageRightConstraint,self.myLocationImageRightLineRightConstraint,self.getLocationImageLeftLineLeftConstraint,self.getLocationImageLeftLineLeftConstraint,self.getLocationImageRightConstraint,self.getLocationImageRightLineRightConstraint,self.sendLocationLeftConstraint,self.sendLocationLeftLineLeftConstraint,self.startLabelRightConstraint,self.remarkImageRightConstraint, nil];
    
    [self adjustFont:14 forView:self.titleLabel,self.typeLabel,self.typeNameLabel,self.startAddressLabel,self.endAddressLabel,self.remarkLabel, nil];
    [self adjustFont:15 forView:self.priceLabel, nil];
    [self adjustFont:10 forView:self.myToGetDistanceLabel,self.getToSendDistanceLabel, nil];
    [self adjustFont:13 forView:self.startLabel,self.endLabel, nil];
    [self adjustFont:16 forView:self.robOrderButton,self.checkMapButton, nil];
    
    [self.contentView layoutIfNeeded];
    [self setBorderWithLabel:self.startLabel];
    [self setBorderWithLabel:self.endLabel];
    
}

- (void)setBorderWithLabel:(UILabel *)label {
    label.layer.cornerRadius = label.frame.size.width / 2;
    label.layer.masksToBounds = YES;
    label.layer.borderWidth = 1;
    label.layer.borderColor = label.textColor.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
