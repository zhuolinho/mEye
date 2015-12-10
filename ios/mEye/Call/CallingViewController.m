//
//  CallingViewController.m
//  ipjsua
//
//  Created by HoJolin on 15/12/10.
//  Copyright © 2015年 Teluu. All rights reserved.
//

#import "CallingViewController.h"
#import "ipjsuaAppDelegate.h"

@interface CallingViewController ()

@end

@implementation CallingViewController
- (IBAction)hangup:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    ipjsuaAppDelegate *app = [UIApplication sharedApplication].delegate;
    app.currentCall = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    ipjsuaAppDelegate *app = [UIApplication sharedApplication].delegate;
    app.currentCall = nil;
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
