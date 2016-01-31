//
//  FriendListEntry.m
//  ipjsua
//
//  Created by JuZhen on 16/1/27.
//  Copyright © 2016年 Teluu. All rights reserved.
//

#import "FriendListEntry.h"

@implementation FriendListEntry
//@property(nonatomic,copy)NSString* _nickName;
//@property(nonatomic,copy)NSString* _userName;
//@property(nonatomic,copy)NSString* _friendID;
//@property(nonatomic,copy)NSString* _avatar;
-(FriendListEntry*) initWithNickName:(NSString*) nickName andUserName:(NSString*)userName andFriendID:(NSString*) friendID nadAvatar:(NSString*)avatar andFrdNickName:(NSString*)friendnickName andUserId:(NSString*) userId andVideoStatus:(NSString*) videoStatus{
    if(self=[super init]){
        self._nickName = nickName;
        self._userName = userName;
        self._friendID = friendID;
        self._avatar   = avatar;
        self._friendnickName=friendnickName;
        self._userId = userId;
        self._videoStatus=videoStatus;
    }
    return self;
}
//+(FriendListEntry*) initWithNickName:(NSString*) nickName andUserName:(NSString*)userName andFriendID:(NSString*) friendID nadAvatar:(NSString*)avatar andFrdNickName:(NSString*)friendnickName andUserId:(NSString*) userId andVideoStatus:(NSString*) videoStatus{
//    FriendListEntry* ret = [[FriendListEntry alloc] initWithNickName:nickName andUserName:userName andFriendID:friendID nadAvatar:avatar andFrdNickName:friendnickName andUserId:userId andVideoStatus:videoStatus];
//    return ret;
//}
@end
