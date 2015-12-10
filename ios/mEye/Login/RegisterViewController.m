//
//  RegisterViewController.m
//  GoodLuck
//
//  Created by HoJolin on 15/12/8.
//
//

#import "RegisterViewController.h"
#import "API.h"
#import "ValueCodeViewController.h"

@interface RegisterViewController () <APIProtocol> {
    API *myAPI;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation RegisterViewController
- (IBAction)nextButtonClick:(id)sender {
    [myAPI registerAccount:_phoneTF.text];
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
        ValueCodeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ValueCodeViewController"];
        vc.password = _passwordTF.text;
        vc.phone = _phoneTF.text;
        [self.navigationController pushViewController:vc animated:YES];
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
