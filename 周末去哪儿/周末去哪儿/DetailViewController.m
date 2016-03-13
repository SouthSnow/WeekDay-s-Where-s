//
//  DetailViewController.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/2.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"
#import "DetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "CommentViewController.h"
#import "DetTableViewCell.h"
#import <MapKit/MapKit.h>
#import "AFHTTPRequestOperation.h"
#import "DetailModel.h"
#import "DetailCell2.h"
#import "PoiViewController.h"
#import "MapViewController.h"
#import "TelCell.h"
#import "TestCell.h"


@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate,UIScrollViewDelegate>
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
    DetailTableViewCell *_cell;
    int page;
    UIView *footerView;
    UIView *headerView;
    UIView *pageView;
    AppDelegate *dele;
    UIImageView *_imgView;
    UIView *contentView;
    UIBarButtonItem *shareBar;
    UIBarButtonItem *favBar;
    NSCache *imageCache;
}
@property (nonatomic, strong) MapViewController *mapController;
@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initAll];
       shareBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"details_top_blue_share_normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(share)];
       favBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"details_top_blue_like_normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(fav:)];
        self.navigationItem.rightBarButtonItems = @[favBar,shareBar];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"details_top_blue_back_normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
        shareBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"details_top_blue_share_normal"]];
        favBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"details_top_blue_like_normal"]];
       
    }
    return self;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setModel:(StoryModel *)model
{
    _model = model;
    [_tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageCache = [[NSCache alloc]init];
    dele.customView.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addTableView];
    [self sendRequest];
    [self addCommentBtn];
    
}

- (void)viewWillAppear:(BOOL)animated
{

    [_timer setFireDate:[NSDate distantPast]];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)share
{
    
    
//    if ([dele.loginStatus isEqual:@"success"])
//    {
//        
//        id<ISSContent>publishContent = [ShareSDK content:[NSString stringWithFormat:@"#周末去哪儿#%@「%@」http://t.cn/RhMv9x0 @周末去哪儿APP",[_model.introdution substringToIndex:40],_model.title]
//                                          defaultContent:@""
//                                                   image:[ShareSDK imageWithPath:[[NSBundle mainBundle] pathForResource:@"mm.pag" ofType:nil]]
//                                                   title:@"ShareSDK" url:@"https://api.weibo.com/oauth2/default.html"
//                                             description:@"这是一条测试信息"
//                                               mediaType:(SSPublishContentMediaTypeNews)];
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
            
            [dele.selectedArray addObject:_model];
            for (StoryModel *m in dele.trendsArray)
            {
                if (![m.sID isEqualToString:_model.sID])
                {
                    [dele.trendsArray addObject:_model];
                 
                }
            }

        }
    }
}

- (void)addCommentBtn
{
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 40)];
    contentView.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, 34)];
    [btn setImage:[UIImage imageNamed:@"details_btn_comment_normal"] forState:(UIControlStateNormal)];
    btn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
    [btn addTarget:self action:@selector(comment:) forControlEvents:(UIControlEventTouchUpInside)];
    [contentView addSubview:btn];

    [self.view addSubview:contentView];
}

- (void)sendRequest
{
    
    NSURL *url = [NSURL URLWithString:@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&id=11512&lat=22.534790&lon=113.944979&method=activity.detail&os=iphone&r=wanzhoumo&sign=6ce92ddda9ac5f744fe46f42e33f7f84&timestamp=1409816693&top_session=pqr2e1q3skdqiinui7vddbvbn5&v=2.0"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation start];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        
        NSDictionary *dic = dictionary[@"result"];
        
            DetailModel *model = [[DetailModel alloc]init];
            model.title = dic[@"title"];
            model.tel = dic[@"tel"];
            model.cost = dic[@"cost"];
            model.address = dic[@"address"];
            model.showTime = dic[@"time_txt"];
            [model.picShowArray addObject: dic[@"pic_show"]];
            model.introdution = dic[@"intro"];
            model.start_time_show = dic[@"start_time_show"];
            model.pic_show = dic[@"pic_show"];
            model.ID = dic[@"id"];
            
            [_dataArray addObject:model];
        
        NSString *title = dictionary[@"result"][@"poi_all"][0][@"title"]?:@"";
        [_topStoryArray addObject:title];
        NSLog(@"0000000%@",_topStoryArray[0]);
        NSString *cost = dictionary[@"result"][@"poi_all"][0][@"cost"]?:@"";
        [_topStoryArray addObject:cost];
        NSString *address = dictionary[@"result"][@"poi_all"][0][@"address"]?:@"";
        [_topStoryArray addObject:address];
        NSString *openTime= dictionary[@"result"][@"poi_all"][0][@"open_time"]?:@"";
        [_topStoryArray addObject:openTime];
        NSString *lat = dictionary[@"result"][@"poi_all"][0][@"lat"]?:@"";
        [_topStoryArray addObject:lat];
        NSString *lon = dictionary[@"result"][@"poi_all"][0][@"lon"]?:@"";
        [_topStoryArray addObject:lon];
        
        
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
    }];
    
    
}
- (void)comment:(UIButton*)btn
{
    CommentViewController *com = [[CommentViewController alloc]init];
    com.model = _model;
    [self.navigationController pushViewController:com animated:YES];
}

- (void)addTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)style:(UITableViewStyleGrouped)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerNib:[UINib nibWithNibName:@"DetailCell2" bundle:nil] forCellReuseIdentifier:@"cell2"];
    [_tableView registerNib:[UINib nibWithNibName:@"DetTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [_tableView registerNib:[UINib nibWithNibName:@"TelCell" bundle:nil] forCellReuseIdentifier:@"cell3"];
    
    _tableView.tableHeaderView = [self customHeaderView];
    _tableView.tableFooterView = [self customFooterView];
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
    if (indexPath.section == 0)
    {
        DetTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        [cell setModel:_model];
        
        return cell;
    }
    else if(indexPath.section == 1)
    {
        NSArray *textArray = [NSArray arrayWithObjects:_model.position,_model.showTime,_model.cost ,nil];
        NSArray *array = [NSArray arrayWithObjects:@"details_place",@"details_time",@"details_cost", nil];
       
        return [self tabelView:tableView ForindexPath:indexPath WithText:textArray[indexPath.row] WithImage:array[indexPath.row]];
       
    }
    else if(indexPath.section == 2)
    {
        DetailCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
//        cell.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        NSString *string = [NSString stringWithFormat:@"%@",_model.introdution];//,_model.information_show
//        string = [string stringByReplacingOccurrencesOfString:@"<br/><\br>" withString:@""];
        [cell setHeight:string];//@"回来卡上的房间里是京东方可接受的覅苏放假了可接受的覅U树人据了解撒地方来看角色日萨芬金额为是否可骄傲是浪费回来卡上的房间里是京东方可接受的覅苏放假了可接受的覅U树人据了解撒地方来看角色日萨芬金额为是否可骄傲是浪费回来卡上的房间里是京东方可接受的覅苏放假了可接受的覅U树人据了解撒地方来看角色日萨芬金额为是否可骄傲是浪费回来卡上的房间里是京东方可接受的覅苏放假了可接受的覅U树人据了解撒地方来看角色日萨芬金额为是否可骄傲是浪费回来卡上的房间里是京东方可接受的覅苏放假了可接受的覅U树人据了解撒地方来看角色日萨芬金额为是否可骄傲是浪费回来卡上的房间里是京东方可接受的覅苏放假了可接受的覅U树人据了解撒地方来看角色日萨芬金额为是否可骄傲是浪费"];
//        cell.detailString = string;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        
        TelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        cell.tel.text = _model.tel;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(telCall)];
        cell.tel.userInteractionEnabled = YES;
        [cell.tel addGestureRecognizer:tap];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
   
}

- (void)telCall
{
#pragma   mark 拨打电话
   
        NSString *phoneNum = _model.tel;
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
    if (indexPath.section == 0) {
        MapViewController *map = [[MapViewController alloc]init];
        map.model = _model;
        [self.navigationController pushViewController:map animated:YES];
    }
    
    if (indexPath.section == 1 ) {
        if (indexPath.row == 0) {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            PoiViewController *pVc = [[PoiViewController alloc]init];
            pVc.model = _model;
            [self.navigationController pushViewController:pVc animated:YES];
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
    
//    if (indexPath.section == 2) {
////
////        
//        DetailCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
//        
//        NSString *string = [NSString stringWithFormat:@"%@",_model.introdution];//,_model.information_show
//        cell.detailString = [string stringByReplacingOccurrencesOfString:@"<br/><\br>" withString:@""];
//        [cell setHeight:string];
//        return cell.cellHeight;
////
//    }
    
    CGFloat height = [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
//    NSLog(@"height = %f",height);
    return height;
  
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

- (UIView*)customFooterView
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


- (UIView*)customHeaderView
{
    headerView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 215)];
    _scrollView.contentSize = CGSizeMake((_model.picShowArray.count-1)*_scrollView.frame.size.width, 0);
    _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"picture_default_350"]];
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
   
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (int i = 0; i < _model.picShowArray.count - 1; i++)
        {
           UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width * i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
            //        [imgView setImageWithURL:[NSURL URLWithString:_model.picShowArray[i+1]] placeholderImage:[UIImage imageNamed:@"picture_default_350"]];
             [_scrollView addSubview:imgView];
            __block UIImage *thumbImage = [imageCache objectForKey:[NSString stringWithFormat:@"%d",i+1]];
            if (thumbImage) {
                imgView.image = thumbImage;
            }
            
            if (!thumbImage) {

                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_model.picShowArray[i+1]]]]?:[UIImage imageNamed:@"picture_default_350"];
                float scale = [UIScreen mainScreen].scale;
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(imgView.bounds.size.width, 215), YES, scale);
                [image drawInRect:CGRectMake(0, 0, self.view.bounds.size.width, 215)];
                thumbImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                dispatch_async(dispatch_get_main_queue(), ^{
                    imgView.image = thumbImage;
                    [imageCache setObject:thumbImage forKey:[NSString stringWithFormat:@"%d",i+1]];
                });

            }
            
           
        }

    });
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(autoShow) userInfo:nil repeats:YES];
    
    pageView = [[UIView alloc]initWithFrame:CGRectMake(0, _scrollView.frame.size.height, self.view.frame.size.width, 44)];
    pageView.backgroundColor = [UIColor clearColor];
    [self addPageControl];
    

    UIImageView *praiseView = [[UIImageView alloc]initWithFrame:CGRectMake(230, (pageView.frame.size.height - 15)/2, 14, 15)];
    praiseView.image = [UIImage imageNamed:@"ico_like_normal_little"];
    
    UILabel *praiseLabel = [[UILabel alloc]initWithFrame:CGRectMake(praiseView.frame.origin.x + praiseView.frame.size.width + 3,0,80, pageView.frame.size.height)];
    praiseLabel.text = [NSString stringWithFormat:@"%@人收藏",_model.follow_num];
    praiseLabel.textColor = [UIColor grayColor];
    praiseLabel.font = [UIFont systemFontOfSize:11];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 190, self.view.frame.size.width - 20, 30)];
    title.text = _model.title;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:15];
    UILabel *subTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, title.frame.origin.y + title.frame.size.height + 10, self.view.frame.size.width, 30)];
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





- (void)addPageControl
{
    _pageCtl = [[UIPageControl alloc]initWithFrame:CGRectMake(20, (pageView.frame.size.height - 30)/2,60, 30)];
    _pageCtl.numberOfPages = _model.picShowArray.count - 1;
    _pageCtl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"details_zero_inverse"]];
    _pageCtl.hidesForSinglePage = YES;
    _pageCtl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"details_zero_normal"]];
    [pageView addSubview:_pageCtl];
}
- (void)autoShow
{
    [_scrollView setContentOffset:(CGPoint){_scrollView.frame.size.width *page,0} animated:YES];
    _pageCtl.currentPage = page;
    page++;
    if ( page > _model.picShowArray.count - 2) page = 0;
}

#if 0
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.navigationController.navigationBar.translucent = YES;
    
    contentView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 40, [UIScreen mainScreen].bounds.size.width, 40);
    
    if (scrollView.contentOffset.y <= 0)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
        shareBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"details_top_white_share_normal"]];
        favBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"details_top_white_like_normal"]];
        // 这样设置颜色会是蓝色
        //self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"2"] forBarMetrics:UIBarMetricsDefault];
        self.title = @"";
        NSLog(@"====1==%f",scrollView.contentOffset.y);
        
    }
    
    else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:(UIBarMetricsDefault)];
        
        //更改透明度
        self.navigationController.navigationBar.layer.opacity = abs(scrollView.contentOffset.y)/64.0;
     
        
        contentView.frame = CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40);
        
        self.title = _model.position;
        
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"details_top_blue_back_normal"]];
      
        
        shareBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"details_top_blue_share_normal"]];
        favBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"details_top_blue_like_normal"]];
    }
    
}



#endif



@end






















