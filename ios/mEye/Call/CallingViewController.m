//
//  CallingViewController.m
//  ipjsua
//
//  Created by HoJolin on 15/12/10.
//  Copyright © 2015年 Teluu. All rights reserved.
//

#import "CallingViewController.h"
#import "ipjsuaAppDelegate.h"

void pjsua_call_hangup_all();
void ui_answer_call();
void ui_make_new_call(char *to_sip);

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
    if (_toSip) {
        char to_sip[80] = "sip:";
        strcat(to_sip, [_toSip UTF8String]);
        strcat(to_sip, "@");
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        strcat(to_sip, [[ud objectForKey:@"serviceUrl"]UTF8String]);
        NSLog(@"%s", to_sip);
        ui_make_new_call(to_sip);
    } else {
        ui_answer_call();
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    ipjsuaAppDelegate *app = [UIApplication sharedApplication].delegate;
    app.currentCall = nil;
    pjsua_call_hangup_all();
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
