//
//  ActCell.h
//  周末去哪儿
//
//  Created by pangfuli on 14/9/6.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "UserData.h"
@interface ActCell : UITableViewCell
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) UserData *userData;
@end
