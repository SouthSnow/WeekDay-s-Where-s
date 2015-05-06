//
//  TestViewController.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/13.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "TestViewController.h"
#import "UIImageView+WebCache.h"
#import "CommentViewController.h"
#import "DetCell.h"
#import <MapKit/MapKit.h>
#import "AFHTTPRequestOperation.h"
#import "DetailModel.h"
#import "TestCell.h"
#import "PoiViewController.h"
#import "MapViewController.h"
#import "DetCell.h"
#import "MapController.h"




@interface TestViewController ()<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate,UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
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
    DetCell *_cell;
    int page;
    UIView *footerView;
    UIView *headerView;
    UIView *pageView;
    AppDelegate *dele;
    dispatch_queue_t _mainQueue;
    dispatch_queue_t _globelQueue;
    
    
}
@property (nonatomic, strong) MapViewController *mapController;
@end

@implementation TestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initAll];
        UIBarButtonItem *shareBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"details_top_white_share_normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(share)];
        UIBarButtonItem *favBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"details_top_white_like_normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(fav:)];
        self.navigationItem.rightBarButtonItems = @[favBar,shareBar];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"details_top_blue_back_normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
        
        _mainQueue = dispatch_get_main_queue();
        _globelQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
    }
    return self;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    dele.customView.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    dispatch_async(_globelQueue, ^{
        [self sendRequest2];
        dispatch_async(_mainQueue, ^{
        [self addTableView1];
        [self addCommentBtn];
        });
    });
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [_timer setFireDate:[NSDate distantPast]];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_timer setFireDate:[NSDate distantFuture]];
}


#pragma mark 同步请求
- (void)sendRequest2
{
    NSURL *url = [NSURL URLWithString:@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&id=10631&lat=22.534918&lon=113.944932&method=activity.detail&os=iphone&r=wanzhoumo&sign=bf7bfcdf832ca366131d47006ee84e11&timestamp=1411572187&top_session=7mkvml1tjegg0i700rph7vgeg0&v=2.0"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *respone;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&respone error:nil];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
    NSDictionary *dic = dictionary[@"result"];
    
    DetailModel *model = [[DetailModel alloc]init];
    model.title = dic[@"title"];
    model.title_vice = dic[@"title_vice"];
    model.tel = dic[@"tel"];
    model.cost = dic[@"cost"];
    model.address = dic[@"address"];
    model.showTime = dic[@"time_txt"];
    [model.picShowArray addObjectsFromArray: dic[@"pic_show"]];
    model.introdution = dic[@"intro"];
    model.start_time_show = dic[@"start_time_show"];
    model.pic_show = dic[@"pic_show"];
    model.ID = dic[@"id"];
    model.position = dic[@"poi_name_app"];
    model.longitude = dic[@"lon"];
    model.latitude = dic[@"lat"];
    
    
    [_dataArray addObject:model];
    
    NSString *title = dictionary[@"result"][@"poi_all"][0][@"title"];
    [_topStoryArray addObject:title];
    NSLog(@"0000000%@",_topStoryArray[0]);
    NSString *cost = dictionary[@"result"][@"poi_all"][0][@"cost"];
    [_topStoryArray addObject:cost];
    NSString *address = dictionary[@"result"][@"poi_all"][0][@"address"];
    [_topStoryArray addObject:address];
    NSString *openTime= dictionary[@"result"][@"poi_all"][0][@"open_time"];
    [_topStoryArray addObject:openTime];
    NSString *lat = dictionary[@"result"][@"poi_all"][0][@"lat"];
    [_topStoryArray addObject:lat];
    NSString *lon = dictionary[@"result"][@"poi_all"][0][@"lon"];
    [_topStoryArray addObject:lon];
}

- (void)share
{
//    DetailModel *model = _dataArray[0];
//    
//    if ([dele.loginStatus isEqual:@"success"])
//    {
//        NSLog(@"分享");
//        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
//        
//        id<ISSContent>publishContent = [ShareSDK content:[NSString stringWithFormat:@"#周末去哪儿#%@「%@」http://t.cn/RhMv9x0 @周末去哪儿APP",[model.introdution substringToIndex:40],model.title]
//                                          defaultContent:@""
//                                                   image:[ShareSDK imageWithPath:[[NSBundle mainBundle] pathForResource:@"mm.pag" ofType:nil]]
//                                                   title:@"ShareSDK" url:@"https://api.weibo.com/oauth2/default.html"
//                                             description:@"这是一条测试信息"
//                                               mediaType:(SSPublishContentMediaTypeNews)];
//        [ShareSDK content:@"分享内容"
//           defaultContent:@"默认分享内容,没有内容时显示"
//                    image:[ShareSDK imageWithPath:imagePath]
//                    title:@"shareSDK"
//                      url:@"https://api.weibo.com/oauth2/default.html"
//              description:@"这是一条测试信息"
//                mediaType:SSPublishContentMediaTypeNews];
//        
//        [ShareSDK showShareActionSheet:nil
//                             shareList:[NSArray defaultOneKeyShareList]
//                               content:publishContent
//                         statusBarTips:YES
//                           authOptions:nil
//                          shareOptions:nil
//                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                    if (state == SSResponseStateSuccess)
//                                    {
//                                        NSLog(@"分享成功");
//                                    }
//                                    else if (state == SSResponseStateFail)
//                                    {
//                                        
//                                        NSLog(@"分享失败,错误码:%d,错误描述:%@",(int)[error errorCode],[error errorDescription]);
//                                    }
//                                }];
//    }
//    else
//    {
//        LoginController *log = [[LoginController alloc]init];
//        [self.navigationController pushViewController:log animated:YES];
//    }
//    
    
    
}

- (void)fav:(UIBarButtonItem*)sender
{
    DetailModel *model = _dataArray[0];
    NSLog(@"收藏");
    if (![dele.loginStatus isEqualToString:@"success"])
    {
        LoginController *log = [[LoginController alloc]init];
        [self.navigationController pushViewController:log animated:YES];
    }
    else
    {
        if ([sender.image isEqual:[UIImage imageNamed:@"like_inverse"]])
        {
            [sender setImage:[UIImage imageNamed:@"like_normal"]];
            [dele.selectedArray removeLastObject];
            
            NSLog(@"Rootcount = %d",(int)dele.selectedArray.count);
        }
        else
        {
            [sender setImage:[UIImage imageNamed:@"like_inverse"]];
            
            [dele.selectedArray addObject:model];
            for (StoryModel *m in dele.trendsArray)
            {
#warning ======
                if (![m.sID isEqualToString:model.ID])
                {
                    [dele.trendsArray addObject:model];
                    
                }
            }
            
            NSLog(@"Rootcount = %d",(int)dele.selectedArray.count);
            NSLog(@"trendsArray = %d",(int)dele.trendsArray.count);
        }
    }
}

- (void)addCommentBtn
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, 34)];
    [btn setImage:[UIImage imageNamed:@"details_btn_comment_normal"] forState:(UIControlStateNormal)];
    btn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
    [btn addTarget:self action:@selector(comment:) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:btn];
    
    [self.view addSubview:view];
}
#pragma mark 异步请求
- (void)sendRequest
{
    
    NSURL *url = [NSURL URLWithString:@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&id=10631&lat=22.534918&lon=113.944932&method=activity.detail&os=iphone&r=wanzhoumo&sign=bf7bfcdf832ca366131d47006ee84e11&timestamp=1411572187&top_session=7mkvml1tjegg0i700rph7vgeg0&v=2.0"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation start];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        
        NSDictionary *dic = dictionary[@"result"];
        
        DetailModel *model = [[DetailModel alloc]init];
        model.title = dic[@"title"];
        model.title_vice = dic[@"title_vice"];
        model.tel = dic[@"tel"];
        model.cost = dic[@"cost"];
        model.address = dic[@"address"];
        model.showTime = dic[@"time_txt"];
        [model.picShowArray addObjectsFromArray: dic[@"pic_show"]];
        model.introdution = dic[@"intro"];
        model.start_time_show = dic[@"start_time_show"];
        model.pic_show = dic[@"pic_show"];
        model.ID = dic[@"id"];
        model.position = dic[@"poi_name_app"];
        model.longitude = dic[@"lon"];
        model.latitude = dic[@"lat"];
    
        
        [_dataArray addObject:model];
        
        NSString *title = dictionary[@"result"][@"poi_all"][0][@"title"];
        [_topStoryArray addObject:title];
        NSLog(@"0000000%@",_topStoryArray[0]);
        NSString *cost = dictionary[@"result"][@"poi_all"][0][@"cost"];
        [_topStoryArray addObject:cost];
        NSString *address = dictionary[@"result"][@"poi_all"][0][@"address"];
        [_topStoryArray addObject:address];
        NSString *openTime= dictionary[@"result"][@"poi_all"][0][@"open_time"];
        [_topStoryArray addObject:openTime];
        NSString *lat = dictionary[@"result"][@"poi_all"][0][@"lat"];
        [_topStoryArray addObject:lat];
        NSString *lon = dictionary[@"result"][@"poi_all"][0][@"lon"];
        [_topStoryArray addObject:lon];
        
        [self addTableView1];
        [_tableView reloadData];
         [self addCommentBtn];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
    }];
    
    
}
- (void)comment:(UIButton*)btn
{
    CommentViewController *com = [[CommentViewController alloc]init];
    //com.model = _model;
    [self.navigationController pushViewController:com animated:YES];
}

- (void)addTableView1
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)style:(UITableViewStyleGrouped)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"TestCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
    [_tableView registerNib:[UINib nibWithNibName:@"DetCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    
    _tableView.tableHeaderView = [self customHeaderView1];
    _tableView.tableFooterView = [self customFooterView1];
}

- (void)initAll
{
    
    dele = [UIApplication sharedApplication].delegate;
    _data = [NSMutableData data];
    _dataArray = [NSMutableArray array];
    _topStoryArray = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
#pragma mark <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 3;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailModel *model = _dataArray[0];
    if (indexPath.section == 0)
    {
        DetCell*cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        [cell setModel:model];
        
        return cell;
    }
    else if(indexPath.section == 1)
    {
        NSArray *textArray = [NSArray arrayWithObjects:model.position,model.showTime,model.cost ,nil];
        NSArray *array = [NSArray arrayWithObjects:@"details_place",@"details_time",@"details_cost", nil];
        
        return [self tabelView:tableView ForindexPath:indexPath WithText:textArray[indexPath.row] WithImage:array[indexPath.row]];
        
    }
    else if(indexPath.section == 2)
    {
        TestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        NSString *string = [NSString stringWithFormat:@"%@",model.introdution];//,_model.information_show
        string = [string stringByReplacingOccurrencesOfString:@"<br/><\br>" withString:@""];
        [cell setHeight:string];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"Cell2"];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = [NSString stringWithFormat:@"对活动有疑问? 请拨打%@咨询",model.tel];
        cell.textLabel.textColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(telCall)];
        [cell addGestureRecognizer:tap];
        
        return cell;
    }
    
    
}

- (void)telCall
{
#pragma   mark 拨打电话
    DetailModel *model = _dataArray[0];
    NSString *phoneNum = model.tel;
    UIWebView *phoneCallWebView;
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    if ( !phoneCallWebView && ![phoneNum isEqualToString:@""]) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:phoneCallWebView];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailModel *model = _dataArray[0];
    if (indexPath.section == 0) {
        MapController *map = [[MapController alloc]init];
        map.model = model;
        [self.navigationController pushViewController:map animated:YES];
    }
    
    if (indexPath.section == 1 ) {
        if (indexPath.row == 0) {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
//            PoiViewController *pVc = [[PoiViewController alloc]init];
//            pVc.model = _model;
//            [self.navigationController pushViewController:pVc animated:YES];
        }
    }
    
}

- (UITableViewCell*)tabelView:(UITableView*)tableView ForindexPath:(NSIndexPath *)indexPath WithText:(NSString*)text WithImage:(NSString*)image
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%d",(int)indexPath.row]];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:[NSString stringWithFormat:@"%d",(int)indexPath.row]];
    }
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row != 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.imageView.image = [UIImage imageNamed:image];
    cell.textLabel.text = text;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
  
}



- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 3)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        
        UIImageView *replyView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 72)/2, 40, 72, 53)];
        replyView.image = [UIImage imageNamed:@"pic_empty_reply"];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60, replyView.frame.size.height + replyView.frame.origin.y + 40, self.view.frame.size.width - 120, 30)];
        label.text = @"还没有评论,你先来一条呗";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:160.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0];
        label.font = [UIFont systemFontOfSize:14];
        [view addSubview:replyView];
        [view addSubview:label];
        view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        
        return view;
    }
    if (section == 2) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
        label.text = @"活动详情";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor lightGrayColor];
        return label;
    }
    return nil;
}

- (UIView*)customFooterView1
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    UILabel *label = [[UILabel alloc]initWithFrame:view.frame];
    label.text = @"我要报错";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0];
    label.font = [UIFont systemFontOfSize:12];
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        return 200;
    }
    else if (section == 2)
        return 20;
    else
        return 1;
}


- (UIView*)customHeaderView1
{
    DetailModel *model = [_dataArray objectAtIndex:0];
    int count =(int)[ model.picShowArray count];
    
    headerView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 250)];
    _scrollView.contentSize = CGSizeMake((count - 1)*_scrollView.frame.size.width, 0);
    _scrollView.backgroundColor = [UIColor redColor];
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
   
   
        for (int i = 0; i < count - 1; i++)
        {
            UIImageView *imgView= [[UIImageView alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width * i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
            [imgView setImageWithURL:[NSURL URLWithString:model.picShowArray[i+1]] placeholderImage:[UIImage imageNamed:@"picture_default_350"]];
            
            [_scrollView addSubview:imgView];
        }

    
        [_tableView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(autoShow) userInfo:nil repeats:YES];
    
    pageView = [[UIView alloc]initWithFrame:CGRectMake(0, _scrollView.frame.size.height, self.view.frame.size.width, 44)];
    pageView.backgroundColor = [UIColor clearColor];
    [self addPageControl];
    
    
    UIImageView *praiseView = [[UIImageView alloc]initWithFrame:CGRectMake(230, (pageView.frame.size.height - 15)/2, 14, 15)];
    praiseView.image = [UIImage imageNamed:@"ico_like_normal_little"];
    UILabel *praiseLabel = [[UILabel alloc]initWithFrame:CGRectMake(praiseView.frame.origin.x + praiseView.frame.size.width + 3,0,80, pageView.frame.size.height)];
    praiseLabel.text = [NSString stringWithFormat:@"%d人收藏",(int)240];
    praiseLabel.textColor = [UIColor grayColor];
    praiseLabel.font = [UIFont systemFontOfSize:11];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 200, self.view.frame.size.width - 20, 30)];
    title.text = model.title;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:15];
    UILabel *subTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, title.frame.origin.y + title.frame.size.height - 10, self.view.frame.size.width, 30)];
    subTitle.text = model.title_vice;
    subTitle.textColor = [UIColor whiteColor];
    subTitle.font = [UIFont systemFontOfSize:13];
    
    [pageView addSubview:praiseLabel];
    [pageView addSubview:praiseView];
    [headerView addSubview:_scrollView];
    [headerView addSubview:pageView];
    [headerView addSubview:title];
    [headerView addSubview:subTitle];
    [pageView addSubview:praiseView];
    headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, _scrollView.frame.size.height + pageView.frame.size.height);
    return headerView;
   
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"chang=======%@",change);
    
}

- (void)addPageControl
{
    DetailModel *model = [_dataArray objectAtIndex:0];
    _pageCtl = [[UIPageControl alloc]initWithFrame:CGRectMake(20, (pageView.frame.size.height - 30)/2,60, 30)];
    _pageCtl.numberOfPages = model.picShowArray.count - 1;
    _pageCtl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"details_zero_inverse"]];
    _pageCtl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"details_zero_normal"]];
    [pageView addSubview:_pageCtl];
}

- (void)autoShow
{
    DetailModel *model = _dataArray[0];
    [_scrollView setContentOffset:(CGPoint){_scrollView.frame.size.width *page,0} animated:YES];
    _pageCtl.currentPage = page;
    page++;
    if ( page > model.picShowArray.count - 2) page = 0;
    
    NSLog(@"=============");
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageCtl.currentPage = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    
}




@end
