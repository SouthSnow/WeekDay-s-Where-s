//
//  RootViewController.h
//  周末去哪儿
//
//  Created by pangfuli on 14/9/2.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "MJRefresh.h"
#import "Store.h"

@interface RootViewController : UIViewController
@property (nonatomic, readwrite, strong) Store *store;

@end
