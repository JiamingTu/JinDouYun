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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;
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

//右边按钮约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightButtonWidthConstraint;

//视图
//虚线
@property (weak, nonatomic) IBOutlet UIView *imaginaryLine;



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
    [self tjm_resetVerticalConstraints:self.titleLabelTopConstraint,self.titleLabelHeightConstraint,self.typeImageTopConstraint,self.typeImageHeightConstraint,self.typeImageBottomConstraint,self.myLocationImageTopConstraint,self.myLocationImageHeightConstraint,self.myLocationImageBottomConstraint,self.startLabelTopConstraint,self.startLabelHeightConstraint,self.startLabelBottomConstraint,self.remarkViewHeightConstraint,self.robButtonHeightConstraint,self.startAndEndPointViewHeightConstraint,self.remarkImageHeightConstraint,self.bottomViewHeightConstraint, nil];
    [self tjm_resetHorizontalConstraints:self.typeImageRightConstraint,self.myLocationImageRightConstraint,self.myLocationImageRightLineRightConstraint,self.getLocationImageLeftLineLeftConstraint,self.getLocationImageLeftLineLeftConstraint,self.getLocationImageRightConstraint,self.getLocationImageRightLineRightConstraint,self.sendLocationLeftConstraint,self.sendLocationLeftLineLeftConstraint,self.startLabelRightConstraint,self.remarkImageRightConstraint, nil];
    
    [self tjm_adjustFont:14 forView:self.titleLabel,self.typeLabel,self.typeNameLabel,self.startAddressLabel,self.endAddressLabel,self.remarkLabel, nil];
    [self tjm_adjustFont:15 forView:self.priceLabel, nil];
    [self tjm_adjustFont:10 forView:self.myToGetDistanceLabel,self.getToSendDistanceLabel, nil];
    [self tjm_adjustFont:13 forView:self.startLabel,self.endLabel, nil];
    [self tjm_adjustFont:16 forView:self.robOrderButton,self.checkMapButton, nil];
    
    [self.contentView layoutIfNeeded];
    [self setBorderWithLabel:self.startLabel];
    [self setBorderWithLabel:self.endLabel];
    //设置虚线
    [self tjm_constructImaginaryLineWithView:self.imaginaryLine];
    
}

- (void)setValueWithModel:(TJMOrderModel *)model {
    if (!model) return;
    
    //根据model状态 设置 按钮 title
    self.currentModel = model;
    NSString *dateString = [self tjm_setDateFormatterWithTimestamp:[model.requestTime integerValue]];
    NSString *titleLabelText;
    if ([self.currentModel.orderStatus integerValue] == 2) {
        //待取货
        self.rightButtonWidthConstraint.constant = TJMScreenWidth / 2;
        [self.robOrderButton setTitle:@"确认取货" forState:UIControlStateNormal];
        [self.checkMapButton setTitle:@"地图导航" forState:UIControlStateNormal];
        titleLabelText = [NSString stringWithFormat:@"待取货：%@",dateString];
        self.titleLabel.textColor = TJMFUIColorFromRGB(0xff8600);
    } else if ([self.currentModel.orderStatus integerValue] == 3){
        //待配送
        self.rightButtonWidthConstraint.constant = TJMScreenWidth / 2;
        [self.robOrderButton setTitle:@"确认送达" forState:UIControlStateNormal];
        [self.checkMapButton setTitle:@"地图导航" forState:UIControlStateNormal];
        titleLabelText = [NSString stringWithFormat:@"待配送：%@",dateString];
        self.titleLabel.textColor = TJMFUIColorFromRGB(0x7ab8ff);
    } else if (self.currentModel.orderStatus.integerValue == 1) {
        //待抢单
        self.rightButtonWidthConstraint.constant = TJMScreenWidth / 2;
        [self.robOrderButton setTitle:@"抢 单！" forState:UIControlStateNormal];
        [self.checkMapButton setTitle:@"查看地图" forState:UIControlStateNormal];
        NSString *pickUpType = model.atOnce ? @"及时取：" : @"预约取：";
        titleLabelText = [NSString stringWithFormat:@"%@%@",pickUpType,dateString];
        self.titleLabel.textColor = TJMFUIColorFromRGB(0xff8600);
    } else if (self.currentModel.orderStatus.integerValue == 5) {
        //已取消
        self.rightButtonWidthConstraint.constant = TJMScreenWidth;
        titleLabelText = [NSString stringWithFormat:@"已取消：%@",dateString];
        [self.checkMapButton setTitle:@"已取消" forState:UIControlStateNormal];
        self.titleLabel.textColor = TJMFUIColorFromRGB(0x999999);
    } else if (self.currentModel.orderStatus.integerValue == 4){
        //已完成
        self.rightButtonWidthConstraint.constant = TJMScreenWidth;
        NSString *finishDateString = [self tjm_setDateFormatterWithTimestamp:model.finishTime.integerValue];
        titleLabelText = [NSString stringWithFormat:@"已完成：%@",finishDateString];
        [self.checkMapButton setTitle:@"查看详情" forState:UIControlStateNormal];
        self.titleLabel.textColor = TJMFUIColorFromRGB(0x999999);
    } else if (self.currentModel.orderStatus.integerValue == 7) {
        self.rightButtonWidthConstraint.constant = 0;
//        [self layoutIfNeeded];
        titleLabelText = [NSString stringWithFormat:@"已拒绝：%@",dateString];
        [self.robOrderButton setTitle:@"商家确认" forState:UIControlStateNormal];
        self.titleLabel.textColor = TJMFUIColorFromRGB(0x999999);
    } else {
        //异常单（长期未配送）
        self.rightButtonWidthConstraint.constant = TJMScreenWidth;
        titleLabelText = [NSString stringWithFormat:@"异常订单：%@",dateString];
        [self.checkMapButton setTitle:@"查看详情" forState:UIControlStateNormal];
        self.titleLabel.textColor = TJMFUIColorFromRGB(0x999999);
    }
    //如果是在我的订单页面 多两条横岗
    if (![self.reuseIdentifier isEqualToString:@"OrderCell"]) {
        titleLabelText = [NSString stringWithFormat:@"——  %@  ——",titleLabelText];
    }
    self.titleLabel.text = titleLabelText;
    NSString *showPrice = nil;
    if (model.payType.integerValue == 4) {
        showPrice = [NSString stringWithFormat:@"￥%@",model.actualMoney.description];
    } else {
        showPrice = [NSString stringWithFormat:@"￥%@",model.carrierShowMoney.description];
    }
    self.priceLabel.text = showPrice;
    //地址
    self.startAddressLabel.text = model.consignerAddress;
    self.endAddressLabel.text = model.receiverAddress;
    //距离
    self.getToSendDistanceLabel.text = [NSString stringWithFormat:@"约%.2fKM",[model.distance floatValue]];
    //我倒取货点位置
    //先置为零
    self.myToGetDistanceLabel.text = @"约0.0KM";
    if (model.getDistance) {
        //如果有就更新label
        self.myToGetDistanceLabel.text = [NSString stringWithFormat:@"约%.2fKM",[model.getDistance doubleValue]];
    } else {
        //如果没有，就添加通知
        NSString *notiKey = [NSString stringWithFormat:@"%p",_currentModel];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modelDistanceDidGet:) name:notiKey object:nil];
    }
    //种类 尺寸
    self.typeNameLabel.text = model.itemName ? model.itemName : model.item.itemName;
    TJMLog(@"remark:%@",model.remark);
    if (![model.remark isEqualToString:@""]) {
        [self remarkViewIsHidden:NO];
        self.remarkViewHeightConstraint.constant = 35 * TJMHeightRatio;
        self.remarkLabel.text = [NSString stringWithFormat:@"%@",model.remark];
    } else {
        self.remarkViewHeightConstraint.constant = 0.0;
        [self remarkViewIsHidden:YES];
    }
}

- (void)remarkViewIsHidden:(BOOL)isHidden {
    self.remarkLabel.hidden = isHidden;
    self.remarkImageView.hidden = isHidden;
}

#pragma  mark - 通知
- (void)modelDistanceDidGet:(NSNotification *)notification {
    TJMOrderModel *model = notification.userInfo[@"model"];
    if ([model isEqual:self.currentModel]) {
        self.myToGetDistanceLabel.text =  [NSString stringWithFormat:@"约%.2fKM",[model.getDistance doubleValue]];
        NSString *notiKey = [NSString stringWithFormat:@"%p",model];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:notiKey object:nil];
    }
}

#pragma  mark - 设置label 边框
- (void)setBorderWithLabel:(UILabel *)label {
    label.layer.cornerRadius = label.frame.size.width / 2;
    label.layer.masksToBounds = YES;
    label.layer.borderWidth = 1;
    label.layer.borderColor = label.textColor.CGColor;
}
#pragma  mark 点击按钮
- (IBAction)cellButtonAction:(UIButton *)sender {
    switch (self.currentModel.orderStatus.integerValue) {
        case 1: {
            //抢单
            if ([self isDelegateAndResponseSelector:@selector(robOrderWithButtonTag:order:cell:)]) {
                [self.delegate robOrderWithButtonTag:sender.tag order:self.currentModel cell:self];
            }
        } break;
        case 2: {
            if (sender.tag == 10) {
                //待取货
                if ([self isDelegateAndResponseSelector:@selector(waitPickUpWithOrder:cell:)]) {
                    [self.delegate waitPickUpWithOrder:self.currentModel cell:self];
                }
            } else {
                if ([self isDelegateAndResponseSelector:@selector(naviToDestinationWithLatitude:longtitude:order:cell:)]) {
                    [self.delegate naviToDestinationWithLatitude:[self.currentModel.consignerLat floatValue] longtitude:[self.currentModel.consignerLng floatValue] order:self.currentModel cell:self];
                }
            }
        } break;
        case 3: {
            if (sender.tag == 10) {
                if (self.currentModel.type == 0) {
                    if ([self.currentModel.payType integerValue] == 4) {
                        //到付
                        if ([self isDelegateAndResponseSelector:@selector(payOnDeliveryWithOrder:cell:)]) {
                            [self.delegate payOnDeliveryWithOrder:self.currentModel cell:self];
                        }
                    } else {
                        //验证收货
                        if ([self isDelegateAndResponseSelector:@selector(codeSignInWithOrder:cell:)]) {
                            [self.delegate codeSignInWithOrder:self.currentModel cell:self];
                        }
                    }
                } else {
                    //代收货款
                    //验证收货
                    if ([self isDelegateAndResponseSelector:@selector(helpToCollectPayMoneyWithOrder:cell:)]) {
                        [self.delegate helpToCollectPayMoneyWithOrder:self.currentModel cell:self];
                    }
                }
            } else {
                if ([self isDelegateAndResponseSelector:@selector(naviToDestinationWithLatitude:longtitude:order:cell:)]) {
                    [self.delegate naviToDestinationWithLatitude:[self.currentModel.receiverLat floatValue] longtitude:[self.currentModel.receiverLng floatValue] order:self.currentModel cell:self];
                }
            }
        } break;
            // 状态4 5 6 分别为 已完成 已取消 异常订单
        case 4: {
            //查看详情
            if ([self isDelegateAndResponseSelector:@selector(checkDetailsWithOrder:cell:)]) {
                [self.delegate checkDetailsWithOrder:self.currentModel cell:self];
            }
        } break;
        case 5: {
            //查看详情
            if ([self isDelegateAndResponseSelector:@selector(checkDetailsWithOrder:cell:)]) {
                [self.delegate checkDetailsWithOrder:self.currentModel cell:self];
            }
        } break;
        case 6: {
            //查看详情
            if ([self isDelegateAndResponseSelector:@selector(checkDetailsWithOrder:cell:)]) {
                [self.delegate checkDetailsWithOrder:self.currentModel cell:self];
            }
        } break;
        case 7: {
           //拒收 跳到 到付界面(共用界面)
            if ([self isDelegateAndResponseSelector:@selector(refuseCollectPayMoneyWithOrder:cell:)]) {
                [self.delegate refuseCollectPayMoneyWithOrder:self.currentModel cell:self];
            }
        } break;
    
        default:
            break;
    }
}

- (BOOL)isDelegateAndResponseSelector:(SEL)aSelector {
    if (self.delegate && [self.delegate respondsToSelector:aSelector]) {
        return YES;
    }
    return NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
