//
//  Story.h
//  周末去哪儿
//
//  Created by pangfuli on 14-9-19.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Story : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * cost;
@property (nonatomic, retain) NSString * distance_show;
@property (nonatomic, retain) NSString * follow_num;
@property (nonatomic, retain) NSString * genre_main_show;
@property (nonatomic, retain) NSString * genre_name;
@property (nonatomic, retain) NSString * genre_name_show;
@property (nonatomic, retain) NSString * introdution;
@property (nonatomic, retain) NSString * introdution_show;
@property (nonatomic, retain) NSNumber * isFollow;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * pic_show;
@property (nonatomic, retain) NSData * picShowArray;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSString * showTime;
@property (nonatomic, retain) NSString * sID;
@property (nonatomic, retain) NSString * start_time_show;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * title_vice;
@property (nonatomic, retain) NSData * facePic;

@end
