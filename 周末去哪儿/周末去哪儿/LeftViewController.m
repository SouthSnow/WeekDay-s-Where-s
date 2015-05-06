//
//  LeftViewController.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/3.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "LeftViewController.h"
#import "PPRevealSideViewController.h"
#import "SearchResultController.h"
#import "RootViewController.h"
#import "NaviController.h"
#import "SearchController.h"

#define kFont 12
@interface LeftViewController ()<UISearchBarDelegate,searchDelegate>
{
    __weak IBOutlet UIButton *allActivity;//1
    __weak IBOutlet UIButton *hot;//2
    __weak IBOutlet UIButton *round;//3
    __weak IBOutlet UIButton *countrySide;//4
    __weak IBOutlet UIButton *show;//5
    __weak IBOutlet UIButton *music;//6
    __weak IBOutlet UIButton *opera;//7
    __weak IBOutlet UIButton *party;//8
    __weak IBOutlet UIButton *family;//9
    __weak IBOutlet UIButton *meeting;//10
    __weak IBOutlet UIButton *art;//11
    __weak IBOutlet UIButton *autom;//12
    CategoryActivity *activity;
    NSArray *urlString;
    NSArray *title;
   
    int searchIndex;
    UITableView *_tableView;
    UIView *searchView;
    UISearchBar *_searchBar;
    UISearchDisplayController *_displayController;
    UINavigationBar *navigationBar;
    UINavigationItem * navigationItem;
}

@property (nonatomic, strong) SearchController *search;

@end

@implementation LeftViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        activity = [CategoryActivity shareCategory];
    }
    return self;
}

- (void)addSearchBar
{
    
    _searchBar = [[UISearchBar alloc]initWithFrame:(CGRect){20,30,self.view.frame.size.width * .85 - 40,30}];
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.placeholder = @"搜索活动或地点";
    _searchBar.layer.cornerRadius = 15.0f;
    [_searchBar setShowsCancelButton:NO animated:YES];
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _searchBar.delegate = self;
    _searchBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
    
    searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * .85, 64)];
     searchView.backgroundColor = [UIColor whiteColor];
    searchView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [searchView addSubview:_searchBar];
    [self.view addSubview:searchView];

    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
   
    [self titleAndUrlString];
    [self setBtn];
    [self addSearchBar];
   
}

- (void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden = YES;
}







- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    self.search = [[SearchController alloc]init];
    self.search.delegate = self;
    [self.view.window addSubview:self.search.view];
    
  
#if 0
    [self presentViewController:self.search animated:NO completion:^{
        self.search.view.backgroundColor = [UIColor blackColor];
        self.search.view.alpha = .7f;
        
    }];
#endif
    
    
}

#pragma mark searchDelegate
- (void)changeFrame
{
    self.navigationController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * .85, [UIScreen mainScreen].bounds.size.height);
   
}



- (IBAction)allBtn:(UIButton*)sender
{
    
   // [self.view.window bringSubviewToFront:self.view.window.rootViewController.view];
    
    for (UIView *view in self.view.window.subviews) {
        if (view.tag == 100) {
            view.hidden = YES;
            [view removeFromSuperview];
        }
        if (view.tag == 200) {
            view.hidden = YES;
            [view removeFromSuperview];
        }
        NSLog(@"%ld",view.tag);
    }
    activity.selecteIndex = sender.tag;
    sender.selected = YES;
    switch (sender.tag) {
        case 1:
        {
            [self setStory:urlString[0]];
           
        }
            break;
        case 2:
        {
            [self setStory:urlString[1]];
        }
            break;
        case 3:
        {
            [self setStory:urlString[2]];
        }
            break;
        case 4:
        {
            [self setStory:urlString[3]];
        }
            break;
        case 5:
        {
            [self setStory:urlString[4]];
        }
            break;
        case 6:
        {
            [self setStory:urlString[5]];
        }
            break;
        case 7:
        {
            [self setStory:urlString[6]];
        }
            break;
        case 8:
        {
            [self setStory:urlString[7]];
        }
            break;
        case 9:
        {
            [self setStory:urlString[8]];
        }
            break;
        case 10:
        {
            [self setStory:urlString[9]];
        }
            break;
        case 11:
        {
            [self setStory:urlString[10]];
        }
            break;
        case 12:
        {
            [self setStory:urlString[11]];
        }
            break;
       
    
        default:
            break;
    }
       
    
}

- (void)setStory:(NSString*)url
{
    if (_delegate && [_delegate respondsToSelector:@selector(ChangeCategory:)])
    {
        [_delegate ChangeCategory:url];
    }
}



- (void)setBtn
{
   
    
    NSArray *btnArray = @[allActivity,hot,round,countrySide,show,music,opera,party,family,meeting,art,autom];
    NSLog(@"=====tag=======%d",(int)activity.selecteIndex);
    for (int i = 0; i< btnArray.count; i++)
    {
        UIButton *btn = btnArray[i];
        [btn setTitle:title[i] forState:(UIControlStateNormal)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:kFont]];
        btn.selected = (btn.tag == activity.selecteIndex)?YES : NO;
        [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]] forState:(UIControlStateSelected)];
        
    }
    if (!activity.selecteIndex) {
        allActivity.selected = YES;
        [allActivity setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]] forState:(UIControlStateSelected)];
    }
   
}

- (void)titleAndUrlString
{
    title = [NSArray arrayWithObjects:@"全部活动",@"热门",@"周边游",@"田园",@"展览",@"音乐",@"戏剧",@"聚会",@"亲子",@"约会",@"文艺",@"赏秋", nil];
    urlString = @[@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&is_near=1&is_valid=1&lat=22.534835&lon=113.944981&method=activity.List&os=iphone&pagesize=30&r=wanzhoumo&sign=8a425ee274a1946a0ccf001bf0495239&sort=default&timestamp=1409899798&top_session=j3dh50bd8vqh8iqqtgbjhuvap1&v=2.0",@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&genre_id=67&is_near=1&is_valid=1&lat=22.534835&lon=113.944981&method=activity.List&os=iphone&pagesize=30&r=wanzhoumo&sign=1609c7a24146e3f4eacf7551f7c12035&sort=default&timestamp=1409899846&top_session=j3dh50bd8vqh8iqqtgbjhuvap1&v=2.0",@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&genre_id=41&is_near=1&is_valid=1&lat=22.534835&lon=113.944981&method=activity.List&os=iphone&pagesize=30&r=wanzhoumo&sign=b92b855f294fe96a68a7b2e74fef0c43&sort=default&timestamp=1409899890&top_session=j3dh50bd8vqh8iqqtgbjhuvap1&v=2.0",@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&genre_id=70&is_near=1&is_valid=1&lat=22.534835&lon=113.944981&method=activity.List&os=iphone&pagesize=30&r=wanzhoumo&sign=40eb7da08545b1e5e0099cb0135ecc10&sort=default&timestamp=1409899942&top_session=j3dh50bd8vqh8iqqtgbjhuvap1&v=2.0",@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&genre_id=44&is_near=1&is_valid=1&lat=22.534835&lon=113.944981&method=activity.List&os=iphone&pagesize=30&r=wanzhoumo&sign=d575afb93e59945aa1fe7be4730ba2bb&sort=default&timestamp=1409899986&top_session=j3dh50bd8vqh8iqqtgbjhuvap1&v=2.0",@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&genre_id=42&is_near=1&is_valid=1&lat=22.534835&lon=113.944981&method=activity.List&os=iphone&pagesize=30&r=wanzhoumo&sign=47e54e44b849f49a682c35b7519a327d&sort=default&timestamp=1409900024&top_session=j3dh50bd8vqh8iqqtgbjhuvap1&v=2.0",@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&genre_id=43&is_near=1&is_valid=1&lat=22.534835&lon=113.944981&method=activity.List&os=iphone&pagesize=30&r=wanzhoumo&sign=d90da19ab051f56cd59fe668484d3496&sort=default&timestamp=1409900073&top_session=j3dh50bd8vqh8iqqtgbjhuvap1&v=2.0",@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&genre_id=66&is_near=1&is_valid=1&lat=22.534835&lon=113.944981&method=activity.List&os=iphone&pagesize=30&r=wanzhoumo&sign=0b1cb4a105372b20b9d796fcf4b64f96&sort=default&timestamp=1409900122&top_session=j3dh50bd8vqh8iqqtgbjhuvap1&v=2.0",@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&genre_id=71&is_near=1&is_valid=1&lat=22.534835&lon=113.944981&method=activity.List&os=iphone&pagesize=30&r=wanzhoumo&sign=9d82858d816d5aeadae99ef302f16541&sort=default&timestamp=1409900154&top_session=j3dh50bd8vqh8iqqtgbjhuvap1&v=2.0",@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&genre_id=72&is_near=1&is_valid=1&lat=22.534835&lon=113.944981&method=activity.List&os=iphone&pagesize=30&r=wanzhoumo&sign=f5b84e0c9419498afe6357d13d900922&sort=default&timestamp=1409900187&top_session=j3dh50bd8vqh8iqqtgbjhuvap1&v=2.0",@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&genre_id=73&is_near=1&is_valid=1&lat=22.534835&lon=113.944981&method=activity.List&os=iphone&pagesize=30&r=wanzhoumo&sign=294232b9396a726020c962f8bf1bddcb&sort=default&timestamp=1409900215&top_session=j3dh50bd8vqh8iqqtgbjhuvap1&v=2.0",@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&genre_id=114&is_near=1&is_valid=1&lat=22.534835&lon=113.944981&method=activity.List&os=iphone&pagesize=30&r=wanzhoumo&sign=d42fd782798d33e6ea6ab5630eab0a59&sort=default&timestamp=1409899485&top_session=j3dh50bd8vqh8iqqtgbjhuvap1&v=2.0"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

@end








