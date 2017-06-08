//
//  TJMLocation.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/5/31.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJMLocation : NSObject

@property (nonatomic,assign) CLLocationCoordinate2D coordinate2D;
@property (nonatomic,copy) NSString *title;

- (instancetype)initWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D title:(NSString *)title;
@end
