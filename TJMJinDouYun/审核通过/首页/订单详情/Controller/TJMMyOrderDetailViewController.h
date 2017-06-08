//
//  TJMMyOrderDetailViewController.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/8.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJMMyOrderDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) TJMOrderModel *orderModel;

@property (weak, nonatomic) IBOutlet UIButton *leftYellowButton;
@property (weak, nonatomic) IBOutlet UIButton *rightWhiteButton;


@end
