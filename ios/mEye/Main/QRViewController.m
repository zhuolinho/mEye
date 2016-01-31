//
//  QRViewController.m
//  ipjsua
//
//  Created by HoJolin on 16/1/31.
//  Copyright © 2016年 Teluu. All rights reserved.
//

#import "QRViewController.h"
#import "UIImage+MDQRCode.h"

@interface QRViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *QRImg;

@end

@implementation QRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *str = [NSString stringWithFormat:@"yarlungsoft/addUser:%@", [ud objectForKey:@"userId"]];
    _QRImg.image = [UIImage mdQRCodeForString:str size:_QRImg.bounds.size.width fillColor:[UIColor darkGrayColor]];
    self.title = @"我的二维码";
    // Do any additional setup after loading the view.
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
