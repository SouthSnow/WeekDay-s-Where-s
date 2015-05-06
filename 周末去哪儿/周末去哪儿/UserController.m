//
//  UserController.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/9.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "UserController.h"
#import "SettingController.h"
#import "ComtentCell.h"
#import "ActCell.h"

@interface UserController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@end

@implementation UserController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ico_set"] style:(UIBarButtonItemStyleDone) target:self action:@selector(set)];
    }
    return self;
}
- (void)set
{
    SettingController *set = [[SettingController alloc]init];
    [self.navigationController pushViewController:set animated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addTableView];

    
    
}
- (void)addTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView  = [self customHeaderView];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
   [_tableView registerNib:[UINib nibWithNibName:@"ActCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
//    [_tableView registerNib:[UINib nibWithNibName:@"LoginPhoneCell" bundle:nil] forCellReuseIdentifier:@"cell3" ];

}

#pragma mark UITableViewDataSource,UITableViewDelegate



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.userDataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
    cell.userData = _userDataArray[0];
    return cell;
}

- (UIView*)customHeaderView
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 175 + 40)];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, view.frame.size.height - 40)];
    imgView.image = [UIImage imageNamed:@"default_user_cover"];
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(20,135, 60, 60)];
    icon.image = [UIImage imageNamed:@"avatardefault"];
    UILabel *nick = [[UILabel alloc]initWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width + 10, 135, 100, 30)];
    UserData *user = _userDataArray[0];
    nick.font = [UIFont systemFontOfSize:12];
    nick.textColor = [UIColor whiteColor];
    nick.text = user.userNick;
    
    UILabel *atten = [[UILabel alloc]initWithFrame:CGRectMake(nick.frame.origin.x + 10, imgView.frame.origin.y + imgView.frame.size.height + 10, 60, nick.frame.size.height)];
    atten.text = [NSString stringWithFormat:@"%d关注",user.userActivity.intValue];
    atten.font = [UIFont systemFontOfSize:12];
    UILabel *fan = [[UILabel alloc]initWithFrame:CGRectMake(atten.frame.size.width + atten.frame.origin.x + 20, imgView.frame.origin.y + imgView.frame.size.height + 10, 60, nick.frame.size.height)];
    fan.text = [NSString stringWithFormat:@"%d粉丝",user.userFollower.intValue];
    fan.font = [UIFont systemFontOfSize:12];
    
    UILabel *edit = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 70, imgView.frame.size.height - 25, 60, 20)];
    edit.text = @"编辑资料";
    edit.textAlignment = NSTextAlignmentCenter;
    edit.font = [UIFont systemFontOfSize:12];
    edit.textColor = [UIColor whiteColor];
    edit.backgroundColor = [UIColor colorWithWhite:.4 alpha:0.6];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(edit:)];
    [edit addGestureRecognizer:tap];
    
    [view addSubview:imgView];
    [view addSubview:icon];
    [view addSubview:nick];
    [view addSubview:atten];
    [view addSubview:fan];
    [view addSubview:edit];

    
    
    return view;
}


- (void)edit:(UITapGestureRecognizer*)tap
{
 
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UserData *data = _userDataArray[0];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        NSString *com = [NSString stringWithFormat:@"评论(%d)",data.userComment.intValue];
        NSString *poi = [NSString stringWithFormat:@"地点(%d)",data.userpoi.intValue];
        UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:@[com,poi]];
        segment.frame = CGRectMake(15, 5, self.view.frame.size.width - 30, 30);
        [view addSubview:segment];
        return view;
    }
    return nil;
  
}


- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectZero];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 135)/2, 10, 135, 9)];
    imgView.image = [UIImage imageNamed:@"end"];
    [footerView addSubview:imgView];
    footerView.frame = CGRectMake(0, 0, self.view.frame.size.width, imgView.frame.size.height);
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height + 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end








