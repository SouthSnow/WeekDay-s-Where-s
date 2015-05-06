//
//  CategoryActivity.h
//  周末去哪儿
//
//  Created by pangfuli on 14/9/5.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryActivity : NSObject
@property (nonatomic, strong) NSMutableArray *allArray;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) NSMutableArray *roundArray;
@property (nonatomic, strong) NSMutableArray *countryArray;
@property (nonatomic, strong) NSMutableArray *showArray;
@property (nonatomic, strong) NSMutableArray *muiscArray;
@property (nonatomic, strong) NSMutableArray *operaArray;
@property (nonatomic, strong) NSMutableArray *partyArray;
@property (nonatomic, strong) NSMutableArray *familyArray;
@property (nonatomic, strong) NSMutableArray *meetingArray;
@property (nonatomic, strong) NSMutableArray *artArray;
@property (nonatomic, strong) NSMutableArray *automdArray;
@property (nonatomic, strong) NSMutableArray *userData;
@property (nonatomic, assign) NSInteger selecteIndex;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *actPlace;


+ (id)shareCategory;
@end
