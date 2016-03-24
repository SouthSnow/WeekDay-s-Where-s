//
//  AppDelegate.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/2.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "AppDelegate.h"

#import "PPRevealSideviewController.h"

#import "ViewController.h"
#import "RootViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLRegion.h>
#import "WeiboSDK.h"
//#import <Parse/Parse.h>
#import "TwoViewController.h"
#import "FiveController.h"
#import "CollectController.h"
#import "TrendsViewController.h"
#import "Store.h"


@interface AppDelegate()<CLLocationManagerDelegate>
{
    CLLocationCoordinate2D _coordinate;
    UIView *WeatherView;
    UILabel *addressLabel;
    UILabel *weatherLabel;
}
@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) Store *store;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
//    [Parse setApplicationId:@"slyTFoVwURPvNeIgDADKjlMrelLKtmqHrkHXMWHO"
//                  clientKey:@"tCrbaDcrRs2B7wb7GuSvPNF4kKTSzeM6ZUKUWo9S"];
//    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
//    [ShareSDK registerApp:@"api20"];
//    [ShareSDK connectSinaWeiboWithAppKey:kAppKey appSecret:kAppSecret redirectUri:kRedirectUri];
//    
//    [ShareSDK connectSinaWeiboWithAppKey:@"1577494107" appSecret:@"473960c8c2778ca7462a2aff303dde90" redirectUri:@"https://api.weibo.com/oauth2/default.html" weiboSDKCls:[WeiboSDK class]];
    
    _selectedArray = [NSMutableArray array];
    _trendsArray = [NSMutableArray array];

    self.store = [[Store alloc] init];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
   
    _tabBarController = [[UITabBarController alloc]init];
    self.window.rootViewController = _tabBarController;
    [self load];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *loginStatus = [defaults objectForKey:@"loginStatus"];
    self.loginStatus = loginStatus;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)load
{
    [self initControllers];
    
    _customView = [[UIView alloc]initWithFrame:(CGRect){0,self.window.frame.size.height - _tabBarController.tabBar.frame.size.height,self.window.frame.size.width,_tabBarController.tabBar.frame.size.height}];
    _customView.backgroundColor = [UIColor whiteColor];
    [_tabBarController.view addSubview:_customView];
    
    [self customTabBar];
}

- (void)customTabBar
{
    NSInteger height = 49;
    NSInteger width = self.window.frame.size.width/5;
    
    
    NSArray *nameText = [NSArray arrayWithObjects:@"本周活动",@"发现",@"收藏",@"动态",@"我的", nil];
    NSArray *normalArray = [NSArray arrayWithObjects:@"tab_activity_normal",@"tab_find_normal",@"tab_fav_inverse_normal",@"tab_trends_normal",@"tab_my_normal", nil];
    NSArray *selectArray = [NSArray arrayWithObjects:@"tab_activity_inverse",@"tab_find_inverse",@"tab_fav_inverse_inverse",@"tab_trends_inverse",@"tab_my_inverse", nil];
    for (int i = 0; i < 5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = (CGRect){width*i,0,width,height};
        [btn setTitle:nameText[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:9.5];
        [btn setImage:[UIImage imageNamed:selectArray[i]] forState:(UIControlStateSelected)];
        [btn setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:normalArray[i]] forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(30, -12, 0, 12)];
        [btn setImageEdgeInsets:(UIEdgeInsetsMake(5, 20, 20, 20))];
        
        btn.tag = i + 1;
        if (i == 0) {
            btn.selected = YES;
        }
        [btn addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_customView addSubview:btn];
    }
    
    
    
}

- (void)selectedBtn:(UIButton *)selectedBtn
{
    NSLog(@"====%d=",(int)selectedBtn.tag);
    
    for (int i = 0; i < 5; i++) {
        UIButton *btn = (UIButton*)[self.window viewWithTag:i+1];
        if (btn.tag == selectedBtn.tag) {
            btn.selected = YES;
           _tabBarController.selectedIndex = btn.tag - 1;
           
            
        }
        else
        {
             btn.selected = NO;
        }
        
        
    }
    
}

- (void)initControllers
{
    
    self.count = 0;
    
    RootViewController *oneVc = [[RootViewController alloc]init];
    oneVc.store = self.store;
    TwoViewController *secondVc = [[TwoViewController alloc]init];
    CollectController *thirdVc = [[CollectController alloc]init];
    TrendsViewController *forthVc = [[TrendsViewController alloc]init];
    FiveController *fiveVc = [[FiveController alloc]init];
    
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:oneVc];
    nav1.navigationBar.translucent = NO;
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:secondVc];
    nav2.navigationBar.translucent = NO;
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:thirdVc];
    nav3.navigationBar.translucent = NO;
    UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:forthVc];
    nav4.navigationBar.translucent = NO;
    UINavigationController *nav5 = [[UINavigationController alloc]initWithRootViewController:fiveVc];
    nav5.navigationBar.translucent = NO;
    _tabBarController.viewControllers = [NSArray arrayWithObjects:nav1,nav2,nav3,nav4,nav5, nil];
    
    _tabBarController.tabBar.hidden = YES;
    
}










- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
//    return [ShareSDK handleOpenURL:url wxDelegate:nil];
    return YES;
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation
//{
//    return [ShareSDK handleOpenURL:url
//                 sourceApplication:sourceApplication
//                        annotation:annotation wxDelegate:nil];
//}
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;



- (NSURL *)applicationDocumentsDirectory {
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
            
        }
    }
}







- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
