//
//  UIViewController+Config.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/28.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "UIViewController+Config.h"

@implementation UIViewController (Config)



- (void)setTitle:(NSString *)title fontSize:(CGFloat)size colorHexValue:(int)value {
    self.title = title;
    UIFont *font = [UIFont systemFontOfSize:size];
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSForegroundColorAttributeName:TJMFUIColorFromRGB(value)};
    self.navigationController.navigationBar.titleTextAttributes = dic;
}




#pragma  mark - 设置导航左右按钮
- (UIBarButtonItem *)setNaviItemWithImageName:(NSString *)imageName tag:(int)tag {
    UIImage *itemImage = [UIImage imageNamed:imageName];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:itemImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIView *itemView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, itemImage.size.width, itemImage.size.height)];
    button.frame = itemView.frame;
    [itemView addSubview:button];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:itemView];
    return item;
}


@end
