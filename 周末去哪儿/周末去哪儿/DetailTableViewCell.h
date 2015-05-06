//
//  DetailTableViewCell.h
//  周末去哪儿
//
//  Created by pangfuli on 14/9/2.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryModel.h"

@interface DetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *praiseLabel;
@property (nonatomic, strong) StoryModel *model;
@property IBOutlet UIView *showView;
@property IBOutlet UIScrollView *showScroll;

@property IBOutlet UILabel *titleLabel;

@property IBOutlet UILabel *positionLabel;

@property IBOutlet UILabel *distanceLabel;

@property IBOutlet UIView *mapView;
@end
