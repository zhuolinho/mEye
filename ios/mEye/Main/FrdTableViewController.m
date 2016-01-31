//
//  FrdTableViewController.m
//  ipjsua
//
//  Created by HoJolin on 15/12/15.
//  Copyright © 2015年 Teluu. All rights reserved.
//

#import "FrdTableViewController.h"
#import "CallingViewController.h"
#import "API.h"
#import "FrdTableViewCell.h"

@interface FrdTableViewController () <UIAlertViewDelegate, APIProtocol> {
    API *myAPI;
    NSArray *frdArr;
    UIView *viewa;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *videoSegment;

@end

@implementation FrdTableViewController
- (IBAction)addButtonClick:(id)sender {
    viewa.hidden = !viewa.hidden;
}
- (IBAction)segmentChange:(UISegmentedControl *)sender {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSString stringWithFormat:@"%ld", (long)sender.selectedSegmentIndex] forKey:@"videoStatus"];
    [ud synchronize];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        UIStoryboard *callingStoryboard = [UIStoryboard storyboardWithName:@"Call" bundle:nil];
        CallingViewController *vc = (CallingViewController *)[callingStoryboard instantiateInitialViewController];
        vc.toSip = [alertView textFieldAtIndex:0].text;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    viewa.frame = CGRectMake(220, scrollView.contentOffset.y + 64, 93, 142);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    viewa = [[UIView alloc]initWithFrame:CGRectMake(220, 0, 93, 142)];
    [self.view addSubview:viewa];
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(10, 17, 73, 25)];
    [viewa addSubview:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"moment"]]];
    [button1 setTitle:@"扫描二维码" forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:13];
    [button1 addTarget:self action:@selector(button1Click) forControlEvents:UIControlEventTouchUpInside];
    [viewa addSubview:button1];
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(10, 55, 73, 25)];
    [button2 setTitle:@"我的二维码" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:13];
    [button2 addTarget:self action:@selector(button2Click) forControlEvents:UIControlEventTouchUpInside];
    [viewa addSubview:button2];
    UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(10, 93, 73, 25)];
    [button3 setTitle:@"加好友" forState:UIControlStateNormal];
    button3.titleLabel.font = [UIFont systemFontOfSize:13];
    [button3 addTarget:self action:@selector(button3Click) forControlEvents:UIControlEventTouchUpInside];
    [viewa addSubview:button3];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    _videoSegment.selectedSegmentIndex = [[ud objectForKey:@"videoStatus"]intValue];
    myAPI = [[API alloc]init];
    myAPI.delegate = self;
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(refreshing) forControlEvents:UIControlEventValueChanged];
//    NSLog(@"%@",[ud objectForKey:@"videoStatus"]);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)button1Click {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScanViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)button2Click {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"QRViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)button3Click {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddFriendViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [myAPI getFriendList];
    viewa.hidden = YES;
}

- (void)refreshing {
    [myAPI getFriendList];
}

- (void)didReceiveAPIErrorOf:(API *)api data:(int)errorNo {
    NSLog(@"%d", errorNo);
    [self.refreshControl endRefreshing];
}

- (void)didReceiveAPIResponseOf:(API *)api data:(NSDictionary *)data {
    frdArr = data[@"data"];
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return frdArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (void)callButtonClick:(UIButton *)button {
    UIStoryboard *callingStoryboard = [UIStoryboard storyboardWithName:@"Call" bundle:nil];
    CallingViewController *vc = (CallingViewController *)[callingStoryboard instantiateInitialViewController];
    vc.toSip = frdArr[button.tag][@"userName"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FrdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FrdTableViewCell" forIndexPath:indexPath];
    UILabel *nameLabel = [cell viewWithTag:222];
    nameLabel.text = frdArr[indexPath.section][@"nickName"];
    UIImageView *avatarView = [cell viewWithTag:111];
    avatarView.layer.cornerRadius = 12;
    avatarView.layer.masksToBounds = YES;
    UIButton *online = [cell viewWithTag:333];
    online.userInteractionEnabled = NO;
    if ([frdArr[indexPath.section][@"videoStatus"]intValue] == 1) {
        [online setTitle:@"视频" forState:UIControlStateNormal];
    } else {
        [online setTitle:@"监控" forState:UIControlStateNormal];
    }
    cell.callButton.tag = indexPath.section;
    [cell.callButton addTarget:self action:@selector(callButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    NSString *savedFile = frdArr[indexPath.section][@"avatar"];
    if ([API getPicByKey:savedFile] == nil) {
        avatarView.image = [UIImage imageNamed:@"person"];
        NSString *str = [NSString stringWithFormat:@"%@%@", IMGHOST, savedFile];
        NSURL *url = [NSURL URLWithString:str];
        NSURLRequest *requst = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:requst queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError == nil) {
                UIImage *img = [UIImage imageWithData:data];
                if (img != nil) {
                    [API setPicByKey:savedFile pic:img];
                    avatarView.image = img;
                }
            }
        }];
    }
    else {
        avatarView.image = [API getPicByKey:savedFile];
    }
    // Configure the cell...
    
    return cell;
}


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
