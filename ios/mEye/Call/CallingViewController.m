//
//  CallingViewController.m
//  ipjsua
//
//  Created by HoJolin on 15/12/10.
//  Copyright © 2015年 Teluu. All rights reserved.
//

#import "CallingViewController.h"
#import "ipjsuaAppDelegate.h"
#include "pjsua_app_common.h"

void pjsua_call_hangup_all();
void ui_answer_call();
void ui_make_new_call(char *to_sip);
void vid_handle_menu(char *menuin);

@interface CallingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *answerButton;
@property (weak, nonatomic) IBOutlet UIButton *huangupButton;

@end

@implementation CallingViewController
- (IBAction)hangup:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)capSwitch:(UISwitch *)sender {
    if (sender.on) {
        char menuin[80] = "vid dev prev on 2";
        vid_handle_menu(menuin);
    } else {
        char menuin[80] = "vid dev prev off 2";
        vid_handle_menu(menuin);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _huangupButton.layer.cornerRadius = 30;
    _huangupButton.layer.masksToBounds = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)answerButtonClick:(id)sender {
    ui_answer_call();
    _answerButton.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    ipjsuaAppDelegate *app = [UIApplication sharedApplication].delegate;
    app.currentCall = self;
//    char menuin[80] = "vid dev prev on 2";
//    vid_handle_menu(menuin);
    if (_toSip) {
        char to_sip[80] = "sip:";
        strcat(to_sip, [_toSip UTF8String]);
        strcat(to_sip, "@");
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        strcat(to_sip, [[ud objectForKey:@"serviceUrl"]UTF8String]);
        NSLog(@"%s", to_sip);
        ui_make_new_call(to_sip);
        _answerButton.hidden = YES;
//        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showSelf) userInfo:nil repeats:NO];
//        [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(timesup) userInfo:nil repeats:NO];
    } else {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        if ([[ud objectForKey:@"videoStatus"]isEqualToString:@"0"]) {
            ui_answer_call();
            _answerButton.hidden = YES;
        } else {
            _answerButton.hidden = NO;
        }
    }
}

- (void)showSelf {
    char menuin[80] = "vid dev prev on 2";
    vid_handle_menu(menuin);
}

- (void)timesup {
    char menuin[80] = "vid win show 1";
    vid_handle_menu(menuin);
}

- (void)viewWillDisappear:(BOOL)animated {
    ipjsuaAppDelegate *app = [UIApplication sharedApplication].delegate;
    app.currentCall = nil;
    pjsua_call_hangup_all();
    char menuin[80] = "vid dev prev off 2";
    vid_handle_menu(menuin);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:nil];
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
