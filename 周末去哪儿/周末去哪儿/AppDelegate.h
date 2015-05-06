//
//  AppDelegate.h
//  周末去哪儿
//
//  Created by pangfuli on 14/9/2.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <ShareSDK/ShareSDK.h>
#import "SearchResultController.h"
#define kAppKey @"1577494107"
#define kAppSecret @"473960c8c2778ca7462a2aff303dde90"
#define kRedirectUri @"https://api.weibo.com/oauth2/default.html"


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    SearchResultController *_vc;

}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, assign) NSInteger selecteIndex;
@property (nonatomic, copy) NSString *loginStatus;
@property (nonatomic, strong) NSMutableArray *trendsArray;
@property (nonatomic, strong) NSError *error;




@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end
