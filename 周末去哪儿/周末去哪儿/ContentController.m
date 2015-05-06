//
//  ContentController.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/6.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "ContentController.h"
#import "User.h"
#import "ComtentCell.h"
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
#import "TableViewCell.h"
#import "ShowImageCell.h"
#import "User.h"
#import "ComtentCell.h"
#import "ContentController.h"
#import "ActCell.h"

@interface ContentController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
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
}
@end

@implementation ContentController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    [self addTableView];
    [self addCommentBtn];
}

- (void)setContentArray:(NSArray *)contentArray
{
    _contentArray = contentArray;
}

- (void)addCommentBtn
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, 34)];
    [btn setImage:[UIImage imageNamed:@"details_btn_comment_normal"] forState:(UIControlStateNormal)];
    btn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
    [btn addTarget:self action:@selector(comment:) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:btn];
    
    [self.view addSubview:view];
}

- (void)comment:(UIButton*)btn
{
    CommentViewController *com = [[CommentViewController alloc]init];
    [self.navigationController pushViewController:com animated:YES];
}

- (void)addTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,320, 480)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"ComtentCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (void)initAll
{
    
    _dataArray = [NSMutableArray array];
    _topStoryArray = [NSMutableArray array];
   
}

#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contentArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComtentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.user = _contentArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    footerView = [[UIView alloc]initWithFrame:CGRectZero];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 135)/2, 0, 135, 9)];
    imgView.image = [UIImage imageNamed:@"end"];
    [footerView addSubview:imgView];
    footerView.frame = CGRectMake(0, 0, self.view.frame.size.width, imgView.frame.size.height);
    return footerView;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end















