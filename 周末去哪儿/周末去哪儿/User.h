//
//  User.h
//  周末去哪儿
//
//  Created by pangfuli on 14/9/6.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *agreeNum;
@property (nonatomic, copy) NSString *replyNum;
@property (nonatomic, copy) NSString *userNick;
@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, copy) NSString *recommend;
@property (nonatomic, copy) NSString *excellent;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *belongID;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *createTime;
@end
