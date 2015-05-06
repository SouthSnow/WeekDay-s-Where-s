//
//  PoiViewController.h
//  周末去哪儿
//
//  Created by pangfuli on 14/9/4.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"
#import "StoryModel.h"
#import "ShowImageController.h"


@interface PoiViewController : UIViewController
@property (nonatomic, strong) StoryModel *model;
@property (nonatomic, strong) NSMutableArray *headArray;
@property (nonatomic, strong) ShowImageController *show;

@end
