//
//  RegisterController.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/9.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "RegisterController.h"
#import "LoginPhoneCell.h"
#import "ShowAgreementController.h"
#import "AFHTTPRequestOperation.h"

@interface RegisterController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    NSArray *img;
    NSArray *title;
    UIButton *agreeBtn;
    NSString *telephoneNum;
    NSString *passWord;
    NSString *confirm;
    
}
@end

@implementation RegisterController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:(UIBarButtonItemStyleDone) target:self action:@selector(next)];
        self.title = @"注册";
    }
    return self;
}

- (void)next
{
    for (UITextField *textField in _tableView.subviews) {
        [textField resignFirstResponder];
    }
    if ([passWord isEqualToString:confirm]) {
       
        if (passWord.length < 6) {
            NSLog(@"密码过于简单,请重新设置...");
        }
        else
            [self sendRequest];
    }
    else
    {
        NSLog(@"密码和电话有误,请重新输入...");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    telephoneNum = nil;
    passWord = nil;
    confirm = nil;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addTableView];
    
   
    //http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&leave_time=1410251779499&method=system.record&os=iphone&r=wanzhoumo&sign=03d7bed138bf2bb9323f2b39e9d1b3ba&timestamp=1410251780&top_session=bgt9m33bnhlq89nua1pb2vkvu6&v=2.0&visit_page=ZWUserViewController&visit_param=%7B%0A%20%20%22user_id%22%20%3A%20%22403461%22%0A%7D&visit_time=0
}
- (void)sendRequest
{
    NSString *stringUrl = [NSString stringWithFormat:@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&method=user.selfReg&mobile=%@&os=iphone&passwd=%@&phone_type=iphone&phone_uuid=97B42FCB-7D7A-4D41-A80B-24644CBEE429&r=wanzhoumo&sign=3f2f7e053527877a9d4fa45e3ab167d4&timestamp=1410248067&v=2.0",@"18938935872",@"123456"];
    NSLog(@"telephone =====%@=======password====%@===== confirm ======%@",telephoneNum,passWord,confirm);
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation start];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response=====%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error");
    }];
}

- (void)addTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"LoginPhoneCell" bundle:nil] forCellReuseIdentifier:@"cell" ];
    img = @[@"ico_field_phonenumber",@"ico_field_password",@"ico_field_password_confirm"];
    title = @[@"手机号码",@"密码",@"确认密码"];
    _tableView.tableFooterView = [self CustomView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoginPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:img[indexPath.row]];
    cell.textField.clearsOnBeginEditing = YES;
    cell.textField.placeholder = title[indexPath.row];
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row + 100;
   
    return cell;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 100) {
        telephoneNum = textField.text;
    }
     if (textField.tag == 101) {
        passWord = textField.text;
    }
    if (textField.tag == 102) {
        confirm = textField.text;
        
    }
    [textField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 100) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else
    {
        textField.secureTextEntry = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (UIView*)CustomView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    agreeBtn = [[UIButton alloc]initWithFrame:CGRectMake(105, 7, 80, 33)];
 
    [agreeBtn setTitle:@"用户协议." forState:(UIControlStateNormal)];
    [agreeBtn addTarget:self action:@selector(showAgreement) forControlEvents:UIControlEventTouchUpInside];
    agreeBtn.titleLabel.textColor = [UIColor blackColor];
    [agreeBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    agreeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    UILabel *labelAgreement = [[UILabel alloc]initWithFrame:CGRectMake(30,0,self.view.frame.size.width - 60, 30)];
    labelAgreement.font = [UIFont systemFontOfSize:12];
    labelAgreement.numberOfLines = 2;
    labelAgreement.text = @"注册[周末去哪儿]帐号,即表示你已阅读并同意接受[周末去哪儿]的";
    
        
        
    [view addSubview:agreeBtn];
    [view addSubview:labelAgreement];
        
    return view;
  
    
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return [self CustomView];
    }
    return nil;
}

- (void)showAgreement
{
    ShowAgreementController *agree = [[ShowAgreementController alloc]init];
    [self.navigationController pushViewController:agree animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}


@end













