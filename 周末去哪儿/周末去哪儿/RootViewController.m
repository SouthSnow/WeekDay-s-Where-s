//
//  RootViewController.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/2.
//  Copyright (c) 2014年 pfl. All rights reserved.
//
#import "RootViewController.h"
#import "LeftViewController.h"
#import "PPRevealSideViewController.h"
#import "UIImageView+WebCache.h"
#import "TableViewCell.h"
#import "StoryModel.h"
#import "DetailViewController.h"
#import "SliderViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLRegion.h>
#import "AFHTTPRequestOperation.h"
#import "AFNetworking.h"
#import "Story.h"
#import "SegmentViewController.h"
#import "StaticLibraryDemo.h"
#import <libkern/OSAtomic.h>

#define kContentOffSizeHeight scrollView.contentSize.height - 474

//,CLLocationManagerDelegate
@interface RootViewController ()<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate,LeftDelegate,CLLocationManagerDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UIPageControl *_pageCtl;
    NSTimer *_timer;
    AppDelegate *dele;
    UIView *_view;
    UILabel *_loadLabel;
    UIView *_view0;
    UIView *WeatherView;
    UILabel *addressLabel;
    UILabel *weatherLabel;
    UIActivityIndicatorView *_act;
    UIActivityIndicatorView *_act0;
    UISegmentedControl *segment;
    CategoryActivity *activity;
    CLLocationCoordinate2D _coordinate;
    NSError *_error;
    UIImageView *_imgView;
    NSArray *laterUtlArray;
    UIView * _headView;
    UIView *leftView;
    UIView *coverView;
    BOOL flag;
    int requestCount;
    BOOL requestFinish;
    UINavigationController *nav2;
    dispatch_queue_t _mainQueue;
    dispatch_queue_t _globalQueue;
    dispatch_group_t dispatchGroup;
    NSCache *imageCache;
    NSOperationQueue *operationQueue;
    NSMutableDictionary *operationStack;
    OSSpinLock _lock;

}
@property (nonatomic, strong)CLLocationManager *manager;
@property (nonatomic,strong) MJRefreshHeaderView *headerRefreshView;
@property (nonatomic,strong) MJRefreshFooterView *footerRefreshView;
@property (nonatomic,strong) NSMutableArray *testDataArr;
@property (nonatomic,assign) BOOL isSaveStatus;
@property (nonatomic,strong) UIActionSheet *actionSheet;
@property (nonatomic,strong) SearchResultController *search;
@property (nonatomic,strong) LeftViewController *leftVc;
@property (nonatomic, assign) NSUInteger saveCount;
@end

@implementation RootViewController


- (void)dealloc
{
    _manager = nil;
    _headerRefreshView = nil;
    _testDataArr = nil;
    _actionSheet = nil;
    _search = nil;
    _leftVc = nil;
    _tableView = nil;
    _dataArray = nil;
    _pageCtl = nil;
    dele = nil;
    _view = nil;
    _loadLabel = nil;
    _view0 = nil;
    WeatherView = nil;
    addressLabel = nil;
    weatherLabel = nil;
    _act = nil;
    _act0 = nil;
    segment = nil;
    activity = nil;
    _imgView = nil;
    laterUtlArray = nil;
    _headView = nil;
    leftView = nil;
    coverView = nil;
    nav2 = nil;
   
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"sort_normal"] style:(UIBarButtonItemStyleDone) target:self action:@selector(swipeLeft)];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
       
        _mainQueue = dispatch_get_main_queue();
        _globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        dispatchGroup = dispatch_group_create();
        [self initAll];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    _lock = OS_SPINLOCK_INIT;
    operationQueue = [[NSOperationQueue alloc]init];
    operationStack = [NSMutableDictionary dictionary];
    
    imageCache = [[NSCache alloc]init];
//    imageCache.countLimit = 30;
    
    [StaticLibraryDemo testPrint];

    [self laterUrl];
    [self addTableView];
    [self addSegmentControl];
    
    [self dragRefresh];
    [self addLocationManager];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
   
}

- (void)sendWeatherRequest
{
    NSString *urlStr = @"http://www.weather.com.cn/data/cityinfo/101280601.html";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation start];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        NSString *temLow = dict[@"weatherinfo"][@"temp1"];
        NSString *temHei = dict[@"weatherinfo"][@"temp2"];
        NSString *weather = dict[@"weatherinfo"][@"weather"];
        weatherLabel.font = [UIFont systemFontOfSize:10];
        weatherLabel.textAlignment = NSTextAlignmentLeft;
        weatherLabel.text = [NSString stringWithFormat:@"%@~%@%@",temLow,temHei,weather];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        
    }];
    
}

- (void)addLocationManager
{
    _manager = [[CLLocationManager alloc]init];
    _manager.delegate = self;
    _manager.distanceFilter = kCLLocationAccuracyHundredMeters;
    _manager.desiredAccuracy = kCLLocationAccuracyBest;
    [_manager requestAlwaysAuthorization];
    [_manager startUpdatingLocation];
    
}
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    _coordinate = [[locations lastObject] coordinate];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    CLLocation *location = [[CLLocation alloc]initWithLatitude:_coordinate.latitude longitude:_coordinate.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = placemarks[0];
            
            addressLabel.font = [UIFont systemFontOfSize:10];
            if (!_error)
            {
                addressLabel.text = [NSString stringWithFormat:@"  %@%@%@%@",placemark.addressDictionary[@"State"],placemark.addressDictionary[@"City"],placemark.addressDictionary[@"SubLocality"],placemark.addressDictionary[@"Street"]];
            }
            else
            {
                addressLabel.text = @"   网络貌似有问题,请重试!";
            }
        }
        
    }];
    
}

- (void)dragRefresh
{
    
    _view0 = [[UIView alloc]initWithFrame:(CGRect){0,-64,self.view.frame.size.width,64}];
    [_tableView addSubview:_view0];
    
    UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
    act.frame = CGRectMake(0, 10, self.view.frame.size.width, 20);
    [_view0 addSubview:act];
    _view0.backgroundColor = [UIColor grayColor];
    _act0 = act;
    UILabel *load = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 20)];
    [_view0 addSubview:load];
    load.text = @"下拉刷新";
    load.font = [UIFont systemFontOfSize:12];
    load.textAlignment = NSTextAlignmentCenter;
}

- (void)beginRefresh:(UIScrollView*)scrollView
{
    [_act0 startAnimating];
    if (scrollView.contentOffset.y < -64.0)
    {
        [self sendWeatherRequest];
        [_manager startUpdatingLocation];
        UILabel *l = (UILabel*)_view0.subviews[1];
        l.text = @"正在刷新...";
        [UIView animateWithDuration:.5 animations:^{
            _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        }];
        [self performSelector:@selector(stopRefresh:) withObject:nil afterDelay:2.0];
    }
    
    
}

- (void)stopRefresh:(UIScrollView*)scrollView
{
    UILabel *l = (UILabel*)_view0.subviews[1];

    [UIView animateWithDuration:.5 animations:^{
        l.text = @"刷新完毕";
        [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    } completion:^(BOOL finished) {
        l.text = @"下拉刷新";
    }];
    [self sendRequest:laterUtlArray[segment.selectedSegmentIndex] withType:@"main" isRefresh:YES];
    [_act0 stopAnimating];
  
}


- (void)laterUrl
{
    laterUtlArray = @[@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&is_near=1&is_valid=1&lat=22.562433&lon=113.904398&method=activity.List&os=iphone&pagesize=30&r=wanzhoumo&sign=0f97295d4c92c73217ff8341fb11b20c&sort=default&timestamp=1409632143&top_session=n8i2d0ie4g77qfb8dmoot08ct7&v=2.0",@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&is_near=1&is_valid=1&lat=22.535044&lon=113.944849&method=activity.List&offset=30&os=iphone&pagesize=30&r=wanzhoumo&sign=7cf20949bd9c5990598836ba6ef073da&sort=default&timestamp=1410335762&v=2.0",@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&is_near=1&is_valid=1&lat=22.535044&lon=113.944849&method=activity.List&offset=60&os=iphone&pagesize=30&r=wanzhoumo&sign=de3ff25211b760930bb81433e527b5df&sort=default&timestamp=1410335834&v=2.0",@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&is_near=1&is_valid=1&lat=22.535044&lon=113.944849&method=activity.List&offset=90&os=iphone&pagesize=30&r=wanzhoumo&sign=8f2e34692044cb173e023e6d5ef6e9f5&sort=default&timestamp=1410335871&v=2.0",@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&is_near=1&is_valid=1&lat=22.535044&lon=113.944849&method=activity.List&offset=120&os=iphone&pagesize=30&r=wanzhoumo&sign=46db75331082d7beb1c11efac327df23&sort=default&timestamp=1410335913&v=2.0",@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&is_near=1&is_valid=1&lat=22.535044&lon=113.944849&method=activity.List&offset=150&os=iphone&pagesize=30&r=wanzhoumo&sign=f1f7bb7819db7b4fd36464ef41b9d477&sort=default&timestamp=1410335945&v=2.0"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self sendRequest:laterUtlArray[0] withType:@"main" isRefresh:NO];
     [self sendWeatherRequest];
    
    dele.customView.hidden = NO;
    segment.selectedSegmentIndex = 0;
    if ([dele.loginStatus isEqualToString: @"success"])
    {
        [_tableView reloadData];
    }
}



- (void)sendRequest:(NSString*)urlStr withType:(NSString*)type isRefresh: (BOOL)isRefresh
{
    
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFCompoundResponseSerializer serializer];
    
    [manger GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self resetFrame];
        });
        if ([type isEqual:@"main"])
        {

            requestFinish = YES;
            flag = YES;
            
            if (isRefresh) {
                [_dataArray removeAllObjects];
                requestCount = 0;
            }
         
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            for (NSDictionary *dic in dictionary[@"result"][@"list"])
            {
                
                
                StoryModel *model = [[StoryModel alloc]init];
                model.title = dic[@"title"];
                model.position = dic[@"poi_name_app"];
                activity.actPlace = dic[@"poi_name_app"];
                model.address  = dic[@"address"];
                model.cost = dic[@"cost"];
                model.tel = dic[@"tel"];
                model.showTime = dic[@"time_txt"];
                [model.picShowArray addObjectsFromArray:dic[@"pic_show"]];
                model.introdution = dic[@"intro"];
                model.introdution_show = dic[@"intro_show"];
                model.genre_main_show = dic[@"genre_main_show"];
                model.genre_name = dic[@"genre_name"];
                model.distance_show = dic[@"distance_show"];
                model.sID = dic[@"id"];
                model.latitude = dic[@"lat"];
                model.longitude = dic[@"lon"];
                model.follow_num = dic[@"statis.follow_num"];
                model.title_vice = dic[@"title_vice"];
                model.isFollow = dic[@"is_follow"];
                model.face = dic[@"pic_show"][0];
                
                [_dataArray addObject:model];
                [activity.artArray addObject:model];
            }
         
            #pragma mark 取回路径

            [_tableView reloadData];
        }
        else
        {
              _tableView.scrollsToTop = YES;
              
              [_dataArray removeAllObjects];
              
              NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
              for (NSDictionary *dic in dictionary[@"result"][@"list"])
              {
                  StoryModel *model = [[StoryModel alloc]init];
                  model.title = dic[@"title"];
                  model.position = dic[@"poi_name_app"];
                  activity.actPlace = dic[@"poi_name_app"];
                  model.address  = dic[@"address"];
                  model.cost = dic[@"cost"];
                  model.tel = dic[@"tel"];
                  model.showTime = dic[@"time_txt"];
                  [model.picShowArray addObjectsFromArray:dic[@"pic_show"]];
                  model.introdution = dic[@"intro"];
                  model.introdution_show = dic[@"intro_show"];
                  model.genre_main_show = dic[@"genre_main_show"];
                  model.genre_name = dic[@"genre_name"];
                  model.distance_show = dic[@"distance_show"];
                  model.sID = dic[@"id"];
                  model.latitude = dic[@"lat"];
                  model.longitude = dic[@"lon"];
                  model.follow_num = dic[@"statis.follow_num"];
                  model.title_vice = dic[@"title_vice"];
                  model.isFollow = dic[@"is_follow"];
                  model.face = dic[@"pic_show"][0];
                  
                  [_dataArray addObject:model];
                  [activity.artArray addObject:model];
                 
              }
            
            [_tableView reloadData];
          }
        
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
             dele.error = error;
            [_act stopAnimating];
            
            NSManagedObjectContext *context = dele.managedObjectContext;
            NSEntityDescription *description = [NSEntityDescription entityForName:@"Story" inManagedObjectContext:context];
            NSFetchRequest *request = [[NSFetchRequest alloc]init];
            [request setIncludesPropertyValues:NO];
            [request setEntity:description];
            
            NSArray *datas = [context executeFetchRequest:request error:&error];
            if (datas.count != _dataArray.count) {
                [_dataArray removeAllObjects];
                [self loadData];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self resetFrame];
                requestFinish = YES;
                flag = YES;
            });
    }];

    
}

- (void)saveData
{
    
    dispatch_group_async(dispatchGroup, _globalQueue, ^{
//        @synchronized(self){
//            _isSaveStatus = YES;
//            [self saveData:_dataArray];
//        }
        
        OSSpinLockLock(&_lock);
        _isSaveStatus = YES;
        [self saveData:_dataArray];
        OSSpinLockUnlock(&_lock);
        
    });
    dispatch_group_notify(dispatchGroup, _mainQueue, ^{
        _isSaveStatus = NO;
    });
}

- (void)saveData:(NSArray*)arr
{
    for (int i = 0; i < arr.count; i++)
    {
        BOOL hasContain = NO;
        NSError *error = nil;
        NSManagedObjectContext *context = dele.managedObjectContext;
      
        NSEntityDescription *description = [NSEntityDescription entityForName:@"Story" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        [request setIncludesPropertyValues:NO];
        [request setEntity:description];
       
        NSArray *datas = [context executeFetchRequest:request error:&error];
        self.saveCount = datas.count;
        if (!error && datas && [datas count])
        {
            for (NSManagedObject *obj in datas)
            {
                StoryModel *model =(StoryModel*)obj;
                if ([model.sID isEqualToString:[(StoryModel*)arr[i] sID]]) {
                    hasContain = YES;
                    break;
                }
            }
           
        }
        
        if (hasContain) {
            continue;
        }
        
        StoryModel *model = arr[i];
        NSData *picData = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.face]];
        NSArray *modArr = @[picData,model.title,model.position,model.address, model.cost, model.tel, model.showTime,model.introdution, model.introdution_show ,model.genre_main_show,model.genre_name,model.distance_show ,model.sID,model.latitude ,model.longitude ,model.follow_num , model.title_vice,model.isFollow];
         NSArray *storyArr = @[@"facePic",@"title",@"position",@"address", @"cost", @"tel", @"showTime",@"introdution", @"introdution_show",@"genre_main_show",@"genre_name",@"distance_show",@"sID",@"latitude",@"longitude",@"follow_num", @"title_vice",@"isFollow"];
        Story *story = [NSEntityDescription insertNewObjectForEntityForName:@"Story" inManagedObjectContext:dele.managedObjectContext];
        
        for (int j = 0; j < modArr.count; j++)
        {
            [story setValue:modArr[j] forKey:storyArr[j]];
        }
        if ([context save:&error])
        {
            NSLog(@"添加成功");
            NSLog(@"savecount = %d",self.saveCount++);
        }
        else
        {
            NSLog(@"添加失败");
        }
    }
 
}

- (void)deleteData
{
    // 创建上下文
    NSManagedObjectContext *context = dele.managedObjectContext;
    // 通过上下文获得实体的描述
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Story" inManagedObjectContext:context];
    // 创建请求
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    // 设置请求条件
    [request setIncludesPropertyValues:NO];
    // 将请求导入实体描述中
    [request setEntity:description];
    NSError *error = nil;
    // 通过上下文并结合请求条件获取实体中的对象
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        for (NSManagedObject *obj in datas)
        {
            [context deleteObject:obj];
        }
        if (![context save:&error]) {
            NSLog(@"error%@",error.localizedDescription);
        }
    }
}

- (void)test
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc]init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Story" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:description];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && datas.count)
    {
        for (NSManagedObject *obj in datas)
        {
            [context deleteObject:obj];
        }
    }
}

- (void)loadData
{
    NSManagedObjectContext *context = dele.managedObjectContext;
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Story" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:description];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        for (NSManagedObject *obj in datas)
        {
            StoryModel *model =(StoryModel*)obj;
            
            [_dataArray addObject:model];
           
        }
         [_tableView reloadData];
        if (![context save:&error]) {
            NSLog(@"error%@",error.localizedDescription);
        }
    }
}

#pragma mark 取回路径
- (NSString *) dataFilePath
{
//    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
//    NSString *documentsDirectory2 = paths1[0];
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:@"test.txt"];
    
}



#pragma mark LeftDelegate
- (void)ChangeCategory:(NSString *)urlStr
{
    [self sendRequest:urlStr withType:@"category" isRefresh:YES];
    
}

#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

int count = 0;
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoryModel *model = _dataArray[indexPath.row];
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    count = (int)indexPath.row;
    [cell.favBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.model = model;
    
#if 0
    __block UIImage *thumbImage = [imageCache objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    if (thumbImage) {
        cell.imgView.image = thumbImage;
    }
    
    if (!thumbImage) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage *image = [UIImage imageWithData:[model isKindOfClass:[StoryModel class]]?[NSData dataWithContentsOfURL:[NSURL URLWithString:model.face]]:model.facePic];
            float scale = [UIScreen mainScreen].scale;
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(cell.bounds.size.width, 230), YES, scale);
            [image drawInRect:CGRectMake(0, 0, self.view.bounds.size.width, 230)];
            thumbImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imgView.image = thumbImage;
                [imageCache setObject:thumbImage forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
            });
        });
        
    }
    
#endif
    
    
#if 1
    
    __block UIImage *thumbImage;
    thumbImage = [imageCache objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    if (thumbImage) {
        cell.imgView.image = thumbImage;
    }
    else {
        NSBlockOperation *operation = [operationStack objectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.row]];
        if (!operation) {
            operation = [[NSBlockOperation alloc]init];
            [operationStack setObject:operation forKey:[NSString stringWithFormat:@"%d",(int)indexPath.row]];
        }
        
        __weak typeof(operation) weakOp = operation;
        [operation addExecutionBlock:^{
            UIImage *image = [UIImage imageWithData:[model isKindOfClass:[StoryModel class]]?[NSData dataWithContentsOfURL:[NSURL URLWithString:model.face]]:model.facePic];
            float scale = [UIScreen mainScreen].scale;
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(cell.bounds.size.width, 230), YES, scale);
            [image drawInRect:CGRectMake(0, 0, self.view.bounds.size.width, 230)];
            thumbImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (![weakOp isCancelled]) {
                    cell.imgView.image = thumbImage;
                    [imageCache setObject:thumbImage forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
                }
            }];
        }];
        [operationQueue addOperation:operation];
    }
    


#endif
//    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.face]]];
//    [cell.imageView setImageWithURL:[NSURL URLWithString:model.face] placeholderImage:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSBlockOperation *operation = [operationStack objectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.row]];
    if (operation) {
        if (!operation.cancelled) {
            [operation cancel];
            [operationStack removeObjectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.row]];
        }
    }

    
//    TableViewCell *cell1 = cell;
//    cell1.imgView.image = nil;
    
}

- (void)btnClick:(UIButton*)btn
{
    if (![dele.loginStatus isEqualToString:@"success"])
    {
        LoginController *log = [[LoginController alloc]init];
        [self.navigationController pushViewController:log animated:YES];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y, 100, btn.frame.size.height)];
        [self.view addSubview:label];
    }
   
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
//   
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!dele.error)
    {
        DetailViewController *vc = [[DetailViewController alloc]init];
        StoryModel *model = _dataArray[indexPath.row];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (velocity.y > 0)
    {
        dele.customView.hidden = YES;
       
    }
    else
    {
        dele.customView.hidden = NO;
        
        [self beginRefresh:scrollView];
    }
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y == kContentOffSizeHeight) {
        
        [self beginRefresh1:scrollView];
    }
    
    if (!_isSaveStatus) {
        [self saveData];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"offset = %@",NSStringFromCGPoint(scrollView.contentOffset));
//    NSLog(@"inset = %@", NSStringFromUIEdgeInsets(scrollView.contentInset));    
}




- (void)beginRefresh1:(UIScrollView*)scrollView
{
    _view.frame = (CGRect){0,scrollView.contentSize.height,self.view.frame.size.width,64};
    _view.hidden = NO;
    [_act startAnimating];
   
    [UIView animateWithDuration:.5 animations:^{
            _tableView.contentInset = UIEdgeInsetsMake(0, 0,64, 0);
    }];
    [self performSelector:@selector(stopRefresh1) withObject:nil afterDelay:0.0];
//     _loadLabel.text = @"正在加载...";
}



- (void)stopRefresh1
{
    if (requestCount < laterUtlArray.count-1)
    {
        if (flag)
        {
            requestCount++;
            [self sendRequest:laterUtlArray[requestCount] withType:@"main" isRefresh:NO];
            flag = NO;
            
        }
        
    }
    else
    {
        [self resetFrame];
    }

}

- (void)resetFrame
{
    // 停止转动
    [_act stopAnimating];
    
    _loadLabel.text = @"加载完成";

    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        [UIView animateWithDuration:1.0 animations:^{
            [_tableView setContentInset:UIEdgeInsetsZero];
            

        } completion:^(BOOL finish)
         {
             _view.frame = CGRectZero;
             _view.hidden = YES;
             _loadLabel.text = @"正在加载...";
         }];
        
    });
    
}



- (void)addSegmentControl
{
    NSString *left = @"最新";
    NSString *right = @"附近";
   segment = [[UISegmentedControl alloc]initWithItems:@[left,right]];
    self.navigationItem.titleView = segment;
    segment.frame = CGRectMake(20, 0, 180, 30);
    segment.selectedSegmentIndex = 0;
    segment.tintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
    [segment addTarget:self action:@selector(observe) forControlEvents:(UIControlEventValueChanged)];
}
- (void)observe
{

    if (segment.selectedSegmentIndex == 0)
    {
        [self sendRequest:laterUtlArray[0] withType:@"main" isRefresh:YES];
    }
    else
    {
        segment.selectedSegmentIndex = 1;
        [self sendRequest:laterUtlArray[1] withType:@"main" isRefresh:YES];
    }
    
}



- (void)initAll
{
    _dataArray = [NSMutableArray array];
    dele = [UIApplication sharedApplication].delegate;
    activity = [CategoryActivity shareCategory];
    _view = [[UIView alloc]initWithFrame:CGRectZero];
    _act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
    
    _act.frame = CGRectMake(0, 10, self.view.frame.size.width, 20);
    [_view addSubview:_act];
    _view.backgroundColor = [UIColor grayColor];
    [_tableView addSubview:_view];
    
    _loadLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 20)];
    [_view addSubview:_loadLabel];
    _loadLabel.font = [UIFont systemFontOfSize:12];
    _loadLabel.textAlignment = NSTextAlignmentCenter;
    
 
}

- (void)addTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,30,self.view.frame.size.width,self.view.frame.size.height - 94)];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 230;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
   
    // 天气
    WeatherView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    WeatherView.backgroundColor = [UIColor whiteColor];
    addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    weatherLabel = [[UILabel alloc]initWithFrame:CGRectMake(220, 0, 80, 30)];
    [WeatherView addSubview:addressLabel];
    [WeatherView addSubview:weatherLabel];

    [self.view addSubview:WeatherView];
}



- (void)swipeLeft
{
    
    [UIView animateWithDuration:0.0 animations:^{
        _search = [[SearchResultController alloc]init];
        _search.view.alpha = 0.7;
        _search.view.tag = 100;
        _search.view.backgroundColor = [UIColor blackColor];
        
        _leftVc = [[LeftViewController alloc]init];
        _leftVc.delegate = self;
       
        _leftVc.view.backgroundColor = [UIColor whiteColor];
        
        nav2 = [[UINavigationController alloc]initWithRootViewController:_leftVc];
        nav2.navigationBarHidden = YES;
        nav2.view.tag = 200;
        
        [self.view.window addSubview:_search.view];
        [self.view.window addSubview:nav2.view];
        
        nav2.view.frame = CGRectMake(0, 0, self.view.window.bounds.size.width * .85, self.view.window.bounds.size.height);
    }];
   
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(backClick:)];
    
  __unused  UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGesture:)];
    
    
    [_leftVc.view addGestureRecognizer:pan];
    
   [_search.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backClick)]];
 
  
}

- (void)addLeftTableView
{
    UITableView *tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 200, 280) style:(UITableViewStyleGrouped)];
    tabView.backgroundColor = [UIColor redColor];
   // [leftView addSubview:tabView];
}


- (void)swipeGesture:(UISwipeGestureRecognizer*)swipe
{
    CGPoint location = [swipe locationInView:_leftVc.view];
    CGRect rect = _leftVc.view.frame;
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
       rect.origin.x += location.x;
        _leftVc.view.frame = rect;
        NSLog(@"%f",location.x);
    }
    else if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        rect.origin.x -= location.x;
        _leftVc.view.frame = rect;
        NSLog(@"%f",location.x);
    }
    
}

#pragma mark 实现侧滑
- (void)backClick:(UIPanGestureRecognizer*)pan
{
    CGPoint deltaPoint = [pan translationInView:nav2.view];
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        if ([pan velocityInView:self.view].x < 0) {
            
            [UIView animateWithDuration:0.1 animations:^{
                [nav2.view setTransform:CGAffineTransformMakeTranslation(deltaPoint.x, 0)];
                _search.view.alpha = 0.7 + (deltaPoint.x/nav2.view.frame.size.width * 1.5);
                if (_search.view.alpha < 0) {
                    _search.view.alpha = 0;
                }
            }];
           
           
        }
        else
        {
            
            [UIView animateWithDuration:0.1 animations:^{
                [nav2.view setTransform:CGAffineTransformMakeTranslation(deltaPoint.x, 0)];
                if (_search.view.alpha < 0.7f)
                {
                    _search.view.alpha = 0.7 + (deltaPoint.x/nav2.view.frame.size.width * 1.5);
                }
                else
                {
                    _search.view.alpha = 0.7f;
                }
                
               [UIView animateWithDuration:.1 animations:^{
                   if (nav2.view.frame.origin.x > 0) {
                       
                       [nav2.view setTransform:(CGAffineTransformIdentity)];
                       
                   }
               }];
                
            }];
        }
       
    }
    else if (pan.state == UIGestureRecognizerStateEnded)
    {
        if (deltaPoint.x < - nav2.view.frame.size.width * .3)
        {
            [UIView animateWithDuration:.1 animations:^{
                [self backClick];
            }];
           
        }
        else
        {
            [UIView animateWithDuration:.1 animations:^{
              [nav2.view setTransform:(CGAffineTransformIdentity)];
            }];
            
        }
    }
  
    
}

- (void)backClick
{
    [UIView animateWithDuration:.2 animations:^{
        _search.view.frame = CGRectMake( -self.view.frame.size.width, 0, self.view.frame.size.width, [UIScreen mainScreen].applicationFrame.size.height);
        nav2.view.frame = CGRectMake( -self.view.frame.size.width, 0, self.view.frame.size.width, [UIScreen mainScreen].applicationFrame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    [_search removeFromParentViewController];
    [nav2 removeFromParentViewController];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    

}



@end


















