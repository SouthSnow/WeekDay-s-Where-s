//
//  LoginController.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/9.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "LoginController.h"
#import "LoginCell.h"
#import "LoginPhoneCell.h"
#import "RegisterController.h"
#import "ForgetPwdController.h"
#import "AFHTTPRequestOperation.h"
#import "UserData.h"
#import "SettingController.h"
//#import <Parse/Parse.h>
//#import "UserController.h"

@interface LoginController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    NSArray *img;
    NSString *telephoneNum;
    NSString *passWord;
    NSMutableArray *userArray;
    AppDelegate *dele;
    CategoryActivity *act;
    NSUserDefaults *defaults;
    NSData *data;
}
@end

@implementation LoginController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        userArray = [NSMutableArray array];
        dele = [UIApplication sharedApplication].delegate;
        act = [CategoryActivity shareCategory];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"details_top_blue_back_normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
    }
    return self;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addTableView];
    dele.customView.hidden = YES;
    self.title = @"登录";
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.layer.opacity = 1.0;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:1.0 alpha:1.0];
}



- (void)addTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
    [_tableView registerNib:[UINib nibWithNibName:@"LoginCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
    [_tableView registerNib:[UINib nibWithNibName:@"LoginPhoneCell" bundle:nil] forCellReuseIdentifier:@"cell3" ];
    img = @[@"other_login_button_QQ",@"other_login_button_weibo",@"other_login_button_weixin"];
}

#pragma mark UITableViewDelegate,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else if (section == 1)
        return 1;
    else
        return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        LoginPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textField.clearsOnBeginEditing = YES;
        
        if (indexPath.row == 0) {
            
            cell.textField.placeholder = @"手机号码";
            cell.imageView.image = [UIImage imageNamed:@"ico_field_phonenumber"];
            cell.textField.tag = 100;
            cell.textField.delegate = self;
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        else
        {
            cell.textField.secureTextEntry = YES;
            cell.textField.placeholder = @"密码";
            cell.imageView.image = [UIImage imageNamed:@"ico_field_password"];
            cell.textField.tag = 101;
            cell.textField.delegate = self;
        }
        return cell;
    }
    else if (indexPath.section == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"登录";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
        return cell;
        
    }
    else
    {
        LoginCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell.imgView.image = [UIImage imageNamed:img[indexPath.row]];
        return cell;
        
    }
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
       
        [self sendRequest:[NSString stringWithFormat:@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&method=user.selfLogin&mobile=%@&os=iphone&passwd=c4d650fcb910fa5b788b7a8db3c1c3c0&phone_type=iphone&phone_uuid=97B42FCB-7D7A-4D41-A80B-24644CBEE429&r=wanzhoumo&sign=26e732064f3aba3bbac1e45468433d46&timestamp=1410260041&v=2.0",@"18938935872"]];
        
    }
  
    if (indexPath.section == 2)
    {
        if (indexPath.row == 1)
        {

//            [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
//                              authOptions:[ShareSDK authOptionsWithAutoAuth:YES
//                                                              allowCallback:YES
//                                                              authViewStyle:SSAuthViewStyleFullScreenPopup
//                                                               viewDelegate:nil
//                                                    authManagerViewDelegate:nil]
//                                   result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
//             {
//                 if (result)
//                 {
//                     [userArray removeAllObjects];
//                     
//                     dele.loginStatus = @"success";
//                     defaults = [NSUserDefaults standardUserDefaults];
//                     NSString *loginStatus = dele.loginStatus;
//                     [defaults setObject:loginStatus forKey:@"loginStatus"];
//                     [defaults synchronize];
//                     
//                  
//                     UserData *userData = [[UserData alloc]init];
//                     userData.userIcon = [userInfo profileImage];
//                     userData.userID = [userInfo uid];
//                     userData.userGender = ([userInfo gender] == 0)?@"男":@"女";
//                     userData.userNick = [userInfo nickname];
//                     userData.userFollower = [NSString stringWithFormat:@"%ld",[userInfo followerCount]];
//                     userData.userFriend =[NSString stringWithFormat:@"%ld",[userInfo friendCount]] ;
//                     userData.city = [userInfo sourceData][@"location"];
//                     
//                     [userArray addObject:userData];
//                     
//                     data = [NSKeyedArchiver archivedDataWithRootObject:userData];
//                     [defaults setObject:data forKey:@"userData"];
//                     [defaults synchronize];
//                     //self.loginData(data);
//                     
//                     [self sendRequest:@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&method=user.commentList&os=iphone&pagesize=30&r=wanzhoumo&sign=603b0f3956306eff93eb597410313e53&timestamp=1410665435&top_session=3bsimp3gp9t243j806qf0g8u60&user_id=391620.000000&v=2.0"];
//                 act.userData = userArray;
//                 
//                 [self.navigationController popViewControllerAnimated:NO];
//                     
//                 }
//                 else
//                     
//                 {
//                     if ([error errorCode] != -103)
//                     {
//                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                             message:[NSString stringWithFormat:@"登录失败!%@", [error errorDescription]]
//                                                                            delegate:nil
//                                                                   cancelButtonTitle:@"知道了"
//                                                                   otherButtonTitles:nil];
//                         [alertView show];
//                     }
//                     
//                 }
//             }];
        }
    }
}

// block
- (void)passLoginDataFrom:(LoginData)loginBlock
{
    loginBlock(data);
     NSLog(@"data5=====%@",data);
    
}
- (void)sendRequest:(NSString*)urlString
{
    
//    NSString *stringUrl = [NSString stringWithFormat:@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&method=user.selfLogin&mobile=%@&os=iphone&passwd=c4d650fcb910fa5b788b7a8db3c1c3c0&phone_type=iphone&phone_uuid=97B42FCB-7D7A-4D41-A80B-24644CBEE429&r=wanzhoumo&sign=26e732064f3aba3bbac1e45468433d46&timestamp=1410260041&v=2.0",@"18938935872"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation start];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
    
        if ([dict[@"status"] isEqualToString:@"success"])
        {
            // 写入沙盒
            defaults = [NSUserDefaults standardUserDefaults];
            NSString *loginStatus = dict[@"status"];
            [defaults setObject:loginStatus forKey:@"loginStatus"];
            [defaults synchronize];
            [userArray removeAllObjects];
            
            dele.loginStatus = dict[@"status"];
            for (int i = 0; i < [dict[@"result"][@"comment_num"] intValue]; i++)
            {
                UserData *user = [[UserData alloc]init];
                user.userID =dict[@"result"][@"nick"];
                user.userNick = dict[@"result"][@"nick"];
                user.userIcon = dict[@"result"][@"icon"];
                user.userFeed =dict[@"result"][@"feed_num"];
                user.userFollower = dict[@"result"][@"follow_num"];
                user.userMessage = dict[@"result"][@"message_num"];
                user.userGender = dict[@"result"][@"gender"];
                user.userType =  dict[@"result"][@"type"];
                user.userActivity = dict[@"result"][@"activity_num"];
                user.userAddress= dict[@"result"][@"address"];
                user.userCredit =  dict[@"result"][@"credit"];
                user.userComment = dict[@"result"][@"comment_num"];
                user.userCover = dict[@"result"][@"cover"];
                user.userFriend = dict[@"result"][@"friend_num"];
                user.userpoi = dict[@"result"][@"poi_num"];
                user.userRegtime = dict[@"result"][@"regtime"];
                [userArray addObject:user];
                
            }
            
            act.userData = userArray;
            data = [NSKeyedArchiver archivedDataWithRootObject:userArray[0]];
            [defaults setObject:data forKey:@"userData"];
            [defaults synchronize];
           // self.loginData(data);
            [self.navigationController popViewControllerAnimated:NO];
        }
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error");
    }];
}



- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{ if (section == 1)
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    UIButton *forgetPwd = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 80, 33)];
    [forgetPwd setTitle:@"忘记密码?" forState:(UIControlStateNormal)];
    [forgetPwd addTarget:self action:@selector(forgetPassWord) forControlEvents:(UIControlEventTouchUpInside)];
    [forgetPwd setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    forgetPwd.titleLabel.font = [UIFont systemFontOfSize:10];
    UILabel *labelPwd = [[UILabel alloc]initWithFrame:CGRectMake( 2 * forgetPwd.frame.origin.x - 3,forgetPwd.frame.origin.y + forgetPwd.frame.size.height- 10, 44, .5)];
    labelPwd.backgroundColor = [UIColor blackColor];
    
    UIButton *registerAcc = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - forgetPwd.frame.size.width - 20, forgetPwd.frame.origin.y, forgetPwd.frame.size.width, forgetPwd.frame.size.height)];
    [registerAcc setTitle:@"注册新帐号" forState:(UIControlStateNormal)];
    [registerAcc addTarget:self action:@selector(rigisterAccound) forControlEvents:(UIControlEventTouchUpInside)];
    [registerAcc setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    registerAcc.titleLabel.font = [UIFont systemFontOfSize:10];
    UILabel *labelRig = [[UILabel alloc]initWithFrame:CGRectMake(registerAcc.frame.origin.x + 15,forgetPwd.frame.origin.y + forgetPwd.frame.size.height-10, labelPwd.frame.size.width + 5.5, labelPwd.frame.size.height)];
    labelRig.backgroundColor = [UIColor blackColor];
    
    UIImageView *left = [[UIImageView alloc]initWithFrame:CGRectMake(forgetPwd.frame.origin.x, forgetPwd.frame.origin.y + forgetPwd.frame.size.height + 40, 125, 3)];
    left.image = [UIImage imageNamed:@"or_sep_left"];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - left.frame.size.width - left.frame.origin.x - 30, left.frame.origin.y - 13.5, 30, 30)];
    label.text = @"或者";
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:8];
    
    UIImageView *right = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - left.frame.size.width - left.frame.origin.x, forgetPwd.frame.origin.y + forgetPwd.frame.size.height + 40, 125, 3)];
    right.image = [UIImage imageNamed:@"or_sep_right"];
    
    [view addSubview:forgetPwd];
    [view addSubview:labelPwd];
    [view addSubview:registerAcc];
    [view addSubview:labelRig];
    [view addSubview:label];
    [view addSubview:left];
    [view addSubview:right];
    
    return view;
}
    return nil;
    
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 100)
    {
        telephoneNum = textField.text;
    }
    if (textField.tag == 101)
    {
        passWord = textField.text;
    }
}
- (void)forgetPassWord
{
    ForgetPwdController *forget = [[ForgetPwdController alloc]init];
    [self.navigationController pushViewController:forget animated:YES];
}

- (void)rigisterAccound
{
    RegisterController *registerVC = [[RegisterController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 100;
    }
    else
        return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end










