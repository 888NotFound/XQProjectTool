//
//  XQSystemCameraManager.m
//  智家二维码
//
//  Created by WXQ on 2018/5/30.
//  Copyright © 2018年 农宝财. All rights reserved.
//

#import "XQSystemCameraManager.h"
#import <AVFoundation/AVFoundation.h>

#define XQ_Screen_Width [UIScreen mainScreen].bounds.size.width
#define XQ_Screen_Height [UIScreen mainScreen].bounds.size.height

@interface XQSystemCameraManager () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureDevice * device;//捕获设备，默认后置摄像头
@property (strong, nonatomic) AVCaptureDeviceInput * input; //输入设备
@property (strong, nonatomic) AVCaptureMetadataOutput * output;//输出设备，需要指定他的输出类型及扫描范围
@property (strong, nonatomic) AVCaptureSession * session; //AVFoundation框架捕获类的中心枢纽，协调输入输出设备以获得数据
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * previewLayer;//展示捕获图像的图层，是CALayer的子类

@property (nonatomic, copy) XQSystemCameraManagerCallback callback;

@end

@implementation XQSystemCameraManager

static XQSystemCameraManager *manager_ = nil;

+ (XQSystemCameraManager *)manager {
    return manager_;
}

+ (BOOL)startScanWithCallback:(XQSystemCameraManagerCallback)callback {
    return [self startScanWithRectOfInterest:CGRectMake(0, 0, 1, 1) callback:callback];
}

+ (BOOL)startScanWithRectOfInterest:(CGRect)rectOfInterest callback:(XQSystemCameraManagerCallback)callback {
    if ([self manager]) {
        NSLog(@"已存在相机");
        return NO;
    }
    NSLog(@"%@", NSStringFromCGRect(rectOfInterest));
    manager_ = [XQSystemCameraManager new];
    manager_.callback = callback;
    return [manager_ startWithRectOfInterest:rectOfInterest];
}

/**
 停止, 并销毁
 */
+ (void)destroyCamera {
    if (![self manager]) {
        NSLog(@"不存在相机");
        return;
    }
    
    [[self manager] stop];
    manager_ = nil;
}

+ (void)start {
    if (![self manager]) {
        NSLog(@"不存在相机");
        return;
    }
    [[self manager] start];
}

+ (void)stop {
    if (![self manager]) {
        NSLog(@"不存在相机");
        return;
    }
    
    [[self manager] stop];
}

+ (CALayer *)getVideoLayerWithFrame:(CGRect)frame {
    if (![self manager]) {
        NSLog(@"不存在相机");
        return nil;
    }
    [[self manager] initPreLayerWithFrame:frame];
    return [self manager].previewLayer;
}

- (void)initPreLayerWithFrame:(CGRect)frame {
    if (!self.previewLayer) {
        [self initCaptureWithRectOfInterest:CGRectMake(0, 0, 1, 1)];
        //预览层 初始化，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
            //预览层的区域设置为整个屏幕，这样可以方便我们进行移动二维码到扫描区域,在上面我们已经对我们的扫描区域进行了相应的设置
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    
    self.previewLayer.frame = frame;
}

- (BOOL)startWithRectOfInterest:(CGRect)rectOfInterest {
    if (self.session) {
        NSLog(@"已存在, 请先关闭");
        return NO;
    }
    
    [self initCaptureWithRectOfInterest:rectOfInterest];
    [self start];
    return YES;
}

- (void)initCaptureWithRectOfInterest:(CGRect)rectOfInterest {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus != AVAuthorizationStatusAuthorized &&
        authStatus != AVAuthorizationStatusNotDetermined) {
        NSLog(@"权限不足,无法使用该功能");
        return;
    }
    
    if (self.session) {
        return;
    }
        //默认使用后置摄像头进行扫描,使用AVMediaTypeVideo表示视频
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        //设备输入 初始化
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
        //设备输出 初始化，并设置代理和回调，当设备扫描到数据时通过该代理输出队列，一般输出队列都设置为主队列，也是设置了回调方法执行所在的队列环境
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //会话 初始化，通过 会话 连接设备的 输入 输出，并设置采样质量为 高
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
        //会话添加设备的 输入 输出，建立连接
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
        //指定设备的识别类型 这里只指定二维码识别这一种类型 AVMetadataObjectTypeQRCode
        //指定识别类型这一步一定要在输出添加到会话之后，否则设备的课识别类型会为空，程序会出现崩溃
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
        //(y,x,h,w)
    [self.output setRectOfInterest:rectOfInterest];
}

- (void)start {
        //开始启动
    [self.session startRunning];
}

- (void)stop {
    //停止扫描
    [self.session stopRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
    //后置摄像头扫描到二维码的信息
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if ([metadataObjects count] > 0) {
        NSMutableArray *muArr = [NSMutableArray array];
            //数组中包含的都是AVMetadataMachineReadableCodeObject 类型的对象，该对象中包含解码后的数据
        for (AVMetadataMachineReadableCodeObject *obj in metadataObjects) {
            [muArr addObject:obj.stringValue];
        }
        NSLog(@"扫描结果 %@", muArr);
        if (self.callback) {
            self.callback(muArr.copy);
        }
    }
}

- (void)dealloc {
    NSLog(@"%s 系统相机扫描释放", __func__);
}

@end
































