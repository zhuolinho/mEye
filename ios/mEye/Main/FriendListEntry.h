//
//  FriendListEntry.h
//  ipjsua
//
//  Created by JuZhen on 16/1/27.
//  Copyright © 2016年 Teluu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendListEntry : NSObject
@property(nonatomic,copy)NSString* _nickName;
@property(nonatomic,copy)NSString* _userName;
@property(nonatomic,copy)NSString* _friendID;
@property(nonatomic,copy)NSString* _avatar;
@property(nonatomic,copy)NSString* _friendnickName;
@property(nonatomic,copy)NSString* _userId;
@property(nonatomic,copy)NSString* _videoStatus;
-(FriendListEntry*) initWithNickName:(NSString*) nickName andUserName:(NSString*)userName andFriendID:(NSString*) friendID nadAvatar:(NSString*)avatar andFrdNickName:(NSString*)friendnickName andUserId:(NSString*) userId andVideoStatus:(NSString*) videoStatus;
//+(FriendListEntry*) initWithNickName:(NSString*) nickName andUserName:(NSString*)userName andFriendID:(NSString*) friendID nadAvatar:(NSString*)avatar andFrdNickName:(NSString*)friendnickName andUserId:(NSString*) userId andVideoStatus:(NSString*) videoStatus;
@end
