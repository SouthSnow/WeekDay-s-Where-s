//
//  SearchController.h
//  周末去哪儿
//
//  Created by pangfuli on 14-10-2.
//  Copyright (c) 2014年 pfl. All rights reserved.
//
@protocol searchDelegate <NSObject>

- (void)changeFrame;

@end


#import <UIKit/UIKit.h>

@interface SearchController : UIViewController

@property (weak, nonatomic) id <searchDelegate> delegate;

@end
