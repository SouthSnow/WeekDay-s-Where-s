//
//  CollectController.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/10.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "CollectController.h"
#import "SettingController.h"
#import "LoginController.h"
#import "ThreeCell.h"
#import "DetailTableViewCell.h"
#import "DetailViewController.h"
#import "AFHTTPRequestOperation.h"
#import "ActCell.h"
#import "TableViewCell.h"
#import "Activity.h"
#import "TestViewController.h"

@interface CollectController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *_imgView;
    UIScrollView *_bodyScrollView;
    UISwipeGestureRecognizer *_leftSwipe;
    UISwipeGestureRecognizer *_rightSwipe;
    UITableView *_tableView;
    NSMutableData *_data;
    NSMutableArray *_dataArray;
    NSMutableArray *_topStoryArray;
    UIPageControl *_pageCtl;
    NSTimer *_timer;
    NSMutableArray *_loopArray;
    AppDelegate *dele;
    UIView *_view;
    UIView *view;
    UILabel *label;
    UILabel *label2;
    UIActivityIndicatorView *_act;
    ThreeCell *_cell;
    UILabel *_label;
    UISegmentedControl *segment;
    UIView *footerView;
    NSArray *urlArray;
}
@end

@implementation CollectController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initAll];
        self.navigationController.navigationBar.translucent = NO;
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (![dele.loginStatus isEqualToString:@"success"])
    {
        [self addTips1];
        self.title = @"收藏";
    }
   
}

- (void)viewWillAppear:(BOOL)animated
{
    
    dele.customView.hidden = NO;
    [_tableView reloadData];
    if ([dele.loginStatus isEqualToString:@"success"])
    {
        // 移除所有的原控件
        for (int i = 0; i < self.view.subviews.count; i++)
        {
            [[self.view.subviews objectAtIndex:i] removeFromSuperview];
        }
        
        [self addTips];
        [self addSegmentControl];
        [self addTableView];
        
        [self dragRefresh];
        [self sendRequest:urlArray[0]];
       // [self performSelector:@selector(sendRequest:) withObject:urlArray[1] afterDelay:2];
        
    }
    else
    {
        [self addTips1];
    }
   
}
- (void)addTips1
{
    // 移除所有的原控件
    for (UITableView *myView in self.view.subviews) {
        [myView removeFromSuperview];
    }
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 53)/2, 90, 53, 53)];
    imgView.image = [UIImage imageNamed:@"pic_empty_link"];
    [self.view addSubview:imgView];
    
    UILabel *noLogin = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 170)/2, imgView.frame.size.height + imgView.frame.origin.y + 40, 170, 21)];
    noLogin.text = @"你还没有登录";
    noLogin.textAlignment = NSTextAlignmentCenter;
    noLogin.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:noLogin];
    
    UILabel *afterLogin = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 280)/2, noLogin.frame.size.height + noLogin.frame.origin.y + 40, 280, noLogin.frame.size.height)];
    afterLogin.text = @"登录后才可查看你的[收藏]";
    afterLogin.textAlignment = NSTextAlignmentCenter;
    afterLogin.font = [UIFont systemFontOfSize:12];
    [self.view addSubview: afterLogin];
    
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 200)/2, afterLogin.frame.size.height + afterLogin.frame.origin.y + 40, 200, 30)];
    [loginBtn setTitle:@"立即登录" forState:(UIControlStateNormal)];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    loginBtn.backgroundColor = [UIColor redColor];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:loginBtn];
}

- (void)login
{
    LoginController *login = [[LoginController alloc]init];
    [self.navigationController pushViewController:login animated:YES];
}

#warning =========
#if 1

- (void)dragRefresh
{
    _view = [[UIView alloc]initWithFrame:(CGRect){0,-64,self.view.frame.size.width,64}];
    [_tableView addSubview:_view];
    
    UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    act.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
    [_view addSubview:act];
    _view.backgroundColor = [UIColor grayColor];
    _act = act;
}

- (void)beginRefresh:(UIScrollView*)scrollView
{
    NSLog(@"scrollView.contentOffset.y ==%F",scrollView.contentOffset.y );
    [_act startAnimating];
    if (scrollView.contentOffset.y < -64.0)
    {
        
        [UIView animateWithDuration:0.5 animations:^{
            _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        }];
        [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2.0];
    }
    
}

- (void)stopRefresh
{
    [UIView animateWithDuration:.5 animations:^{
        [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }];
    
    [_tableView reloadData];

    if (segment.selectedSegmentIndex == 0)
    {
        [self sendRequest:urlArray[0]];
    }
    else
    {
        [self sendRequest:urlArray[1]];
    }
    [_act stopAnimating];
}



- (void)addTips
{
    _imgView.frame = CGRectMake((self.view.frame.size.width - 56)/2,50,56,56);
    _label.frame = CGRectMake(30, _imgView.frame.size.height + _imgView.frame.origin.y + 10, self.view.frame.size.width - 60, 44);
    _label.text = @"没有现在进行的活动,先去收藏吧";
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:15];
    _label.textColor = [UIColor grayColor];
    [self.view addSubview:_label];
    _imgView.image = [UIImage imageNamed:@"pic_empty_like.png"];
    [self.view addSubview:_imgView];
}
- (void)addTableView
{
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 30)];
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    label2 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 50, 0, 50, 30)];
    [view addSubview:label];
    [view addSubview:label2];
    view.backgroundColor = [UIColor redColor];
    //[self.view addSubview:view];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (velocity.y > 0) {
        dele.customView.hidden = YES;
    }
    else
    {
        dele.customView.hidden = NO;
        [self beginRefresh:scrollView];
    }
}

#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if (_dataArray.count == 0)
//    {
//        _imgView.hidden = NO;
//        _label.hidden = NO;
//        [_tableView reloadData];
//        return nil;
//    }
//    else
//    {
//        _cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//        _cell.model = _dataArray[indexPath.row];
//        _imgView.hidden = YES;
//        _label.hidden = YES;
//        return _cell;
//    }
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.act = _dataArray[indexPath.row];
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TestViewController *vc = [[TestViewController alloc]init];
 
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (dele.selectedArray.count != 0)
    {
        footerView = [[UIView alloc]initWithFrame:CGRectZero];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 135)/2, 20, 135, 9)];
        imgView.image = [UIImage imageNamed:@"end"];
        [footerView addSubview:imgView];
        footerView.frame = CGRectMake(0, 0, self.view.frame.size.width, imgView.frame.size.height);
        return footerView;
    }
    
    
    return nil;
}


- (void)initAll
{
    _data = [NSMutableData data];
    _dataArray = [NSMutableArray array];
    _topStoryArray = [NSMutableArray array];
    dele = [UIApplication sharedApplication].delegate;
    _imgView = [[UIImageView alloc]init];
    _label = [[UILabel alloc]init];
     urlArray = @[@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&is_valid=1&lat=22.562471&lon=113.904378&method=user.activityList&os=iphone&pagesize=30&r=wanzhoumo&sign=81279627ddd4fa43c0411d7f6f67ea8a&timestamp=1410600297&top_session=rqtulsnhvt4d1fh36m1p6s7fr4&user_id=403461&v=2.0",@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&is_valid=0&lat=22.562471&lon=113.904378&method=user.activityList&os=iphone&pagesize=30&r=wanzhoumo&sign=3108e6a47c8c798c6dc45e7a59cd9eaf&timestamp=1410600551&top_session=rqtulsnhvt4d1fh36m1p6s7fr4&user_id=403461&v=2.0"];
    
}

- (void)addSegmentControl
{
    NSString *left =[NSString stringWithFormat:@"正在进行(0)"];
    NSString *right = [NSString stringWithFormat:@"已结束(0)"];
    segment = [[UISegmentedControl alloc]initWithItems:@[left,right]];
    self.navigationItem.titleView = segment;
    segment.frame = CGRectMake(0, 0, 180, 30);
    segment.selectedSegmentIndex = 0;
    segment.tintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
    [segment addObserver:self forKeyPath:@"selectedSegmentIndex" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@">>>>>>>>>%@",change);
    
    if ([change[@"new"] integerValue] == 1 )
    {
        _label.text = @"多一些收藏, 时间久了总会有的";
        [self sendRequest:urlArray[segment.selectedSegmentIndex]];
       
    }
    else
    {
         [self sendRequest:urlArray[segment.selectedSegmentIndex]];
        _label.text = @"没有现在进行的活动, 先去收藏吧";
    }
}

#endif



- (void)viewDidDisappear:(BOOL)animated
{
   // [self removeObserver:self forKeyPath:@"selectedSegmentIndex" context:nil];
}

- (void)sendRequest:(NSString*)urlStr
{
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [operation start];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
   
        [_dataArray removeAllObjects];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        for (NSDictionary *dic in dict[@"result"][@"list"])
        {
             Activity *act = [[Activity alloc]init];
            
            if (segment.selectedSegmentIndex == 1)
            {
                act.address = dic[@"activity.address"];
                act.actEndTime = dic[@"activity.end_time"];
                act.genre_main_show = dic[@"activity.genre_main_show"];
                act.actID = dic[@"activity.id"];
                act.poiID = dic[@"activity.poi_id"];
                act.activityPoiName = dic[@"activity.poi_name_app"];
                act.title = dic[@"activity.title"];
                act.startTime = dic[@"activity.start_time"];
                act.createTime = dic[@"create_time"];
                act.distance_show = dic[@"distance_show"];
                act.follow_num = dic[@"statis.follow_num"];
                act.userID = dic[@"user_id"];
                [act.picShowArray addObjectsFromArray:dic[@"activity.pic_show"]];
                [act.piclistArray addObjectsFromArray:dic[@"activity.pic_list_show"]];
                
            }
            else
            {
               
                act.address = dic[@"activity.address"];
                act.actEndTime = dic[@"activity.end_time"];
                act.genre_main_show = dic[@"activity.genre_main_show"];
                act.actID = dic[@"activity.id"];
                act.poiID = dic[@"activity.poi_id"];
                act.activityPoiName = dic[@"activity.poi_name_app"];
                act.title = dic[@"activity.title"];
                act.startTime = dic[@"activity.start_time"];
                act.createTime = dic[@"create_time"];
                act.distance_show = dic[@"distance_show"];
                act.follow_num = dic[@"statis.follow_num"];
                act.userID = dic[@"user_id"];
                [act.picShowArray addObjectsFromArray:dic[@"activity.pic_show"]];
                [act.piclistArray addObjectsFromArray:dic[@"activity.pic_list_show"]];
            }
            [_dataArray addObject:act];
        }
        if (segment.selectedSegmentIndex == 0) {
            [segment setTitle:[NSString stringWithFormat:@"正在进行(%d)",(int)_dataArray.count] forSegmentAtIndex:segment.selectedSegmentIndex];
        }
        else
        {
             [segment setTitle:[NSString stringWithFormat:@"已结束(%d)",(int)_dataArray.count] forSegmentAtIndex:segment.selectedSegmentIndex];
        }
       
        [_tableView reloadData];
 
   
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error");
        
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
