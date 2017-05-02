//
//  TJMOverlayView.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/24.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJMOverlayView : UIView

/**
 *  透明扫描框的区域
 */
@property (nonatomic, assign) CGRect transparentArea;

-(void)stopAnimation;

@end
