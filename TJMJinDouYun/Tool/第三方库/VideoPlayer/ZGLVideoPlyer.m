
//
//  ZGLVideoPlyer.m
//  ZGLVideoPlayer
//
//  Created by 智捷电商APPLE01 on 16/12/1.
//  Copyright © 2016年 智捷电商APPLE01. All rights reserved.
//

#import "ZGLVideoPlyer.h"
#import <AVFoundation/AVFoundation.h>
#import "ZGLVideoMaskView.h"

@interface ZGLVideoPlyer ()

@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, assign) CGRect smallFrame;

@property (nonatomic, assign) CGRect bigFrame;

@property (nonatomic, strong) ZGLVideoMaskView *videoMaskView;

@property (nonatomic, assign) CurrentDeviceDirection currentDevDir;

@property (nonatomic, assign) BOOL isUserPause;//标记是否是用户暂停播放

@property (nonatomic, assign) BOOL isDragSlider;



@end

@implementation ZGLVideoPlyer

- (void)toPortrait {
    
    if ([self isPortrait] == NO) {
        [self fullScreenClick:self.videoMaskView.fullScreenBtn];
    }
}

- (BOOL)isPortrait {
    
    return self.currentDevDir == Portrait;
}

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.isUserPause = NO;
        self.smallFrame = frame;
        self.bigFrame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        
        self.player = [AVPlayer playerWithURL:[NSURL URLWithString:@""]];
        
        if([[UIDevice currentDevice] systemVersion].floatValue >= 10.0){
            //      增加下面这行可以解决iOS10兼容性问题了
            self.player.automaticallyWaitsToMinimizeStalling = NO;
        }
        
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        self.playerLayer.frame = frame;
        [self.layer insertSublayer:self.playerLayer atIndex:0];

        __weak typeof(self) weakself = self;
        self.videoMaskView = [[ZGLVideoMaskView alloc]initWithFrame:frame
          playBtnClick:^(UIButton *playBtn) {
            [weakself playBtnClick:playBtn];
        } fullScreenBtnClick:^(UIButton *fullScreenBtn) {
            
            [weakself fullScreenClick:fullScreenBtn];
        }];
        
       [self addSubview:self.videoMaskView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        [self setTheProgressOfPlayTime];
    }
    
    return self;
}

#pragma mark - 滑杆滑动事件
/**开始拖动滑杆**/
-(void)progressSliderTouchBegan: (UISlider *)slider {
    
    if (!self.playerItem || ![self.player currentItem].duration.value || ![self.player currentItem].duration.timescale) {
        return;
    }
    
    self.isDragSlider = YES;
    
}

/**滑动中**/
- (void)progressSliderTouchValueChanged: (UISlider *)slider {
    
    if (!self.playerItem || ![self.player currentItem].duration.value || ![self.player currentItem].duration.timescale) {
        return;
    }
    
    CGFloat total = [self.player currentItem].duration.value / [self.player currentItem].duration.timescale;
    CGFloat current = total * slider.value;
    
    NSInteger proSec = (NSInteger)current % 60;
    
    NSInteger proMin = (NSInteger)current / 60;
    
    self.videoMaskView.currentTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
}

/**滑动结束**/
- (void)progressSliderTouchEnd: (UISlider *)slider {
    if (!self.playerItem || ![self.player currentItem].duration.value || ![self.player currentItem].duration.timescale) {
        return;
    }
    [self.player pause];
    [self.videoMaskView.activityView startAnimating];
    CGFloat total = [self.player currentItem].duration.value / [self.player currentItem].duration.timescale;
    CGFloat current = total * slider.value;
    CMTime dragTime = CMTimeMake(current, 1);
    
    __weak typeof(self) weakself = self;
    [self.player seekToTime:dragTime completionHandler:^(BOOL finished) {

        [weakself play];
        weakself.videoMaskView.bottomBackgroundView.hidden = NO;
    }];
    
}

//设置播放进度和时间
-(void)setTheProgressOfPlayTime
{
    __weak typeof(self) weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        //如果是拖拽slider中就不执行.
        
        if (weakSelf.isDragSlider) {
            return ;
        }
        
        float current=CMTimeGetSeconds(time);
        float total=CMTimeGetSeconds([weakSelf.playerItem duration]);
        weakSelf.currentPlayTime = current;
        weakSelf.totalTime = total;
        
        if (current) {
            [weakSelf.videoMaskView.videoSlider setValue:(current/total) animated:YES];
        }
        
        //秒数
        NSInteger proSec = (NSInteger)current%60;
        //分钟
        NSInteger proMin = (NSInteger)current/60;
        
        //总秒数和分钟
        NSInteger durSec = (NSInteger)total%60;
            
        NSInteger durMin = (NSInteger)total/60;
            
        weakSelf.videoMaskView.currentTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
        weakSelf.videoMaskView.totalTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
            
    } ];
}

-(void)fullScreenClick: (UIButton *)btn {
    btn.selected = !btn.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(fullScreenStatus:)]) {
        if (btn.selected) {
            
            [UIView animateWithDuration:0.3 animations:^{
                self.transform = CGAffineTransformMakeRotation(M_PI / 2);
                [self.delegate fullScreenStatus:btn.selected];
            } completion:nil];
            self.currentDevDir = Right;
            self.frame = self.bigFrame;
            
        }else {
            self.currentDevDir = Portrait;
            [UIView animateWithDuration:0.3 animations:^{
                self.transform = CGAffineTransformMakeRotation(M_PI * 2);
                [self.delegate fullScreenStatus:btn.selected];
            } completion:nil];
            self.frame = self.smallFrame;
        }
        
        if (self.toFullScreenAction) {
            self.toFullScreenAction(btn);
        }
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.videoMaskView.frame = self.bounds;
    self.playerLayer.frame = self.bounds;
    
}

- (void)playBtnClick: (UIButton *)button {
    button.selected = !button.selected;
    
    if (button.selected) {
        
        self.isUserPause = NO;
        if (self.playerState != Playing) {
            [self.videoMaskView.activityView stopAnimating];
            [self play];
        }else {
            [self play];
        }
        
    }else {
        self.isUserPause = YES;
        [self pause];
    }
    
}

// 应用退到后台
- (void)appDidEnterBackground
{
    [self pause];
}

// 应用进入前台
- (void)appDidEnterPlayGround
{
    if (!self.isUserPause) {
        [self play];
    }
}

- (void)play {
    
    [self.player play];
    self.videoMaskView.playBtn.selected = YES;
    self.playerState = Playing;
}

- (void)pause {
    
    [self.player pause];
    self.videoMaskView.playBtn.selected = NO;
    self.playerState = Pause;
}

- (void)setVideoUrlStr:(NSString *)videoUrlStr {
    
    _videoUrlStr = videoUrlStr;
    
    self.isUserPause = NO;
    
    //将之前的监听时间移除掉。
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    self.playerItem = nil;
    
    if ([NSURL URLWithString:videoUrlStr]) {
        self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:videoUrlStr]];
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
        if([[UIDevice currentDevice] systemVersion].floatValue >= 10.0){
            //      增加下面这行可以解决iOS10兼容性问题了
            self.player.automaticallyWaitsToMinimizeStalling = NO;
        }
        // AVPlayer播放完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playInterrupt:) name:AVPlayerItemPlaybackStalledNotification object:self.playerItem];
        // 监听播放状态
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        // 监听loadedTimeRanges属性
        [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        
        [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
        // Will warn you when your buffer is good to go again.
        [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
       // [self setTheProgressOfPlayTime];
        [self play];
        [self.videoMaskView.activityView startAnimating];
    }
}

#pragma  mark - 调整layer frame



- (void)playInterrupt: (NSNotification *)notification {
    
    [self.videoMaskView.activityView startAnimating];
}

- (void)playDidEnd:(NSNotification *)notification
{
    
    [self.videoMaskView.activityView stopAnimating];
    
    __weak typeof(self) weakself = self;
    [self.player seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finish){
        
        [weakself.videoMaskView.videoSlider setValue:0.0 animated:YES];
        weakself.videoMaskView.currentTimeLabel.text = @"00:00";
        
    }];
    
    self.playerState = Stoped;
    self.videoMaskView.playBtn.selected = NO;
    
    if (self.playEndBlock) {
        self.playEndBlock();
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerDidPlayToEndTime)]) {
        [self.delegate playerDidPlayToEndTime];
    }
}


- (void)addTargetOnSlider {
    
    [self.videoMaskView.videoSlider removeTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    [self.videoMaskView.videoSlider addTarget:self action:@selector(progressSliderTouchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.videoMaskView.videoSlider removeTarget:self action:@selector(progressSliderTouchEnd:) forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    
    [self.videoMaskView.videoSlider removeTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown]; 
    
    [self.videoMaskView.videoSlider addTarget:self action:@selector(progressSliderTouchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.videoMaskView.videoSlider addTarget:self action:@selector(progressSliderTouchEnd:) forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
   if (object == self.playerItem) {
        if ([keyPath isEqualToString:@"status"]) {
            
            if (self.player.status == AVPlayerStatusReadyToPlay) {
                [self.videoMaskView.activityView startAnimating];
                [self play];
                [self addTargetOnSlider];
                
            } else if (self.player.status == AVPlayerStatusFailed){
                [self.videoMaskView.activityView startAnimating];
                TJMLog(@"不能播放");
            }
        } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
            CMTime duration             = self.playerItem.duration;
            CGFloat totalDuration       = CMTimeGetSeconds(duration);
            [self.videoMaskView.progessView setProgress:timeInterval / totalDuration animated:NO];
            
        }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            [self.videoMaskView.activityView stopAnimating];
            
        }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            
            [self.videoMaskView.activityView startAnimating];
        }
   }
}

- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (double)playProgessScale {
    
    double scale = (double)self.currentPlayTime / (double)self.totalTime;
    
    return scale;
}

-(void)dealloc {
    
    TJMLog(@"VideoPlayer销毁了");
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}


@end
