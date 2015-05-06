//
//  TableViewCell.h
//  PPRevealSliderDemo1
//
//  Created by pangfuli on 14/9/1.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryModel.h"
#import "Activity.h"


@interface TableViewCell : UITableViewCell
@property (nonatomic, strong) StoryModel *model;
@property (weak, nonatomic) IBOutlet UIButton *favBtn;
@property (nonatomic, strong) Activity *act;



@end
