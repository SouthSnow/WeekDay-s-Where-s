//
//  SettingController.h
//  周末去哪儿
//
//  Created by pangfuli on 14/9/8.
//  Copyright (c) 2014年 pfl. All rights reserved.
//


@protocol settingDelegate <NSObject>

- (void)changeTelNumber:(NSString*)telNumber;

@end
#import <UIKit/UIKit.h>

@interface SettingController : UIViewController
@property (nonatomic, weak) id<settingDelegate>delegate;
@end
