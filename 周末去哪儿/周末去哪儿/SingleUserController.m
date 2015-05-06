//
//  SingleUserController.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/6.
//  Copyright (c) 2014年 pfl. All rights reserved.
//
#import "SingleUserController.h"
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

@interface SingleUserController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
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
    CategoryActivity *activity;
}
@end

@implementation SingleUserController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initAll];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    [self addTableView];
    [self addReply];
}

- (void)addReply
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    UITextField *reply = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, 34)];
    reply.placeholder = @"写回复...";
    reply.borderStyle = UITextBorderStyleLine;
  
  
    [view addSubview:reply];
    
    [self.view addSubview:view];
}



- (void)setContentArray:(NSArray *)contentArray
{
    _contentArray = contentArray;
}

- (void)addTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,320, 480)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"ActCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (void)initAll
{
    activity = [CategoryActivity shareCategory];
    _dataArray = [NSMutableArray array];
    _topStoryArray = [NSMutableArray array];
    
}

#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.user = _contentArray[0];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView animateWithDuration:.5 animations:^{
         [self.navigationController popViewControllerAnimated:YES];
    }];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



