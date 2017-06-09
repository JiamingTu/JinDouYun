//
//  TJMHomepageViewController+Category.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/6/9.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMHomepageViewController.h"

@interface TJMHomepageViewController (Category)<BTKTraceDelegate>
/**设置约束*/
- (void)resetConstraints;
/**调整字体*/
- (void)adjustFonts;

/**开启鹰眼服务*/
- (void)configbaiduTraceWithWorkStatus:(BOOL)workStatus;

/**开启定时器*/
- (void)startTimerWithTimestamp:(NSInteger)timestamp;
/**关闭定时器*/
- (void)cancelTiemr;

@end
