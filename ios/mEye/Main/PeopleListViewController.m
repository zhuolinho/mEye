//
//  PeopleListViewController.m
//  ipjsua
//
//  Created by JuZhen on 16/1/21.
//  Copyright © 2016年 Teluu. All rights reserved.
//

#import "PeopleListViewController.h"
#import "AddFriendViewController.h"
#import <objc/runtime.h>
#include "pjsua_app_common.h"
#import "CallingViewController.h"
#import "AddPersonFriendlistDelegate.h"
#import "API.h"
#define kSearchbarHeight 44

@interface PeopleListViewController ()<UISearchBarDelegate,UIAlertViewDelegate,APIProtocol>{
    API* myAPI;
}
@property (nonatomic, strong) UIRefreshControl* refreshControl;

@property (strong, nonatomic) IBOutlet UITableView * _tableView;

@end

@implementation PeopleListViewController{
    UISearchBar* _searchBar;
    //UITableView * _tableView;
    NSMutableArray* _PeopleList;
    NSMutableArray* _searchPeople;
    NSMutableArray* _FriendList;
    BOOL _isSearching;
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    myAPI = [[API alloc]init];
    myAPI.delegate = self;
    _FriendList =[[NSMutableArray alloc] init];
    [myAPI getFriendList];
    
    NSLog(@"%@",_FriendList);
    [self addSearchBar];
    [self initData];
    _isSearching = NO;
//    self._tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//    self._tableView.dataSource=self;
//    self._tableView.delegate=self;
//    [self.view addSubview:self._tableView];
    
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self
                        action:@selector(refreshView:)
              forControlEvents:UIControlEventValueChanged];
    [_refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"松手更新数据"]];
    [self._tableView addSubview:_refreshControl];
    
    
    
    
    UIImage * title_bg = [UIImage imageNamed:@"navigation-bar.png"];
    CGSize titleSize = self.navigationController.navigationBar.bounds.size;
    title_bg = [self scaleToSize:title_bg size:titleSize];
    [self.navigationController.navigationBar setBackgroundImage:title_bg forBarMetrics:UIBarMetricsDefault];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //[defaults setObject:self.PickName.text forKey:@"NewAddPeople"];
    [defaults setObject:@"NO" forKey:@"isAddingFriend"];
    
    //设置同步
    [defaults synchronize];
    // Do any additional setup after loading the view.
}
//-(void)addFriendUsingDelegate:(NSString *)addPersonName{
//    [_PeopleList addObject:addPersonName];
//    [self._tableView reloadData];
//}
-(void) initData{
    _PeopleList = [NSMutableArray arrayWithObjects:@"Matrix",@"MiYang",@"ShenYang",@"Matrix1",@"MiYang1",@"ShenYang1", @"Matrix2",@"MiYang2",@"ShenYang2",  nil];
}


- (void)viewWillAppear:(BOOL)animated {
}
-(void)viewDidAppear:(BOOL)animated{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //[defaults setObject:@"YES" forKey:@"isAddingFriend"];
    if([[defaults objectForKey:@"isAddingFriend"]  isEqual: @"YES"]){
        [defaults setObject:@"NO" forKey:@"isAddingFriend"];
        NSString* newPeople = [defaults objectForKey:@"NewAddPeople"];
        [_PeopleList addObject:newPeople];
        [self._tableView reloadData];
    }
    //设置同步
    [defaults synchronize];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if(_isSearching == NO){
//        return _PeopleList.count;
//    }
//    else{
//        return _searchPeople.count;
//    }
    return [_FriendList count];
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //UITableViewCell* cell;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //UIButton* call = (UIButton*)[cell viewWithTag:2];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    //[label setTag:indexPath.row+100];
    //    label.text = [recipes objectAtIndex:indexPath.row];
    //label.text = [NSString stringWithFormat: @"%d", (int)indexPath.row + 9000];
    label.text=[[_FriendList objectAtIndex:indexPath.row] _nickName] ;
//    if(_isSearching == NO){
//        label.text = [_PeopleList objectAtIndex:indexPath.row];
//    }
//    else{
//        label.text = [_searchPeople objectAtIndex:indexPath.row];
//    }
    
    UIButton *monitorButton = (UIButton *)[cell viewWithTag:2];
    [monitorButton setTag:indexPath.row+100];
    //    monitorButton.titleLabel.text = [NSString stringWithFormat: @"%d", indexPath.row + 9000];
    objc_setAssociatedObject(monitorButton, "relatedLabel", label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [monitorButton addTarget:self action:@selector(monitorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (IBAction)AddFriend:(id)sender {
    [self addFriend];
}
- (void) addFriend{
    //return UITableViewCellEditingStyleInsert;
    [_PeopleList addObject:@"New User"];
    [self._tableView reloadData];
}

-(void)monitorButtonClick:(UIButton *)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"拨打电话" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setTag:[sender tag]];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        NSString * deletePeople = _PeopleList[indexPath.row];
        [_PeopleList removeObject:deletePeople];
        [self._tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
    else if(editingStyle == UITableViewCellEditingStyleInsert){
        [_PeopleList addObject:@"fuck"];
        [self._tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationBottom) ];
    }
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    _isSearching = NO;
    _searchBar.text=@"";
    [_searchBar resignFirstResponder];
    [self._tableView reloadData];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if([_searchBar.text isEqual:@""]){
        _isSearching=NO;
        [_searchBar resignFirstResponder];
        [self._tableView reloadData];
        return;
    }
    //[self searchDataWithKeyWord:_searchBar.text];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self searchDataWithKeyWord:_searchBar.text];
    
    [_searchBar resignFirstResponder];//放弃第一响应者对象，关闭虚拟键盘
}
-(void)searchDataWithKeyWord:(NSString*)keyWord{
    _isSearching = YES;
    _searchPeople = [NSMutableArray array];
    for(int i = 0 ; i < _PeopleList.count ; i++){
        NSLog(@"qqq");
        if([[[_PeopleList objectAtIndex:i] uppercaseString] containsString:[keyWord uppercaseString]]){
            [_searchPeople addObject:[_PeopleList objectAtIndex:i]];
        }
    }
    [self._tableView reloadData];
}

-(void)addSearchBar{
    CGRect searchBarRect=CGRectMake(0, 0, self.view.frame.size.width, kSearchbarHeight);
    _searchBar=[[UISearchBar alloc]initWithFrame:searchBarRect];
    _searchBar.placeholder=@"Please input key word...";
    //_searchBar.keyboardType=UIKeyboardTypeAlphabet;//键盘类型
    //_searchBar.autocorrectionType=UITextAutocorrectionTypeNo;//自动纠错类型
    //_searchBar.autocapitalizationType=UITextAutocapitalizationTypeNone;//哪一次shitf被自动按下
    _searchBar.showsCancelButton=YES;//显示取消按钮
    //添加搜索框到页眉位置
    _searchBar.delegate=self;
    self._tableView.tableHeaderView=_searchBar;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        NSInteger index = [alertView tag]-100;
        UIStoryboard *callingStoryboard = [UIStoryboard storyboardWithName:@"Call" bundle:nil];
        CallingViewController *vc = (CallingViewController *)[callingStoryboard instantiateInitialViewController];
        //vc.toSip = [alertView textFieldAtIndex:0].text;
        NSLog(@"%@",[[_FriendList objectAtIndex:index] _userName]);
        vc.toSip = [[_FriendList objectAtIndex:index] _userName];
        [self presentViewController:vc animated:YES completion:nil];
    }
    
    //NSLog(@"％d",buttonIndex);
    if (buttonIndex != alertView.cancelButtonIndex) {
        //exit(0);
    }
}
- (void)didReceiveAPIResponseOf: (API *)api data: (NSDictionary *)data{
    NSLog(@"%@",data);
    NSLog(@"%@", [data objectForKey:@"friendId"]);
    
    NSString *status_code = data[@"status_code"];
    if ([status_code intValue] != 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:data[@"status_text"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    } else {
        if([data[@"data"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"ni jiu shi yi ge sha bi");
        }
        NSArray* arrayList = [[NSArray alloc] initWithArray:data[@"data"]];

        for(int i=0;i<[arrayList count];i++)
        {
            NSDictionary * personListEntryDic = [arrayList objectAtIndex:i];
            NSString * a = personListEntryDic[@"nickName"];
            NSString * b = personListEntryDic[@"userName"];
            NSString * c = personListEntryDic[@"friendId"];
            NSString * d = personListEntryDic[@"avatar"];
            NSString * e = personListEntryDic[@"friendnickName"];
            NSString * f = personListEntryDic[@"userId"];
            NSString * g = personListEntryDic[@"videoStatus"];
            FriendListEntry* newPeople=[[FriendListEntry alloc]initWithNickName:a andUserName:b andFriendID:c nadAvatar:d andFrdNickName:e andUserId:f andVideoStatus:g];
            [_FriendList addObject:newPeople];
        }
        //NSLog(@"%d",[_FriendList count]);
        [self._tableView reloadData];
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
