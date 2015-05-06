//
//  TrendsViewController.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/10.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "TrendsViewController.h"
#import "SettingController.h"
#import "LoginController.h"
#import "CollectCell.h"
#import "DetailViewController.h"
#import "StoryModel.h"
#import "AFHTTPRequestOperation.h"
#import "Notify.h"
#import "ActCell.h"

@interface TrendsViewController ()<UITableViewDataSource,UITableViewDelegate>
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
    CategoryActivity *activity;
    UILabel *_label;
    UISegmentedControl *segment;
    UIView *footerView;
    UITableView *_myTableView;
    NSArray *urlArray;
    
}
@end

@implementation TrendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"动态";
        [self initAll];
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
    }
    
   
    
}




- (void)viewWillAppear:(BOOL)animated
{
    dele.customView.hidden = NO;
    
    if ([dele.loginStatus isEqualToString:@"success"])
    {
        // 移除所有的原控件
        for (int i = 0; i < self.view.subviews.count; i++)
        {
            [[self.view.subviews objectAtIndex:i] removeFromSuperview];
        }
        [self addTips];
        [self addSegmentControl];
        if (segment.selectedSegmentIndex == 0)
        {
             [self addTableView];
            [self sendRequest:urlArray[0]];
        }
        else
        {
            [self addMytableView];
            
        }
        
        [self dragRefresh];
        
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
    afterLogin.text = @"登录后才可查看你的[动态]和[通知]";
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
    [_myTableView addSubview:_view];
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
            _myTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        }];
        [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2.0];
    }
    
}

- (void)stopRefresh
{
    [UIView animateWithDuration:.5 animations:^{
        if (segment.selectedSegmentIndex == 0)
        {
             [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        else
        {
            [_myTableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
       
    }];
    
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
    // 移除所有的原控件
    for (int i = 0; i < self.view.subviews.count; i++)
    {
        [[self.view.subviews objectAtIndex:i] removeFromSuperview];
    }
    _imgView.frame = CGRectMake((self.view.frame.size.width - 56)/2,50,56,56);
    _label.frame = CGRectMake(30, _imgView.frame.size.height + _imgView.frame.origin.y + 10, self.view.frame.size.width - 60, 44);
    _label.text = @"没有动态,好友们还没出动";
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:15];
    _label.textColor = [UIColor grayColor];
    [self.view addSubview:_label];
    _imgView.image = [UIImage imageNamed:@"pic_empty_like.png"];
    [self.view addSubview:_imgView];
}
- (void)addTableView
{
   
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height) style:(UITableViewStyleGrouped)];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"CollectCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ActCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    
}

- (void)addMytableView
{
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [self.view addSubview:_myTableView];
    _myTableView.backgroundColor = [UIColor whiteColor];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    
    [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
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
    if (tableView == _tableView)
    {
        return _dataArray.count;
    }
    else
        return _topStoryArray.count;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segment.selectedSegmentIndex == 0) {
        ActCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell.userData = _dataArray[indexPath.row];
        return cell;
    }
    else
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        Notify *not = _topStoryArray[indexPath.row];
       cell.textLabel.text = not.content;
       cell.textLabel.font = [UIFont systemFontOfSize:12];
       cell.textLabel.numberOfLines = 2;
       cell.imageView.image = [UIImage imageNamed:@"ico_notice_msg"];
       return cell;
   }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_dataArray.count != 0 || _topStoryArray.count != 0)
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segment.selectedSegmentIndex == 0)
    {
        
     //   DetailViewController *vc = [[DetailViewController alloc]init];
//        UserData *data = _dataArray[indexPath.row];
//        for (StoryModel *model in activity.allArray)
//        {
//            if ([data.userActivity isEqualToString:model.title])
//            {
 //                vc.model = ;
//                break;
//            }
//        }
       
       // [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)initAll
{
     activity = [CategoryActivity shareCategory];
    _dataArray = [NSMutableArray array];
    _topStoryArray = [NSMutableArray array];
    dele = [UIApplication sharedApplication].delegate;
    _imgView = [[UIImageView alloc]init];
    _label = [[UILabel alloc]init];
    urlArray = @[@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&method=user.feedList&offset=30&os=iphone&pagesize=30&r=wanzhoumo&sign=6c7a4c4db1243e0053273dcf398403b5&timestamp=1410590098&top_session=rqtulsnhvt4d1fh36m1p6s7fr4&v=2.0",@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&method=user.messagelist&os=iphone&pagesize=30&r=wanzhoumo&sign=d9d670afd66748fdffbf55ddd1611fa2&timestamp=1410590349&top_session=rqtulsnhvt4d1fh36m1p6s7fr4&v=2.0"];
}

- (void)addSegmentControl
{
    NSString *left = @"动态";
    NSString *right = @"通知";
    segment = [[UISegmentedControl alloc]initWithItems:@[left,right]];
    self.navigationItem.titleView = segment;
    segment.frame = CGRectMake(0, 0, 180, 30);
    segment.selectedSegmentIndex = 0;
    
    segment.tintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
    
    [segment addObserver:self forKeyPath:@"selectedSegmentIndex" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    //[self removeObserver:self forKeyPath:@"selectedSegmentIndex" context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@">>>>>>>>>%@",change);
 
    if ([change[@"new"] integerValue] == 1 )
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"清除" style:(UIBarButtonItemStylePlain) target:self action:@selector(clearNotify)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
        [self sendRequest:urlArray[1]];
        [self addMytableView];
        _label.text = @"没有新通知";
       
        
        
    }
    else
    {
        [self sendRequest:urlArray[0]];
            _label.text = @"没有动态,好友们还没出动";
            [self addTableView];
        
        self.navigationItem.rightBarButtonItem = nil;
    }

}

- (void)clearNotify
{
   
    NSString *stringUrl = [NSString stringWithFormat:@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&ids=all&method=user.messagedelete&os=iphone&r=wanzhoumo&sign=fd3dac0cbd3cd5e98cf464c6d6ad0da9&timestamp=1410598474&top_session=rqtulsnhvt4d1fh36m1p6s7fr4&v=2.0"];
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation start];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response=====%@",responseObject);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        NSLog(@"===========%@",dict);
        if ([dict[@"status"] isEqualToString:@"success"])
        {
            [_topStoryArray removeAllObjects];
            [_myTableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error");
    }];
   
}

- (void)sendRequest:(NSString*)urlStr
{
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [operation start];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_topStoryArray removeAllObjects];
        [_dataArray removeAllObjects];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        for (NSDictionary *dic in dict[@"result"][@"list"])
        {
           
            if (segment.selectedSegmentIndex == 1)
            {
                Notify *notify = [[Notify alloc]init];
                notify.ID = dic[@"id"];
                notify.type = dic[@"type"];
                notify.url = dic[@"url"];
                notify.createTime = dic[@"createtime"];
                notify.content = dic[@"content"];
                [_topStoryArray addObject:notify];
                
            }
            else
            {
                UserData *data = [[UserData alloc]init];
               
                data.userID = dic[@"user_id"];
                data.userContent = dic[@"content"];
                data.userType = dic[@"type"];
                data.userNick = dic[@"sponsor_name"];
                data.userpoi = dic[@"poi.title"];
                data.userActivity = dic[@"target_title"];
                data.userActivityVice = dic[@"target_vice_title"];
                data.userCreateTime = dic[@"createtime"];
                data.userReplyNum = dic[@"reply_num"];
                data.targetPic = dic[@"target_pic"];
                [_dataArray addObject:data];
            }
           
        }
        if (segment.selectedSegmentIndex == 0) {
            [_tableView reloadData];
        }
        else
        {
            [_myTableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error");
        
    }];
    
    
}


#endif









- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
