//
//  ViewController.h
//  测试tabbar
//
//  Created by pangfuli on 14/9/5.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITabBarController
@property (nonatomic,assign) NSInteger count;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) NSMutableArray *selectedArray;

- (void)load;
@end
