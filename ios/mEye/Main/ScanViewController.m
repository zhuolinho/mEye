//
//  ScanViewController.m
//  ShareSDKDemo
//
//  Created by shenyang on 15/9/3.
//  Copyright (c) 2015年 shenyang. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "API.h"
#import "findFrdViewController.h"

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate,APIProtocol> {
    API *myAPI;
}

@property ( strong , nonatomic ) AVCaptureDevice * device;
@property ( strong , nonatomic ) AVCaptureDeviceInput * input;
@property ( strong , nonatomic ) AVCaptureMetadataOutput * output;
@property ( strong , nonatomic ) AVCaptureSession * session;
@property ( strong , nonatomic ) AVCaptureVideoPreviewLayer * preview;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myAPI = [[API alloc]init];
    myAPI.delegate = self;
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"相机权限受限" message:@"请在iPhone的“设置”－“隐私”－“相机”功能中，找到应用程序“立马订车位”更改权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.tag = 999;
        [alert show];
        return;
    }
    // Do any additional setup after loading the view.
    // Device
    _device = [ AVCaptureDevice defaultDeviceWithMediaType : AVMediaTypeVideo ];
    
    // Input
    _input = [ AVCaptureDeviceInput deviceInputWithDevice : self . device error : nil ];
    
    // Output
    _output = [[ AVCaptureMetadataOutput alloc ] init ];
    [ _output setMetadataObjectsDelegate : self queue : dispatch_get_main_queue ()];
    
    // Session
    _session = [[ AVCaptureSession alloc ] init ];
    [ _session setSessionPreset : AVCaptureSessionPresetHigh ];
    if ([ _session canAddInput : self . input ])
    {
        [ _session addInput : self . input ];
    }
    
    if ([ _session canAddOutput : self . output ])
    {
        [ _session addOutput : self . output ];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output . metadataObjectTypes = @[ AVMetadataObjectTypeQRCode ] ;
    
    // Preview
    _preview =[ AVCaptureVideoPreviewLayer layerWithSession : _session ];
    _preview . videoGravity = AVLayerVideoGravityResizeAspectFill ;
    _preview . frame = self . view . layer . bounds ;
    [ self . view . layer insertSublayer : _preview atIndex : 0 ];
    // Start
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [ _session startRunning ];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

- ( void )captureOutput:( AVCaptureOutput *)captureOutput didOutputMetadataObjects:( NSArray *)metadataObjects fromConnection:( AVCaptureConnection *)connection
{
    if ([metadataObjects count] > 0 )
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        // 停止扫描
        NSString *str = metadataObject.stringValue;
        
        if (str.length > 22) {
            if ([[str substringToIndex:20]isEqualToString:@"yarlungsoft/addUser:"]) {
                NSArray *arr = [str componentsSeparatedByString:@":"];
                if (arr.count > 1) {
                    [ _session stopRunning];
                    [myAPI findUser:arr[1]];
                }
            }
        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 999) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [ _session startRunning ];
    }
}

- (void)didReceiveAPIErrorOf:(API *)api data:(int)errorNo {
    NSLog(@"%d", errorNo);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络错误" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveAPIResponseOf:(API *)api data:(NSDictionary *)data {
    if ([data[@"status_code"]intValue] == 0) {
        findFrdViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"findFrdViewController"];
        vc.data = data[@"data"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:data[@"status_text"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
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
