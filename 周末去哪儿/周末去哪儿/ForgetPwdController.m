//
//  ForgetPwdController.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/9.
//  Copyright (c) 2014年 pfl. All rights reserved.
//
#import "LoginPhoneCell.h"
#import "ForgetPwdController.h"

@interface ForgetPwdController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ForgetPwdController

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
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView *myTable = [[UITableView alloc]initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    myTable.delegate = self;
    myTable.dataSource = self;
    [self.view addSubview:myTable];
    [myTable registerNib:[UINib nibWithNibName:@"LoginPhoneCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

#pragma  mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoginPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textField.placeholder = @"手机号码";
    cell.imageView.image = [UIImage imageNamed:@"ico_field_phonenumber"];
    cell.textField.tag = 100;
//    cell.textField.delegate = self;
    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"输入你注册时填写的手机号码以重置密码";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

@end













