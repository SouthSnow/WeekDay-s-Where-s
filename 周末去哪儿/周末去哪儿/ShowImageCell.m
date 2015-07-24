//
//  ShowImageCell.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/6.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "ShowImageCell.h"
#import "Annotation.h"
#import <MapKit/MapKit.h>
#import "DetailModel.h"
#import "UIImageView+WebCache.h"

@implementation ShowImageCell
{
    
    NSMutableArray *tempArray;
    UIPageControl *pageCtl;
    UIView *_view;
    UIViewController *show;
    CGRect rect;
    
}

- (void)setArray:(NSMutableArray *)array
{
    
    
    tempArray = [NSMutableArray arrayWithArray:array];
    _array = [NSMutableArray arrayWithArray:array];
    int count = (int)_array.count;
    if ( count < 5)
    {
        for (int i = 0; i < 5 - count; i++)
        {
            [_array addObject:@"pic_default"];
        }
        
    }
    
//    [img1 setImageWithURL:[NSURL URLWithString:_array[0]] placeholderImage:[UIImage imageNamed:@"pic_default"]];
//    [img2 setImageWithURL:[NSURL URLWithString:_array[1]] placeholderImage:[UIImage imageNamed:@"pic_default"]];
//    [img3 setImageWithURL:[NSURL URLWithString:_array[2]] placeholderImage:[UIImage imageNamed:@"pic_default"]];
//    [img4 setImageWithURL:[NSURL URLWithString:_array[3]] placeholderImage:[UIImage imageNamed:@"pic_default"]];
//    [img5 setImageWithURL:[NSURL URLWithString:_array[4]] placeholderImage:[UIImage imageNamed:@"pic_default"]];
   

}

- (void)awakeFromNib
{
   
    _view = [[UIView alloc]initWithFrame:self.frame];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myTap:)];
//    self.userInteractionEnabled = YES;
//    [self addGestureRecognizer:tap];
    
}

- (void)myTap:(UITapGestureRecognizer*)tap
{
    UIWindow *w = [UIApplication sharedApplication].keyWindow;
    show = [[UIViewController alloc]init];
    show.view.frame = w.frame;
   // w.rootViewController = show;
    rect = [self convertRect:self.frame toView:w];
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    [UIView animateWithDuration:0.5 animations:^{
        scrollView.frame = w.frame;
    }];
    
    [w addSubview:scrollView];
    scrollView.pagingEnabled = YES;
    
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(tempArray.count, 0);
    for (int i = 0; i < tempArray.count; i++)
    {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(scrollView.frame.size.width * i, 64, scrollView.frame.size.width, scrollView.frame.size.height - 104)];
        [imgView setImageWithURL:[NSURL URLWithString:tempArray[i]] placeholderImage:nil];
        UITapGestureRecognizer *newTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resize:)];
        [scrollView addGestureRecognizer:newTap];
        [scrollView addSubview:imgView];
    }
    
   
    
    pageCtl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, scrollView.frame.size.height - 60 , scrollView.frame.size.width, 60)];
    [w addSubview:pageCtl];
    pageCtl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"details_zero_inverse"]];
    pageCtl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"details_zero_normal"]];
    pageCtl.numberOfPages = tempArray.count;
    
}

- (void)resize:(UITapGestureRecognizer*)tap
{
    
    [UIView animateWithDuration:0.5 animations:^{
        tap.view.frame = rect;
    }completion:^(BOOL finished) {
        
        [pageCtl removeFromSuperview];
        [tap.view removeFromSuperview];
    }];
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageCtl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
