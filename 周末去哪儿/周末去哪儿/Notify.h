//
//  Notify.h
//  周末去哪儿
//
//  Created by pangfuli on 14/9/13.
//  Copyright (c) 2014年 pfl. All rights reserved.
//
/*"id": "279762",
 "user_id": "403461",
 "sponsor_id": "19470",
 "type": "act_start",
 "relation_id": "12328",
 "url": "inapp://act/?id=12328",
 "content": "您关注的活动 世界最伟大的巴扬手风琴演奏家 将于明天正式开始，欢迎参与",
 "params_show": [],
 "status": "2",
 "createtime": "1410537840"*/
#import <Foundation/Foundation.h>

@interface Notify : NSObject
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *type;

@end
