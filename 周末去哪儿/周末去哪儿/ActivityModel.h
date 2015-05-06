//
//  ActivityModel.h
//  周末去哪儿
//
//  Created by pangfuli on 14/9/3.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject
@property (nonatomic, copy) NSString *introdution;
@property (nonatomic, copy) NSString *activityTitle;
@property (nonatomic, copy) NSString *activity_poi_name_app;
@property (nonatomic, strong) NSMutableArray *activity_pic_list_show;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *activity_address;
@property (nonatomic, copy) NSString *distance_show;
@property (nonatomic, copy) NSString *activity_lon;
@property (nonatomic, copy) NSString *activity_lat;
@property (nonatomic, copy) NSString *activity_statis_follow_num;
@property (nonatomic, copy) NSString *activity_pic_h5list;
@property (nonatomic, copy) NSString *start_time_show;
@end
