//
//  SearchResultController.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/5.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "SearchResultController.h"

@interface SearchResultController ()

@end

@implementation SearchResultController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemReply) target:self action:@selector(back)];
    }
    return self;
}

- (void)back
{
    self.navigationController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * .85, [UIScreen mainScreen].bounds.size.height);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
    [self.view addGestureRecognizer:tap];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end














