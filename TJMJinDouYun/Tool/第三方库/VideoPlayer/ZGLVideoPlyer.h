//
//  ZGLVideoPlyer.h
//  ZGLVideoPlayer
//
//  Created by 智捷电商APPLE01 on 16/12/1.
//  Copyright © 2016年 智捷电商APPLE01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol ZGLVideoPlayerDelegate <NSObject>

- (void)fullScreenStatus:(BOOL)isFullScreen;
- (void)playerDidPlayToEndTime;
@end

/**记录当前屏幕的方向
 并没有真正的改变设备的旋转方向，项目中所有的界面都是竖屏，这里只是记录下当前的视频播放是否是全屏
 **/
typedef NS_ENUM(NSInteger, CurrentDeviceDirection)  {
    
    Portrait, // 竖屏
    Right // 向右
    
};

/**视频播放的状态**/
typedef NS_ENUM(NSInteger, PlayerState) {
    
    Playing, // 播放中
    Stoped, // 停止播放
    Pause, // 暂停播放
    ReadyToPlay //准备好播放了
    
} ;

@interface ZGLVideoPlyer : UIView

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, assign) PlayerState playerState;

@property (nonatomic, copy) NSString *videoUrlStr;

@property (nonatomic, copy) void (^toFullScreenAction)(UIButton *fullScreenBtn);

@property (nonatomic, copy) void (^playEndBlock) ();

@property (nonatomic, copy) void (^joinTheStudyPlan)();


//是否竖屏
- (BOOL)isPortrait;

- (void)toPortrait;

- (instancetype)initWithFrame:(CGRect)frame;

- (double)playProgessScale;

- (void)play;

- (void)pause;

@property (nonatomic, assign) NSInteger currentPlayTime;//当前播放时间（单位: S）

@property (nonatomic, assign) NSInteger totalTime; // 视频总时长（单位： S）

@property (nonatomic,assign) id<ZGLVideoPlayerDelegate>delegate;
@end
