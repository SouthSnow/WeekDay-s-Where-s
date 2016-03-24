//
//  Story+Import.h
//  周末去哪儿
//
//  Created by dongbailan on 16/3/22.
//  Copyright © 2016年 pfl. All rights reserved.
//

#import "Story.h"
#import "StoryModel.h"

@interface Story (Import)
+ (void)importStory:(StoryModel*)story intoContext:(NSManagedObjectContext*)context;

@end
