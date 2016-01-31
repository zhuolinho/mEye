//
//  LoginViewController.m
//  ipjsua
//
//  Created by JuZhen on 16/1/16.
//  Copyright © 2016年 Teluu. All rights reserved.
//

#import "LoginViewController.h"
#import "API.h"


@interface LoginViewController ()<APIProtocol> {
    API *myAPI;
}


@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myAPI = [[API alloc]init];
    myAPI.delegate = self;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LoginBottonPress:(id)sender {
    NSLog(@"login button pressed");
    [myAPI login:_phoneNumber.text password: _password.text];
}
- (IBAction)viewTouch:(id)sender {
    [_phoneNumber resignFirstResponder];
    [_password resignFirstResponder];
}

- (void)didReceiveAPIResponseOf: (API *)api data: (NSDictionary *)data{
    NSLog(@"%@", data);
    NSString *status_code = data[@"status_code"];
    if ([status_code intValue] != 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:data[@"status_text"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    } else {
        NSLog(@"%@", data);
        NSDictionary *dic = data[@"data"];
        NSArray *keys= [dic allKeys];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        //遍历keys
        for(int i=0;i<[keys count];i++)
        {
            //得到当前key
            NSString *key=[keys objectAtIndex:i];
            //添加分界线，换行
            [ud setObject:[dic objectForKey:key] forKey:key];
        }
//        [ud setObject:self.phoneNumber.text forKey:@"PickNameDisplay"];
        [ud synchronize];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *vc = [mainStoryboard instantiateInitialViewController];
        [self presentViewController:vc animated:YES completion:nil];
    }
}
- (void)didReceiveAPIErrorOf: (API *)api data: (int)errorNo{
    NSLog(@"%d", errorNo);
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
