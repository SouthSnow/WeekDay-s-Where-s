//
//  UserData.h
//  周末去哪儿
//
//  Created by pangfuli on 14/9/9.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import <Foundation/Foundation.h>
/*"result": {
 "user_id": "403461",
 "type": "self",
 "nick": "zhoumo_403461",
 "mobile": "18938935872",
 "mobile_auth": "0",
 "gender": "",
 "icon": "",
 "cover": "",
 "regtime": "1410251778",
 "address_id": "0",
 "address": "",
 "credit": "0",
 "activity_num": "0",
 "poi_num": "0",
 "friend_num": "0",
 "follow_num": "0",
 "comment_num": "0",
 "feed_num": "0",
 "message_num": "0",*/
@interface UserData : NSObject<NSCoding>

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userNick;
@property (nonatomic, copy) NSString *userFollower;
@property (nonatomic, copy) NSString *userFriend;
@property (nonatomic, copy) NSString *userMobile;
@property (nonatomic, copy) NSString *userComment;
@property (nonatomic, copy) NSString *userGender;
@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, copy) NSString *userCover;
@property (nonatomic, copy) NSString *userFeed;
@property (nonatomic, copy) NSString *userpoi;
@property (nonatomic, copy) NSString *userType;
@property (nonatomic, copy) NSString *userMessage;
@property (nonatomic, copy) NSString *userActivity;
@property (nonatomic, copy) NSString *userActivityVice;
@property (nonatomic, copy) NSString *userCredit;
@property (nonatomic, copy) NSString *userAddress;
@property (nonatomic, copy) NSString *userRegtime;
@property (nonatomic, copy) NSString *userContent;
@property (nonatomic, strong) NSMutableArray *userCommentlistArray;
@property (nonatomic, strong) NSMutableArray *userPoiPicArray;
@property (nonatomic, copy) NSString *userCreateTime;
@property (nonatomic, copy) NSString *userCreateTimeShow;
@property (nonatomic, copy) NSString *userReplyNum;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *activityNum;
@property (nonatomic, copy) NSString *fllowNum;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *targetPic;
@property (nonatomic, copy) NSString *startTime;

@end
