//
//  SettingTableViewController.m
//  ipjsua
//
//  Created by JuZhen on 16/1/19.
//  Copyright © 2016年 Teluu. All rights reserved.
//

#import "SettingTableViewController.h"

@interface SettingTableViewController ()<UIAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *UserImage;

@property (weak, nonatomic) IBOutlet UILabel *UserName;

@property (weak, nonatomic) IBOutlet UILabel *OtherSetting;

@property (weak, nonatomic) IBOutlet UITableViewCell *Logout;

@property (weak, nonatomic) IBOutlet UITableViewCell *Exit;

@property (weak, nonatomic) IBOutlet UITableViewCell *RemoveMemory;

@property (weak, nonatomic) IBOutlet UITableViewCell *ABout;

@property (weak, nonatomic) IBOutlet UILabel *pickName;

@end

@implementation SettingTableViewController


- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.ABout.textLabel.text=@"关于猫在家";
    self.Logout.textLabel.text=@"退出登录";
    self.RemoveMemory.textLabel.text=@"清除缓存";
    self.Exit.textLabel.text=@"退出程序";
    
    NSUserDefaults * nd = [NSUserDefaults standardUserDefaults];
    //self.pickName.text= [nd objectForKey:@"PickNameDisplay"];
    self.pickName.text= [nd objectForKey:@"nickName"];

//    UIImage * title_bg = [UIImage imageNamed:@"navigation-bar.png"];
//    CGSize titleSize = self.navigationController.navigationBar.bounds.size;
//    title_bg = [self scaleToSize:title_bg size:titleSize];
//    [self.navigationController.navigationBar setBackgroundImage:title_bg forBarMetrics:UIBarMetricsDefault];    // Uncomment the following line to preserve selection between presentations.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    //NSString *titileString = [arrayobjectAtIndex:[indexPath row]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //NSLog(@"％d",buttonIndex);
    if (buttonIndex != alertView.cancelButtonIndex) {
        if([alertView tag] == 1){
            exit(0);
        }
        else if([alertView tag] == 2){
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSDictionary* dict =[ud dictionaryRepresentation];
            for(id key in dict){
                [ud removeObjectForKey:key];
            }
            [ud synchronize];
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            UITabBarController *vc = [mainStoryboard instantiateInitialViewController];
            //[self presentationController:vc animated:YES completion:nil];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1) {
        if(indexPath.row == 1){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"退出程序" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert setTag:1];
                //alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
                //alert.alertViewStyle = UIAlertControllerStyleAlert;
                alert.alertViewStyle = UIAlertViewStyleDefault;
                [alert show];
            //exit(0);
        }
        else if(indexPath.row == 0){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"退出登录" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert setTag:2];
            alert.alertViewStyle = UIAlertViewStyleDefault;
            [alert show];
        }
    }

}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if(section == 0)
        return 1;
    else
        return 4;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
