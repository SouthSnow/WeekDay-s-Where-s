//
//  CollectCell.h
//  周末去哪儿
//
//  Created by pangfuli on 14/9/10.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "UserData.h"
@interface CollectCell : UITableViewCell
@property (nonatomic, strong) UserData *user;

- (void)setUser;

@end
