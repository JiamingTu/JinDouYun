//
//  TJMAnswerTableViewCell.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/26.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJMAnswerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *answerTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (nonatomic,assign) BOOL isMulti;
@end
