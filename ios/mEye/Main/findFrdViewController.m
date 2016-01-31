//
//  findFrdViewController.m
//  ipjsua
//
//  Created by HoJolin on 16/1/31.
//  Copyright © 2016年 Teluu. All rights reserved.
//

#import "findFrdViewController.h"

@interface findFrdViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation findFrdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _nicknameLabel.text = _data[@"nickName"];
    _addButton.layer.cornerRadius = 5;
    _addButton.layer.masksToBounds = YES;
    // Do any additional setup after loading the view.
}
- (IBAction)addButtonClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
