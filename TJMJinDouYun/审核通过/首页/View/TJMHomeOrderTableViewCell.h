//
//  TJMHomeOrderTableViewCell.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/4.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@property (weak, nonatomic) IBOutlet UIButton *robOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *checkMapButton;



@end
