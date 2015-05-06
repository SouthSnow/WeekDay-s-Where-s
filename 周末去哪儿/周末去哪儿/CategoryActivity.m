//
//  CategoryActivity.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/5.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "CategoryActivity.h"
static CategoryActivity *activity = nil;

@implementation CategoryActivity
+ (id)shareCategory
{
   @synchronized(self)
    {
        if (activity == nil)
        {
            activity = [[CategoryActivity alloc]init];
        }
    }
   
    return activity;
}

- (void)setSelecteIndex:(NSInteger)selecteIndex
{
    _selecteIndex = selecteIndex;
}


- (id)init
{
    self = [super init];
    if (self)
    {
        _allArray = [NSMutableArray array];
        _searchArray = [NSMutableArray array];
        _roundArray = [NSMutableArray array];
        _countryArray = [NSMutableArray array];
        _showArray = [NSMutableArray array];
        _muiscArray = [NSMutableArray array];
        _operaArray = [NSMutableArray array];
        _partyArray = [NSMutableArray array];
        _familyArray = [NSMutableArray array];
        _meetingArray = [NSMutableArray array];
        _artArray = [NSMutableArray array];
        _automdArray = [NSMutableArray array];
        _userData = [NSMutableArray array];
        
    }
    
    return self;
    
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    if (!activity) {
        activity = [super allocWithZone:zone];
    }
    return activity;
}


@end
