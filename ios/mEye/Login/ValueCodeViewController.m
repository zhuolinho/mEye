//
//  ValueCodeViewController.m
//  GoodLuck
//
//  Created by HoJolin on 15/12/8.
//
//

#import "ValueCodeViewController.h"
#import "API.h"

@interface ValueCodeViewController () <APIProtocol> {
    API *myAPI;
}
@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@end

@implementation ValueCodeViewController
- (IBAction)doneButtonClick:(id)sender {
    [myAPI checkCode:_phone password:_password code:_codeTF.text];
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

- (void)didReceiveAPIResponseOf:(API *)api data:(NSDictionary *)data {
    NSLog(@"%@", data);
    NSString *status_code = data[@"status_code"];
    if ([status_code intValue] != 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"验证码错误" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
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

- (void)didReceiveAPIErrorOf:(API *)api data:(int)errorNo {
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
