//
//  Activity.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/13.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "Activity.h"

@implementation Activity

- (id)init
{
    self = [super init];
    if (self) {
        _piclistArray = [NSMutableArray array];
        _picShowArray = [NSMutableArray array];
    }
    return self;
}

@end
