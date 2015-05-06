//
//  UserData.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/9.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "UserData.h"

@implementation UserData


- (id)init
{
    self = [super init];
    if (self) {
        _userCommentlistArray = [NSMutableArray array];
        _userPoiPicArray = [NSMutableArray array];
    }
    return self;
}



- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.userNick forKey:@"userNick"];
    [aCoder encodeObject:self.userFollower forKey:@"userFollower"];
    [aCoder encodeObject:self.userMobile forKey:@"userMobile"];
    [aCoder encodeObject:self.userFriend forKey:@"userFriend"];
    [aCoder encodeObject:self.userComment forKey:@"userComment"];
    [aCoder encodeObject:self.userGender forKey:@"userGender"];
    [aCoder encodeObject:self.userIcon forKey:@"userIcon"];
    [aCoder encodeObject:self.userCover forKey:@"userCover"];
    [aCoder encodeObject:self.userFeed forKey:@"userFeed"];
    [aCoder encodeObject:self.userpoi forKey:@"userpoi"];
    [aCoder encodeObject:self.userType forKey:@"userType"];
    [aCoder encodeObject:self.userMessage forKey:@"userMessage"];
    [aCoder encodeObject:self.userActivity forKey:@"userActivity"];
    [aCoder encodeObject:self.userActivityVice forKey:@"userActivityVice"];
    [aCoder encodeObject:self.userCredit forKey:@"userCredit"];
    [aCoder encodeObject:self.userAddress forKey:@"userAddress"];
    [aCoder encodeObject:self.userRegtime forKey:@"userRegtime"];
    [aCoder encodeObject:self.userContent forKey:@"userContent"];
    [aCoder encodeObject:self.userCreateTime forKey:@"userCreateTime"];
    [aCoder encodeObject:self.userCreateTimeShow forKey:@"userCreateTimeShow"];
    [aCoder encodeObject:self.userReplyNum forKey:@"userReplyNum"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.activityNum forKey:@"activityNum"];
    [aCoder encodeObject:self.fllowNum forKey:@"fllowNum"];
    [aCoder encodeObject:self.userCreateTimeShow forKey:@"userCreateTimeShow"];
    [aCoder encodeObject:self.userReplyNum forKey:@"userReplyNum"];
    [aCoder encodeObject:self.city forKey:@"title"];
    [aCoder encodeObject:self.targetPic forKey:@"targetPic"];
    [aCoder encodeObject:self.startTime forKey:@"startTime"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    UserData *data = [[UserData alloc]init];
    data.userID = [aDecoder decodeObjectForKey:@"userID"];
    data.userNick = [aDecoder decodeObjectForKey:@"userNick"];
    data.userFollower = [aDecoder decodeObjectForKey:@"userFollower"];
    data.userMobile = [aDecoder decodeObjectForKey:@"userMobile"];
    data.userFriend = [aDecoder decodeObjectForKey:@"userFriend"];
    data.userComment = [aDecoder decodeObjectForKey:@"userComment"];
    data.userGender = [aDecoder decodeObjectForKey:@"userGender"];
    data.userIcon = [aDecoder decodeObjectForKey:@"userIcon"];
    data.userCover = [aDecoder decodeObjectForKey:@"userCover"];
    data.userFeed = [aDecoder decodeObjectForKey:@"userFeed"];
    data.userpoi = [aDecoder decodeObjectForKey:@"userpoi"];
    data.userType = [aDecoder decodeObjectForKey:@"userType"];
    data.userMessage = [aDecoder decodeObjectForKey:@"userMessage"];
    data.userActivity = [aDecoder decodeObjectForKey:@"userActivity"];
    data.userActivityVice = [aDecoder decodeObjectForKey:@"userActivityVice"];
    data.userCredit = [aDecoder decodeObjectForKey:@"userCredit"];
    data.userAddress = [aDecoder decodeObjectForKey:@"userAddress"];
    data.userRegtime = [aDecoder decodeObjectForKey:@"userRegtime"];
    data.userContent = [aDecoder decodeObjectForKey:@"userContent"];
    data.userCreateTime = [aDecoder decodeObjectForKey:@"userCreateTime"];
    data.userCreateTimeShow = [aDecoder decodeObjectForKey:@"userCreateTimeShow"];
    data.userReplyNum = [aDecoder decodeObjectForKey:@"userReplyNum"];
    data.userMobile = [aDecoder decodeObjectForKey:@"city"];
    data.activityNum = [aDecoder decodeObjectForKey:@"activityNum"];
    data.fllowNum = [aDecoder decodeObjectForKey:@"fllowNum"];
    data.userCreateTimeShow = [aDecoder decodeObjectForKey:@"userCreateTimeShow"];
    data.userReplyNum = [aDecoder decodeObjectForKey:@"userReplyNum"];
    data.title = [aDecoder decodeObjectForKey:@"title"];
    data.targetPic = [aDecoder decodeObjectForKey:@"targetPic"];
    data.startTime = [aDecoder decodeObjectForKey:@"startTime"];
    return data;
}



@end
