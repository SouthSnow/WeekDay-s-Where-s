//
//  ShowImageController.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/7.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "ShowImageController.h"
#import "UIImageView+WebCache.h"

@interface ShowImageController ()<UIScrollViewDelegate>
{
    UIPageControl *pageCtl;
}
@end

@implementation ShowImageController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _showArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self myTap];
    
}
- (void)myTap
{
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    [UIView animateWithDuration:0.5 animations:^{
        scrollView.frame = self.view.frame;
    }];
    
    [self.view addSubview:scrollView];
    scrollView.pagingEnabled = YES;
    
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(self.showArray.count * self.view.frame.size.width, 0);
    for (int i = 0; i < self.showArray.count; i++)
    {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(scrollView.frame.size.width * i, 64, scrollView.frame.size.width, scrollView.frame.size.height - 104)];
        [imgView setImageWithURL:[NSURL URLWithString:self.showArray[i]] placeholderImage:nil];
       
        [scrollView addSubview:imgView];
    }
    
    pageCtl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 60 , self.view.frame.size.width, 0)];
    [self.view addSubview:pageCtl];
    pageCtl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"details_zero_inverse"]];
    pageCtl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"details_zero_normal"]];
    pageCtl.numberOfPages = self.showArray.count;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageCtl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
  
}



@end
