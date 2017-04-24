//
//  TJMScanQRCodeViewController.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/24.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "TJMScanQRCodeViewController.h"
#import "TJMOverlayView.h"
@interface TJMScanQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    TJMOverlayView *_overLayView;
}
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureDeviceInput *input;
@property (nonatomic,strong) AVCaptureMetadataOutput *output;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation TJMScanQRCodeViewController
#pragma  mark - lazy loading
/**
 视频输入设备
 */
-(AVCaptureDeviceInput *)input{
    if (!_input) {
        //获取输入设备（摄像头）
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        //根据输入设备创建输入对象
        _input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    }
    return _input;
}

/**
 数据输出对象
 */
-(AVCaptureMetadataOutput *)output{
    if (!_output) {
        _output = [[AVCaptureMetadataOutput alloc]init];
        //设置代理监听输出对象输出的数据，在主线程刷新
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //设置扫描的区域
        //AVCaptureVideoPreviewLayer 的frame (0,0,ScreenWidth,ScreenHeight) (x,y,w,h)
        //扫描区域在self.view 的frame ((ScreenWidth - 220)/2,100,220,220)
        //(x1,y1,w1,h1)
        //扫描区域 （y1/h,x1/w,h1/h,w1/w）
        _output.rectOfInterest = CGRectMake(100.0/TJMScreenHeight, ((TJMScreenWidth - 220)/2)/TJMScreenWidth, 220.0/TJMScreenHeight, 220.0/TJMScreenWidth);
        
    }
    return _output;
}

/**
 会话对象
 */
-(AVCaptureSession *)session{
    if (!_session) {
        //创建会话
        _session = [[AVCaptureSession alloc]init];
        //实现高质量的输出和摄像 默认值AVCaptureSessionPresetHigh 可以不写
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        [self setupIODevice];
    }
    return _session;
}

//扫描视图
-(AVCaptureVideoPreviewLayer *)previewLayer{
    if (!_previewLayer) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _previewLayer.frame = self.view.bounds;
//        添加扫描图层
        _overLayView = [[TJMOverlayView alloc]initWithFrame:_previewLayer.frame];
        _overLayView.transparentArea = CGRectMake((TJMScreenWidth - 220)/2,100,220,220);
        [_previewLayer addSublayer:_overLayView.layer];


    }
    return _previewLayer;
}
#pragma  mark - config input & output
/**
 *  配置输入输出设置
 */
-(void)setupIODevice{
    if ([self.session canAddInput:self.input]) {
        [_session addInput:_input];
    }
    if ([self.session canAddOutput:self.output]) {
        [_session addOutput:_output];
    }
    //告诉输出对象, 需要输出什么样的数据 (二维码还是条形码等) 要先创建会话才能设置
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeAztecCode];
}

#pragma  mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.2f];
    [self.view.layer addSublayer:self.previewLayer];
    [self.session startRunning];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_overLayView stopAnimation];
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate
/**
 *  二维码扫描数据返回
 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = metadataObjects[0];
        NSLog(@"%@",metadataObject.stringValue);
    }
}
#pragma  mark - memory warning
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
