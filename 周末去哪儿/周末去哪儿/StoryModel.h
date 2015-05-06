//
//  StoryModel.h
//  周末去哪儿
//
//  Created by pangfuli on 14/9/2.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *title_vice;
@property (nonatomic, strong) NSMutableArray *picShowArray;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *sID;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *showTime;
@property (nonatomic, copy) NSString *cost;
@property (nonatomic, copy) NSString *introdution;
@property (nonatomic, copy) NSString *introdution_show;
@property (nonatomic, copy) NSString *genre_main_show;
@property (nonatomic, copy) NSString *genre_name;
@property (nonatomic, copy) NSString *distance_show;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *follow_num;
@property (nonatomic, copy) NSString *pic_show;
@property (nonatomic, copy) NSString *start_time_show;
@property (nonatomic, copy) NSString *isFollow;
@property (nonatomic, copy) NSString *face;
@property (nonatomic, copy) NSData *facePic;
@end
