//
//  TwoDetailController.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/3.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "TwoDetailController.h"
#import "AFHTTPRequestOperation.h"
#import "ActivityModel.h"
#import "ActivityCell.h"
#import "UIImageView+WebCache.h"
@interface TwoDetailController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView *_scrollView;
    UIScrollView *_bodyScrollView;
    UISwipeGestureRecognizer *_leftSwipe;
    UISwipeGestureRecognizer *_rightSwipe;
    UITableView *_tableView;
    UITableView *_tableView2;
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
    UIView *headerView;
    UIView *footerView;
}
@end

@implementation TwoDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"专题详情";
        [self initAll];
    }
    return self;
}

- (void)setModel:(StoryModel *)model
{
    _model = model;
    NSLog(@"model =====%@",model);
    ActivityModel *m = [[ActivityModel alloc]init];
    m.activityTitle = _model.title;
    m.start_time_show = _model.start_time_show;
    m.activity_pic_h5list = _model.pic_show;
    m.introdution = _model.introdution;
    [_topStoryArray addObject:m];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dele.customView.hidden = YES;
    [self addTableView];
    [self sendRequest];
    self.view.backgroundColor = [UIColor whiteColor];
    //_tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
    
}

- (void)addTableView
{
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, 320, 30)];
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    label2 = [[UILabel alloc]initWithFrame:CGRectMake(270, 0, 50, 30)];
    [view addSubview:label];
    [view addSubview:label2];
    view.backgroundColor = [UIColor redColor];
    //[self.view addSubview:view];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,320,self.view.frame.size.height) style:(UITableViewStyleGrouped)];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"ActivityCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (void)sendRequest
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&id=%@&lat=22.534790&lon=113.944979&method=topic.detail&os=iphone&pagesize=20&r=wanzhoumo&sign=dd509e615566c49f047c00dc9af3bd46&timestamp=1409754711&top_session=pqr2e1q3skdqiinui7vddbvbn5&v=2.0",_model.sID]];
    NSLog(@"ID====%@",_model.pic_show);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation start];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"success");
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
    
        for (NSDictionary *dic in dictionary[@"result"][@"ap_list"])
        {
            ActivityModel *model = [[ActivityModel alloc]init];
            model.activityTitle = dic[@"activity.title"];
            model.activity_pic_h5list = dic[@"activity.pic_h5list"];
            [model.activity_pic_list_show addObjectsFromArray:dic[@"activity.pic_list_show"]];
            model.introdution = dic[@"intro"];
            model.start_time_show = dic[@"start_time_show"];
            model.activity_address = dic[@"activity.poi_name_app"];
            model.activity_statis_follow_num = dic[@"activity.statis.follow_num"];
            model.activity_poi_name_app = dic[@"activity.poi_name_app"];
            model.activity_lon = dic[@"activity.lon"];
            model.activity_lat = dic[@"activity.lat"];
            model.distance_show = dic[@"distance_show"];
            model.ID = dic[@"id"];
            NSLog(@"ID====%@",model.ID);
            
            [_dataArray addObject:model];
        }
        
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
    }];
    
    
}

#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
    cell.model = _dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height + 20;
}



- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    headerView = [[UIView alloc] initWithFrame:CGRectZero];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 130)];
    ActivityModel *model = _topStoryArray[0];
    [imgView setImageWithURL:[NSURL URLWithString:model.activity_pic_h5list] placeholderImage:nil];
    UILabel *date = [[UILabel alloc]initWithFrame:CGRectMake(10, imgView.frame.origin.y + imgView.frame.size.height + 10, 80, 20)];
    date.font = [UIFont systemFontOfSize:10];
    date.text = model.start_time_show;
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(date.frame.size.width + date.frame.origin.x + 10, date.frame.origin.y + date.frame.size.height / 2, self.view.frame.size.width -(date.frame.size.width + date.frame.origin.x + 10 + 10) , 1)];
    line.backgroundColor = [UIColor grayColor];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, date.frame.size.height + date.frame.origin.y + 10, self.view.frame.size.width - 20, 20)];
    title.text = model.activityTitle;
    title.font = [UIFont systemFontOfSize:15];
    UILabel *body = [[UILabel alloc]initWithFrame:CGRectMake(10, title.frame.size.height + title.frame.origin.y + 10, self.view.frame.size.width - 20, 44)];
    body.text = model.introdution;
    body.font = [UIFont systemFontOfSize:13];
    body.textColor = [UIColor grayColor];
    body.numberOfLines = 0;
    
    CGFloat height;
    CGFloat verSion = [[UIDevice currentDevice].systemVersion floatValue];
    if (verSion >= 7.0)
    {
        height = [body.text boundingRectWithSize:CGSizeMake(300, 2999) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: body.font} context:nil].size.height;
    }
    else
    {
        height = [body.text sizeWithAttributes:@{NSFontAttributeName: body.font}].height;
    }
    body.frame = CGRectMake(body.frame.origin.x, body.frame.origin.y, body.frame.size.width, height);
    [headerView addSubview:imgView];
    [headerView addSubview:date];
    [headerView addSubview:line];
    [headerView addSubview:title];
    [headerView addSubview:body];
    headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, imgView.frame.size.height + date.frame.size.height + body.frame.size.height + title.frame.size.height);
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 360;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    footerView = [[UIView alloc]initWithFrame:CGRectZero];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 135)/2, 10, 135, 9)];
    imgView.image = [UIImage imageNamed:@"end"];
    [footerView addSubview:imgView];
    footerView.frame = CGRectMake(0, 0, self.view.frame.size.width, imgView.frame.size.height);
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 9;
}
- (void)initAll
{
    _data = [NSMutableData data];
    _dataArray = [NSMutableArray array];
    _topStoryArray = [NSMutableArray array];
    dele = [UIApplication sharedApplication].delegate;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end














