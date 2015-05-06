//
//  SearchController.m
//  周末去哪儿
//
//  Created by pangfuli on 14-10-2.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "SearchController.h"
#import "LeftViewController.h"



@interface SearchController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    CategoryActivity *activity;
    NSArray *title;
}
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UIView *searView;
@property (strong, nonatomic) UISearchDisplayController *displayController;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *title;



@end

@implementation SearchController

- (void)viewDidLoad
{
    [super viewDidLoad];
    activity = [CategoryActivity shareCategory];
    title = [NSArray arrayWithObjects:@"全部活动",@"热门",@"周边游",@"田园",@"展览",@"音乐",@"戏剧",@"聚会",@"亲子",@"约会",@"文艺",@"赏秋", nil];
    
    [self addTableView];
    [self addSearchBar];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    _searchBar.showsCancelButton = YES;
}


- (void)addSearchBar
{
    
    _searchBar = [[UISearchBar alloc]initWithFrame:(CGRect){0,20,self.view.bounds.size.width,24}];
    _searchBar.placeholder = @"搜索活动或地点";
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [_searchBar setShowsCancelButton:YES animated:YES];
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _searchBar.delegate = self;
    
    _searchBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
    
    
    
    _displayController = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    _displayController.searchResultsDelegate = self;
    _displayController.searchResultsDataSource = self;
    
    
    
    
    _searView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    _searView.backgroundColor = [UIColor whiteColor];
    _searView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [_searView addSubview:_searchBar];
    [self.view addSubview:_searView];
    
}

- (void)addTableView
{
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor redColor];
    
}

#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return activity.searchArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = activity.searchArray[indexPath.row];
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
#pragma mark  UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    
    for (NSString *string in title)
    {
      
        if ([searchText rangeOfString:string].location != NSNotFound || [string rangeOfString:searchText].location != NSNotFound)
        {
            [activity.searchArray addObject:searchText];
            
        }
    }
    [_tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
   
    
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
   
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    [self dismiss];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (activity.searchArray.count == 0 || [_searchBar resignFirstResponder])
    {
        [self dismiss];
    }
}

- (void)dismiss
{
  
    [_searchBar resignFirstResponder];
    [self.view.window sendSubviewToBack:self.view];
    self.view.hidden = YES;
    if ([_delegate respondsToSelector:@selector(changeFrame)] && _delegate) {
        [_delegate changeFrame];
    }
#if 0
    [self dismissViewControllerAnimated:NO completion:^{
        if ([_delegate respondsToSelector:@selector(changeFrame)] && _delegate) {
            [_delegate changeFrame];
        }
    }];
#endif
}


@end








