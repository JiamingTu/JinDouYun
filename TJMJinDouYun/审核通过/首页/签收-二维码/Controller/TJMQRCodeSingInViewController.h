//
//  TJMQRCodeSingInViewController.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/17.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJMQRCodeSingInViewController : UIViewController
@property (nonatomic,strong) TJMOrderModel *orderModel;
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImageView;
@end
