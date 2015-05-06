//
//  LoginController.h
//  周末去哪儿
//
//  Created by pangfuli on 14/9/9.
//  Copyright (c) 2014年 pfl. All rights reserved.
//
typedef void(^LoginData)(NSData*data);

#import <UIKit/UIKit.h>

@interface LoginController : UIViewController

@property (nonatomic, copy) LoginData loginData;

- (void)passLoginDataFrom:(LoginData)loginBlock;

@end
