//
//  AboatController.h
//  周末去哪儿
//
//  Created by pangfuli on 14-9-15.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#define kAppKey @"1577494107"
#define kAppSecret @"473960c8c2778ca7462a2aff303dde90"
#define kRedirectUri @"https://api.weibo.com/oauth2/default.html"
@interface AboatController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *tel;
@property (weak, nonatomic) IBOutlet UILabel *weibo;
@property (nonatomic, strong) SinaWeibo *myWeibo;
@end
