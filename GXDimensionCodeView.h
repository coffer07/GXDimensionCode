//
//  GXDimensionCodeView.h
//  GXProject
//
//  Created by gaoxiang on 15/11/15.
//  Copyright © 2015年 gaoxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface GXDimensionCodeView : UIView


@property (strong,nonatomic)AVCaptureDevice *device;

@property (strong,nonatomic)AVCaptureDeviceInput *input;

@property (strong,nonatomic)AVCaptureMetadataOutput *output;

@property (strong,nonatomic)AVCaptureSession *session;

@property (strong,nonatomic)AVCaptureVideoPreviewLayer *preview;

//需要扫描时候启动, 默认扫描区域是GXDimensionCodeView中心区域
- (void)startDimensionCode;

@end
