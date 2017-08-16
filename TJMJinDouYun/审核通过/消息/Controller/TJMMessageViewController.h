//
//  TJMMessageViewController.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/27.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJMMessageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)refreshList;//刷新列表

@end
