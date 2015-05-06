//
//  LeftViewController.h
//  周末去哪儿
//
//  Created by pangfuli on 14/9/3.
//  Copyright (c) 2014年 pfl. All rights reserved.
//


@protocol LeftDelegate <NSObject>

- (void)ChangeCategory:(NSString*)urlStr;

@end
#import <UIKit/UIKit.h>


@interface LeftViewController : UIViewController
@property (nonatomic, weak) id<LeftDelegate>delegate;

@end
