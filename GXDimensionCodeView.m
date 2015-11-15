//
//  GXDimensionCodeView.m
//  GXProject
//
//  Created by gaoxiang on 15/11/15.
//  Copyright © 2015年 gaoxiang. All rights reserved.
//

#import "GXDimensionCodeView.h"

@interface GXDimensionCodeView ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic,weak)UIView *boxView;
@property (nonatomic,weak)CALayer *scanLayer;

@property (nonatomic,strong)NSTimer *timer;

@end

@implementation GXDimensionCodeView

- (void)startDimensionCode
{
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([self.session canAddInput:self.input])
    {
        
        [self.session addInput:self.input];
    }

    if ([self.session canAddOutput:self.output])
    {
        [self.session addOutput:self.output];
        
    }
    self.output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    self.preview = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = self.bounds;
    [self.layer insertSublayer:self.preview atIndex:0];
    
    //设置扫描区域
    self.output.rectOfInterest = CGRectMake(0.3f, 0.2f, 0.4f, 0.6f);
    //设置扫描的边框
    UIView *boxView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width * 0.2f, self.bounds.size.height * 0.3f, self.bounds.size.width*0.6f, self.bounds.size.height*0.4f)];
    boxView.layer.borderColor = [UIColor greenColor].CGColor;
    boxView.layer.borderWidth = 1.0f;
    [self addSubview:boxView];
    self.boxView = boxView;
    //10.2.扫描线
    CALayer *scanLayer = [[CALayer alloc] init];
    scanLayer.frame = CGRectMake(0, 0, boxView.bounds.size.width, 1);
    scanLayer.backgroundColor = [UIColor brownColor].CGColor;
    [boxView.layer addSublayer:scanLayer];
    self.scanLayer = scanLayer;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    [self.timer fire];
    
    [self.session startRunning];
    

}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] >0)
    {
        //停止扫描
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        NSLog(@"扫描的描述信息%@",stringValue);
        
        [self.timer invalidate];
        self.timer = nil;
        self.scanLayer.hidden = YES;
    }
    
  

}

- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = self.scanLayer.frame;
    if (self.boxView.frame.size.height < self.scanLayer.frame.origin.y) {
        frame.origin.y = 0;
        self.scanLayer.frame = frame;
    }else{
        frame.origin.y += 5;
        [UIView animateWithDuration:0.1 animations:^{
            self.scanLayer.frame = frame;
        }];
    }
}


@end
