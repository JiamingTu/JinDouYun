//
//  TJMIdCardTableViewCell.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/3.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJMIdCardTableViewCell : UITableViewCell
//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idInfoTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idInfoBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopConstraint;
//水平
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageRightConstraint;
@end
