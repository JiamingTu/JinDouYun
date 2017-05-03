//
//  TJMIdCardTableViewCell.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/3.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJMIdCardTableViewCell : UITableViewCell
//view
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;
@property (weak, nonatomic) IBOutlet UILabel *explainLabel;

//竖直
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idInfoTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idInfoBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBottomConstraint;
//水平
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageRightConstraint;



@end
