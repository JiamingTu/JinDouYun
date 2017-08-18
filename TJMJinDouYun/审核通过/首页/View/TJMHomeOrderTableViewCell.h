//
//  TJMHomeOrderTableViewCell.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/4.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TJMHomeOrderTableViewCell;
@protocol TJMHomeOrderTableViewCellDelegate <NSObject>
@optional
- (void)robOrderWithButtonTag:(NSInteger)tag order:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell;
- (void)waitPickUpWithOrder:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell;
- (void)payOnDeliveryWithOrder:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell;
- (void)codeSignInWithOrder:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell;
- (void)naviToDestinationWithLatitude:(CGFloat)lat longtitude:(CGFloat)lng order:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell;
- (void)checkDetailsWithOrder:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell;
- (void)helpToCollectPayMoneyWithOrder:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell;
- (void)refuseCollectPayMoneyWithOrder:(TJMOrderModel *)model cell:(TJMHomeOrderTableViewCell *)cell;
@end

@interface TJMHomeOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *myToGetDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *getToSendDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *startAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *endAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UIImageView *remarkImageView;

@property (weak, nonatomic) IBOutlet UIButton *robOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *checkMapButton;

/**根据model设置界面*/
- (void)setValueWithModel:(TJMOrderModel *)model;

@property (nonatomic,assign) id<TJMHomeOrderTableViewCellDelegate>delegate;
//订单模型
@property (nonatomic,strong) TJMOrderModel *currentModel;
@end
