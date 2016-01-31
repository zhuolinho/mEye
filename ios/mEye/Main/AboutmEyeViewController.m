//
//  AboutmEyeViewController.m
//  ipjsua
//
//  Created by JuZhen on 16/1/23.
//  Copyright © 2016年 Teluu. All rights reserved.
//

#import "AboutmEyeViewController.h"

@interface AboutmEyeViewController ()

@end

@implementation AboutmEyeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    // Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated{
    self.parentViewController.tabBarController.tabBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    // Dispose of any resources that can be recreated.
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
