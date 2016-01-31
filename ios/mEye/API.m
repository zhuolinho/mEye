//
//  API.m
//  GoodLuck
//
//  Created by HoJolin on 15/8/22.
//
//

#import "API.h"

static NSMutableDictionary *picDic;

@implementation API

- (void)post:(NSString *)action dic:(NSDictionary *)dic {
    NSString *str = [NSString stringWithFormat:@"%@/Yarlung/%@", HOST, action];
    NSURL *url = [NSURL URLWithString:str];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [request setValue:[ud objectForKey:@"deviceId"] forHTTPHeaderField:@"uuid"];
    [request setValue:[ud objectForKey:@"token"] forHTTPHeaderField:@"token"];
    [request setValue:[ud objectForKey:@"userId"] forHTTPHeaderField:@"userId"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = data;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError == nil) {
            NSError *err = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
            if(jsonObject != nil && err == nil){
                if([jsonObject isKindOfClass:[NSDictionary class]]){
                    NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject;
                    if (self->_delegate) {
                        [self->_delegate didReceiveAPIResponseOf:self data:deserializedDictionary];
                    }
                }else if([jsonObject isKindOfClass:[NSArray class]]){
                    if (self->_delegate) {
                        [self->_delegate didReceiveAPIErrorOf:self data:-999];
                    }
                }
            }
            else if(err != nil){
                if (self->_delegate) {
                    [self->_delegate didReceiveAPIErrorOf:self data:-777];
                }
            }
        }
        else {
            if (self->_delegate) {
                [self->_delegate didReceiveAPIErrorOf:self data:-888];
            }
        }
    }];
}

//- (void)regScan:(NSString *)username password:(NSString *)password {
//    [self post:@"Regscan.action" dic:@{@"userName": username, @"password": password}];
//}

- (void)login:(NSString *)username password:(NSString *)password {
    [self post:@"User/Login.action" dic:@{@"userName": username, @"password": password, @"devType": @"2"}];
}

- (void)registerAccount:(NSString *)username {
    [self post:@"User/Register.action" dic:@{@"userName": username}];
}

- (void)checkCode:(NSString *)mobileNo password:(NSString *)password code:(NSString *)code {
    [self post:@"User/Verificationcode/Check.action" dic:@{@"mobileNo": mobileNo, @"password": password, @"code": code, @"checkType": @"0", @"devType": @"2"}];
}

- (void)getFriendList{
    [self post:@"Query/FriendsInfo/List.action" dic:@{@"statementId": @"yarlung.queryFriendinfo"}];
}

- (void)searchFriendByPhone:(NSString*) mobileNo{
    [self post:@"Query/FriendsInfo/List.action" dic:@{@"statementId":@"yarlung.searchFriend",@"parameters":@{@"userName":mobileNo}}];
}

- (void)findUser:(NSString *)userId {
    [self post:@"Persist/User/Load.action" dic:@{@"userId": userId}];
}

+ (UIImage *)getPicByKey:(NSString *)key {
    if (picDic != nil) {
        return [picDic objectForKey:key];
    }
    return nil;
}

+ (void)setPicByKey:(NSString *)key pic:(UIImage *)pic {
    if (picDic == nil) {
        picDic = [[NSMutableDictionary alloc]init];
    }
    [picDic setValue:pic forKey:key];
}


@end
