//
//  TwoViewController.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/2.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "TwoViewController.h"

#import "AFHTTPRequestOperation.h"
#import "StoryModel.h"
#import "TwoDetailController.h"
#import "TwoCell.h"

@interface TwoViewController ()<UITableViewDataSource,UITableViewDelegate>
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
    AppDelegate *dele;
    UIView *_view;
    UIView *view;
    UILabel *label;
    UILabel *label2;
    UIActivityIndicatorView *_act;
    NSCache *imageCache;
}
@end

@implementation TwoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initAll];
        self.navigationController.navigationBar.translucent = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageCache = [[NSCache alloc]init];
    self.title = @"发现";
    [self addTableView];
    [self sendRequest];
    [self dragRefresh];
  
    
}

- (void)viewWillAppear:(BOOL)animated
{
    dele.customView.hidden = NO;
}

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
        
        
        [UIView animateWithDuration:.5 animations:^{
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
    
    
    
        [self performSelector:@selector(sendRequest) withObject:nil afterDelay:5];
  
   
    
    [_act stopAnimating];
}



- (void)sendRequest
{
    
    NSURL *url = [NSURL URLWithString:@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&lat=22.562437&lon=113.904369&method=topic.list&os=iphone&pagesize=20&r=wanzhoumo&sign=70d327f6894e948f046e7c45cff935f9&timestamp=1409673032&top_session=u96eu235ali11gaf2u3g9csh32&v=2.0"];
   NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation start];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];

        for (NSDictionary *dic in dictionary[@"result"][@"list"])
        {
            StoryModel *model = [[StoryModel alloc]init];
            model.title = dic[@"title"];
            [model.picShowArray addObject: dic[@"pic_show"]];
            model.introdution = dic[@"intro"];
            model.start_time_show = dic[@"start_time_show"];
            model.pic_show = dic[@"pic_show"];
            model.sID = dic[@"id"];
            
            [_dataArray addObject:model];
        }
        
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
    }];
    
    
}

#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = _dataArray[indexPath.row];
    
    __block UIImage *thumbImage = [imageCache objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    cell.showImage.image = thumbImage;
    if (!thumbImage) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage *iamge = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:cell.model.picShowArray[0]]]]?:[UIImage imageNamed:@"picture_default_350"];
            UIGraphicsBeginImageContextWithOptions(cell.showImage.bounds.size, YES, [UIScreen mainScreen].scale);
            [iamge drawInRect:cell.showImage.bounds];
            thumbImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.showImage.image = thumbImage;
                [imageCache setObject:thumbImage forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
                
            });
        });
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TwoDetailController *detail = [[TwoDetailController alloc]init];
    [self.navigationController pushViewController:detail animated:YES];
    detail.model = _dataArray[indexPath.row];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
}

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

- (void)addTableView
{
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    label2 = [[UILabel alloc]initWithFrame:CGRectMake(270, 0, 50, 30)];
    [view addSubview:label];
    [view addSubview:label2];
    view.backgroundColor = [UIColor redColor];
    //[self.view addSubview:view];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,320,self.view.frame.size.height-30)];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"TwoCell" bundle:nil] forCellReuseIdentifier:@"cell"];
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












