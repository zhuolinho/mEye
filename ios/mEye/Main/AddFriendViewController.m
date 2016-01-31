//
//  AddFriendViewController.m
//  ipjsua
//
//  Created by JuZhen on 16/1/23.
//  Copyright © 2016年 Teluu. All rights reserved.
//

#import "AddFriendViewController.h"
#import "AddPersonFriendlistDelegate.h"
#import "PeopleListViewController.h"
#import "API.h"
@interface AddFriendViewController ()<APIProtocol>{
    //PeopleListViewController<AddPersonFriendlistDelegate> * delegate;
    API* myAPI;
    
}
//@property (weak, nonatomic) IBOutlet UILabel *PickName;
//@property (weak, nonatomic) IBOutlet UILabel *PhoneNumber;

@property (weak, nonatomic) IBOutlet UITextField *PickName;
@property (weak, nonatomic) IBOutlet UITextField *PhoneNumber;

@property (weak, nonatomic) IBOutlet UIImageView *RootImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ChildImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *ChildImageVIew2;

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myAPI = [[API alloc]init];
    myAPI.delegate = self;
    self.title = @"添加好友";
   // delegate = self.parentViewController;
    self.tabBarController.tabBar.hidden = YES;
    self.RootImageView.layer.masksToBounds=YES;
    self.ChildImageView1.layer.masksToBounds=YES;
    self.ChildImageVIew2.layer.masksToBounds=YES;
    self.RootImageView.layer.cornerRadius=6.0;
    self.ChildImageView1.layer.cornerRadius=6.0;
    self.ChildImageVIew2.layer.cornerRadius=6.0;
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    self.parentViewController.tabBarController.tabBar.hidden = NO;
}
- (IBAction)AddPersonToFriendList:(id)sender {
    [myAPI searchFriendByPhone:[self PhoneNumber].text];
    //[delegate addFriendUsingDelegate:self.PickName.text];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.PickName.text forKey:@"NewAddPeople"];
    [defaults setObject:@"YES" forKey:@"isAddingFriend"];
    
    //设置同步
    [defaults synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveAPIResponseOf: (API *)api data: (NSDictionary *)data{
    NSLog(@"%@", data);
    NSLog(@"%@", data);
    
    //    NSString *status_code = data[@"status_code"];
    //    if ([status_code intValue] != 0) {
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:data[@"status_text"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    //        [alert show];
    //    } else {
    //        NSDictionary *dic = data[@"data"];
    //        NSArray *keys= [dic allKeys];
    //        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //        //遍历keys
    //        for(int i=0;i<[keys count];i++)
    //        {
    //            //得到当前key
    //            NSString *key=[keys objectAtIndex:i];
    //            //添加分界线，换行
    //            [ud setObject:[dic objectForKey:key] forKey:key];
    //        }
    //        [ud setObject:self._phoneNumber.text forKey:@"PickNameDisplay"];
    //        [ud synchronize];
    //        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //        UITabBarController *vc = [mainStoryboard instantiateInitialViewController];
    //        [self presentViewController:vc animated:YES completion:nil];
    //    }
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
