//
//  Activity.h
//  周末去哪儿
//
//  Created by pangfuli on 14/9/13.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject
@property (nonatomic, copy) NSString *actID;
@property (nonatomic, copy) NSString *actEndTime;
@property (nonatomic, strong) NSMutableArray *piclistArray;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *activityPoiName;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *title_vice;
@property (nonatomic, strong) NSMutableArray *picShowArray;
@property (nonatomic, copy) NSString *poiID;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *genre_main_show;
@property (nonatomic, copy) NSString *genre_name;
@property (nonatomic, copy) NSString *distance_show;
@property (nonatomic, copy) NSString *follow_num;
@property (nonatomic, copy) NSString *pic_show;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *isFollow;

@end
