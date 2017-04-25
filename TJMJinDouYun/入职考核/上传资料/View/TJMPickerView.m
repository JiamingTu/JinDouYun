//
//  TJMPickerView.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/25.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMPickerView.h"

@interface TJMPickerView ()



@end


@implementation TJMPickerView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = TJMRGBColorAlpha(0, 0, 0, 0.5);
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
