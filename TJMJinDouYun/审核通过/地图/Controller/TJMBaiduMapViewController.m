//
//  TJMBaiduMapViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/11.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMBaiduMapViewController.h"
#import "AppDelegate.h"
#import "LocationTracker.h"

@interface TJMBaiduMapViewController ()
@property (nonatomic,strong) LocationTracker *locationTracker;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation TJMBaiduMapViewController
#pragma  mark - lazy loading

- (LocationTracker *)locationTracker {
    if (!_locationTracker) {
        self.locationTracker = [[LocationTracker alloc]init];
    }
    return _locationTracker;
}

#pragma  mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    
    [self.locationTracker startLocationTracking];
    NSTimeInterval time = 5;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(updateLocation) userInfo:nil repeats:YES];
    
}


- (void)updateLocation {
    NSLog(@"开始获取定位信息...");
    //向服务器发送位置信息
    [self.locationTracker updateLocationToServer];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
