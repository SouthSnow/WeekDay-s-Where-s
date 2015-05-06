//
//  SegmentViewController.m
//  周末去哪儿
//
//  Created by pangfuli on 14/10/25.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "SegmentViewController.h"

@interface SegmentViewController ()

@end

@implementation SegmentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc]init];
        self.navigationItem.titleView = _segmentControl;
    }
    else
    {
        [_segmentControl removeAllSegments];
    }
    
}



@end












