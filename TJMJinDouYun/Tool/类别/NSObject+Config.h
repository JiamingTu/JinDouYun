//
//  NSObject+Config.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/3.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Config)

- (void)resetHorizontalConstrains:(NSLayoutConstraint *)constrain, ... NS_REQUIRES_NIL_TERMINATION;
- (void)resetVerticalConstrains:(NSLayoutConstraint *)constrain, ... NS_REQUIRES_NIL_TERMINATION;
/**设置页面字体*/
- (void)adjustFont:(CGFloat)fontSize forView:(id)view, ... NS_REQUIRES_NIL_TERMINATION;



@end
