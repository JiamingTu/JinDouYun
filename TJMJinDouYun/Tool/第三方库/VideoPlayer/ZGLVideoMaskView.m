

//
//  ZGLVideoMaskView.m
//  ZGLVideoPlayer
//
//  Created by 智捷电商APPLE01 on 16/12/1.
//  Copyright © 2016年 智捷电商APPLE01. All rights reserved.
//

#import "ZGLVideoMaskView.h"


@interface ZGLVideoMaskView ()

@property (nonatomic, copy) ButtonClick playBtnClick;

@property (nonatomic, copy) ButtonClick fullScreenBtnClick;

@end

@implementation ZGLVideoMaskView



- (instancetype)initWithFrame:(CGRect)frame
                 playBtnClick: (void (^) (UIButton *playBtn))playBtnClick
                 fullScreenBtnClick: (void (^) (UIButton *fullScreenBtn))fullScreenBtnClick {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.userInteractionEnabled = YES;
        self.playBtnClick = playBtnClick;
        self.fullScreenBtnClick = fullScreenBtnClick;
        
        UITapGestureRecognizer *hidenTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenBottonView:)];
        
        [self addGestureRecognizer:hidenTap];
    }
    
    return self;
}

- (void)hiddenBottonView: (UITapGestureRecognizer *)tap {

    if (self.bottomBackgroundView.hidden) {
        self.bottomBackgroundView.hidden = NO;
    }else {
        
        self.bottomBackgroundView.hidden = YES;
    }
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    [self createViews];
}

-(void)createViews {
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.playBtn setImage:[UIImage imageNamed:@"videoPlayBtn"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"videoPauseBtn"] forState:UIControlStateSelected];
    
    self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self addSubview:self.activityView];
    
    self.bottomBackgroundView = [[UIView alloc] init];
    self.bottomBackgroundView.backgroundColor = [UIColor blackColor];
    self.bottomBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:self.bottomBackgroundView];
    [self.bottomBackgroundView addSubview:self.playBtn];
    
    self.currentTimeLabel = [[UILabel alloc]init];
    self.currentTimeLabel.font = [UIFont systemFontOfSize:11];
    self.currentTimeLabel.textColor = [UIColor whiteColor];
    self.currentTimeLabel.text = @"00:00";
    self.currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.bottomBackgroundView addSubview:self.currentTimeLabel];
    
    self.totalTimeLabel = [[UILabel alloc]init];
    self.totalTimeLabel.font = [UIFont systemFontOfSize:11];
    self.totalTimeLabel.textColor = [UIColor whiteColor];
    self.totalTimeLabel.text = @"00:00";
    self.totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.bottomBackgroundView addSubview:self.totalTimeLabel];
    
    self.fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fullScreenBtn addTarget:self action:@selector(fullScreenBtnCLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.fullScreenBtn setImage:[[UIImage imageNamed:@"kr-video-player-fullscreen"] scaleToSize:CGSizeMake(15, 15)] forState:UIControlStateNormal];
    [self.fullScreenBtn setImage:[[UIImage imageNamed:@"exitFullScreen"] scaleToSize:CGSizeMake(20, 20)] forState:UIControlStateSelected];
    [self.bottomBackgroundView addSubview:self.fullScreenBtn];
    
    self.videoSlider = [[UISlider alloc]init];
    [self.videoSlider setThumbImage:[UIImage imageNamed:@"videoPlayerSlider"] forState:UIControlStateNormal];
    self.videoSlider.minimumTrackTintColor = [UIColor whiteColor];
    self.videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
    [self.bottomBackgroundView addSubview:self.videoSlider];
    
    self.progessView = [[UIProgressView alloc]init];
    self.progessView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6];
    self.progessView.trackTintColor = [UIColor clearColor];
    
    [self.bottomBackgroundView addSubview:self.progessView];
}

//playBtnClick
- (void)playBtnClick: (UIButton *)button {
    
    if (self.playBtnClick != nil) {
        self.playBtnClick(button);
    }
}

- (void)fullScreenBtnCLick: (UIButton *)button {
    
    if (self.fullScreenBtnClick != nil) {
        self.fullScreenBtnClick (button);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    CGFloat heihgt = self.frame.size.height;
    
    self.playBtn.frame = CGRectMake(0, 0, 50, 50);
    
    CGPoint center = CGPointMake(width / 2, heihgt / 2);
    self.activityView.center = center;
    
    self.bottomBackgroundView.frame = CGRectMake(0, heihgt - 50, width, 50);
    
    self.currentTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.playBtn.frame), 0, 60, self.bottomBackgroundView.frame.size.height);
    self.fullScreenBtn.frame = CGRectMake(width - 50, 0, 50, self.bottomBackgroundView.frame.size.height);
    CGFloat totalX = CGRectGetMinX(self.fullScreenBtn.frame);
    self.totalTimeLabel.frame = CGRectMake(totalX - 60, 0, 60, self.bottomBackgroundView.frame.size.height);
    
    
    CGFloat sliderWidth = width - (220);
    self.videoSlider.frame = CGRectMake(CGRectGetMaxX(self.currentTimeLabel.frame), 0, sliderWidth, self.bottomBackgroundView.frame.size.height);
    
    self.progessView.frame = CGRectMake(CGRectGetMaxX(self.currentTimeLabel.frame), 24, sliderWidth, self.bottomBackgroundView.frame.size.height + 3);
}

@end
