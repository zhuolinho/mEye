//
//  MainTabBarController.m
//  ipjsua
//
//  Created by HoJolin on 15/12/15.
//  Copyright © 2015年 Teluu. All rights reserved.
//

#import "MainTabBarController.h"
#include "pjsua_app_common.h"

void ui_add_account(pjsua_transport_config *rtp_cfg, char *registrar, char *id, char *uname, char *passwd);

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    char registrar[80] = "sip:";
    char userId[80] = "sip:";
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *userName = [ud objectForKey:@"userName"];
    NSString *password = [ud objectForKey:@"password"];
    NSString *serviceUrl = [ud objectForKey:@"serviceUrl"];
    strcat(registrar, [serviceUrl UTF8String]);
    strcat(userId, [userName UTF8String]);
    strcat(userId, "@");
    strcat(userId, [serviceUrl UTF8String]);
    pj_thread_desc  desc;
    pj_thread_t*    thread = 0;
    if (!pj_thread_is_registered())
    {
        pj_thread_register(NULL, desc, &thread);
    }
    ui_add_account(&app_config.rtp_cfg, registrar, userId, [userName UTF8String], [password UTF8String]);
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
