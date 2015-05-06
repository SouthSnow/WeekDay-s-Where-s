//
//  ViewController.m
//  测试tabbar
//
//  Created by pangfuli on 14/9/5.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "ViewController.h"
#import "RootViewController.h"
#import "SliderViewController.h"
#import "PPRevealSideViewController.h"
#import "TwoViewController.h"
#import "FiveController.h"
#import "CollectController.h"
#import "TrendsViewController.h"
//#import <Parse/Parse.h>

@interface ViewController ()
{
    AppDelegate *dele;
}
@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemAction) target:self action:@selector(slider)];
        
    }
    return self;
}

- (void)slider
{
    SliderViewController *slider = [[SliderViewController alloc]init];
    [self.revealSideViewController pushViewController:slider onDirection:(PPRevealSideDirectionLeft) animated:YES];
  
}

- (void)viewDidLoad
{
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    testObject[@"foo"] = @"bar";
//    [testObject saveInBackground];
    
    [super viewDidLoad];
    
    [self load];
}

- (void)load
{
    [self initControllers];
    dele = [UIApplication sharedApplication].delegate;
    
    _customView = [[UIView alloc]initWithFrame:(CGRect){0,self.view.frame.size.height - self.tabBar.frame.size.height,self.view.frame.size.width,self.tabBar.frame.size.height}];
    _customView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_customView];
    dele.customView = _customView;
    [self customTabBar];
}

- (void)customTabBar
{
    NSInteger height = 49;
    NSInteger width = self.view.frame.size.width/5;
    
    
    NSArray *nameText = [NSArray arrayWithObjects:@"本周活动",@"发现",@"收藏",@"动态",@"我的", nil];
    NSArray *normalArray = [NSArray arrayWithObjects:@"tab_activity_normal",@"tab_find_normal",@"tab_fav_inverse_normal",@"tab_trends_normal",@"tab_my_normal", nil];
    NSArray *selectArray = [NSArray arrayWithObjects:@"tab_activity_inverse",@"tab_find_inverse",@"tab_fav_inverse_inverse",@"tab_trends_inverse",@"tab_my_inverse", nil];
    for (int i = 0; i < 5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = (CGRect){width*i,0,width,height};
        [btn setTitle:nameText[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:9.5];
        [btn setImage:[UIImage imageNamed:selectArray[i]] forState:(UIControlStateSelected)];
        [btn setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:normalArray[i]] forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(30, -12, 0, 12)];
        [btn setImageEdgeInsets:(UIEdgeInsetsMake(5, 20, 20, 20))];
        
        btn.tag = i + 1;
        if (i == 0) {
            btn.selected = YES;
        }
        [btn addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_customView addSubview:btn];
    }
    
    
    
}

- (void)selectedBtn:(UIButton *)selectedBtn
{
    
    
    for (int i = 0; i < 5; i++) {
        UIButton *btn = (UIButton*)[self.view viewWithTag:i+1];
        if (btn.tag == selectedBtn.tag) {
            
            btn.selected = YES;
            
            self.selectedIndex = selectedBtn.tag - 1;
            
        }
        else
            btn.selected = NO;
        
    }
    
}

- (void)initControllers
{
    
    self.count = 0;
    
    RootViewController *oneVc = [[RootViewController alloc]init];
    TwoViewController *secondVc = [[TwoViewController alloc]init];
    CollectController *thirdVc = [[CollectController alloc]init];
    TrendsViewController *forthVc = [[TrendsViewController alloc]init];
    FiveController *fiveVc = [[FiveController alloc]init];
    
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:oneVc];
    nav1.navigationBar.translucent = NO;
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:secondVc];
    nav2.navigationBar.translucent = NO;
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:thirdVc];
    nav3.navigationBar.translucent = NO;
    UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:forthVc];
    nav4.navigationBar.translucent = NO;
    UINavigationController *nav5 = [[UINavigationController alloc]initWithRootViewController:fiveVc];
    nav5.navigationBar.translucent = NO;
     self.viewControllers = [NSArray arrayWithObjects:nav1,nav2,nav3,nav4,nav5, nil];

    self.tabBar.hidden = YES;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
