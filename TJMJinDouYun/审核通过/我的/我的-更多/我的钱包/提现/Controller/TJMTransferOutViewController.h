//
//  TJMTransferOutViewController.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/19.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJMTransferOutViewController : UIViewController
@property (nonatomic,copy) NSString *buttonTitle;
@property (nonatomic,copy) NSString *blanceNum;
@property (nonatomic,strong) NSMutableArray *bankCardArray;
/**被选择银行卡的model*/
@property (nonatomic,strong) TJMBankCardModel *selectBankCardModel;
@end
