//
//  FirstViewController.m
//  GoodLuck
//
//  Created by HoJolin on 15/12/8.
//
//

#import "FirstViewController.h"
#import "API.h"

@interface FirstViewController () <UIAlertViewDelegate, APIProtocol> {
    API *myAPI;
}

@end

@implementation FirstViewController
- (IBAction)loginButtonClick:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"用户登录" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alert show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    myAPI = [[API alloc]init];
    myAPI.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [myAPI login:[alertView textFieldAtIndex:0].text password:[alertView textFieldAtIndex:1].text];
    }
}

- (void)didReceiveAPIErrorOf:(API *)api data:(int)errorNo {
    NSLog(@"%d", errorNo);
}

- (void)didReceiveAPIResponseOf:(API *)api data:(NSDictionary *)data {
    NSLog(@"%@", data);
    NSString *status_code = data[@"status_code"];
    if ([status_code intValue] != 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:data[@"status_text"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    } else {
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
        [ud synchronize];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *vc = [mainStoryboard instantiateInitialViewController];
        [self presentViewController:vc animated:YES completion:nil];
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
