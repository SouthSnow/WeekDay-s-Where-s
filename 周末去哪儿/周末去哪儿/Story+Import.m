//
//  Story+Import.m
//  周末去哪儿
//
//  Created by dongbailan on 16/3/22.
//  Copyright © 2016年 pfl. All rights reserved.
//

#import "Story+Import.h"

@implementation Story (Import)

// Note: don't use this in production code. For large imports, you should implement findOrCreate as per Apple's instructions:
// http://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/CoreData/Articles/cdImporting.html
+ (instancetype)findOrCreateWithIdentifier:(id)identifier inContext:(NSManagedObjectContext*)context {
    NSString* entityName = NSStringFromClass(self);
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"sID = %@", identifier];
    fetchRequest.fetchLimit = 1;
    id object = [[context executeFetchRequest:fetchRequest error:NULL] lastObject];
    if(object == nil) {
        object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
    }
    return object;
}

+ (void)importStory:(StoryModel*)storyModel intoContext:(NSManagedObjectContext*)context
{
    NSString* identifier = storyModel.sID;
    
    Story* story = [self findOrCreateWithIdentifier:identifier inContext:context];
    story.address = storyModel.address;
    story.sID = identifier;
    story.cost = storyModel.cost;
    story.distance_show = storyModel.distance_show;
    story.follow_num = storyModel.follow_num;
    
    story.genre_main_show = storyModel.genre_main_show;
    story.genre_name = storyModel.genre_name;
    story.genre_name_show = storyModel.genre_name;
    story.introdution = storyModel.introdution;
    story.introdution_show = storyModel.introdution_show;
    
    story.isFollow = @(storyModel.isFollow.intValue);
    story.latitude = storyModel.latitude;
    story.longitude = storyModel.longitude;
    story.pic_show = storyModel.pic_show;
    
    story.position = storyModel.position;
    story.showTime = storyModel.showTime;
    story.start_time_show = storyModel.start_time_show;
    story.tel = storyModel.tel;
    story.title = storyModel.title;

    story.title_vice = storyModel.title_vice;
    story.facePic = storyModel.facePic;


}


@end
