//
//  SettingController.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/8.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "SettingController.h"
#import "ReommendController.h"
#import "FeedBackController.h"
#import "AboatController.h"
#import "ShowAgreementController.h"


@interface SettingController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    AppDelegate *dele;
    UIButton *logout;
}
@end

@implementation SettingController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"设置";
        dele = [UIApplication sharedApplication].delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    dele.customView.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addTableView];
    
    int triangularNumber,n = 0;
    triangularNumber = 0;
    NSLog(@"tTABLE OF TRIANGULAR NUMBER");
    NSLog(@"n sum from 1 to n");
    NSLog(@"-----  ----------");
    
    
    while (n <= 200) {
        
        triangularNumber +=  n;
        
        NSLog(@"%3i     %i!",  n    ,triangularNumber);
        ++n ;
    }


}

- (void)viewDidAppear:(BOOL)animated
{
    if (![dele.loginStatus isEqualToString:@"success"])
    {
        _tableView.tableFooterView = nil;
    }
}

- (void)addTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height) style:(UITableViewStyleGrouped)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    _tableView.tableFooterView = [self customFooterView];
 
}

#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 1;
    else if (section == 1)
        return 3;
    else
        return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        cell.textLabel.text = @"清除搜索记录";
        cell.imageView.image = [UIImage imageNamed:@"ico_setting_trash"];
        
    }
    else if (indexPath.section == 1)
    {
        NSArray *title = [NSArray arrayWithObjects:@"我有线报",@"意见反馈",@"评价我们", nil];
        NSArray *img = [NSArray arrayWithObjects:@"ico_setting_source",@"ico_setting_feedback",@"ico_setting_like", nil];
        cell.textLabel.text = title[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:img[indexPath.row]];
        
    }
    else
    {
        NSArray *title = [NSArray arrayWithObjects:@"关于我们",@"用户协议",nil];
        NSArray *img = [NSArray arrayWithObjects:@"ico_setting_about",@"ico_setting_agreement", nil];
        cell.textLabel.text = title[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:img[indexPath.row]];
        
    }
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"常规";
    }
    else if (section == 1)
        return @"支持我们";
    else
        return @"关于";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CategoryActivity *act = [CategoryActivity shareCategory];
        [act.searchArray removeAllObjects];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"清除成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
     else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            ReommendController *rec = [[ReommendController alloc]init];
            [self.navigationController pushViewController:rec animated:YES];
        }
        else if (indexPath.row == 1)
        {
            FeedBackController *feed = [[FeedBackController alloc]init];
            
            [self.navigationController pushViewController:feed animated:YES];
        }
        else
        {
           
            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/zhou-mo-qu-na-er-tong-cheng/id820846113?mt=8"];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    else
    {
        if (indexPath.row == 0) {
            AboatController *aboat = [[AboatController alloc]init];
            [self.navigationController pushViewController:aboat animated:NO];
        }
        else
        {
            ShowAgreementController *agree = [[ShowAgreementController alloc]init];
            [self.navigationController pushViewController:agree animated:YES];
        }
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 20;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 30;
    }
    return 40;
}

- (UIView*)customFooterView
{
    if ([dele.loginStatus isEqualToString:@"success"])
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 88)];
            logout = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
            [logout setTitle:@"退出" forState:(UIControlStateNormal)];
            [logout setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            logout.backgroundColor = [UIColor redColor];
            [logout addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:logout];
//        view.backgroundColor = [UIColor greenColor];
            return view;
    }
    return nil;
}

- (void)logOut
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认退出?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];

}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        dele.loginStatus = @"failed";
        [logout removeFromSuperview];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *loginStatus = dele.loginStatus;
        [defaults setObject:loginStatus forKey:@"loginStatus"];
        [defaults synchronize];
        
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end







