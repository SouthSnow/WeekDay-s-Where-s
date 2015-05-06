//
//  DetailModel.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/4.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "DetailModel.h"

@implementation DetailModel
- (id)init
{
    self = [super init];
    if (self) {
        _picShowArray = [NSMutableArray array];
        _pic_list_thumb = [NSMutableArray array];
    }
    return self;
}
@end
