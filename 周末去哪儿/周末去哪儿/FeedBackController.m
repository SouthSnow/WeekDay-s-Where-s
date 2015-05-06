//
//  FeedBackController.m
//  周末去哪儿
//
//  Created by pangfuli on 14-9-15.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "FeedBackController.h"
#import "FeedBackCell.h"
#import "ContractCell.h"
#import "AFHTTPRequestOperation.h"

@interface FeedBackController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UITableView *_tableView;
    ContractCell *cell;
    NSArray *normal;
    NSArray *select;
    UIView *view;
    NSString *textViewText;
    NSString *wayText;
}

@end

@implementation FeedBackController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:(UIBarButtonItemStylePlain) target:self action:@selector(commit)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
    }
    return self;
}

- (void)commit
{
    NSLog(@"提交成功!");
   
    NSString *urlString = [[NSString stringWithFormat:@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&contact_type=mobile&contact_way=%@&content=%@&format=json&method=other.CreateSuggestion&os=iphone&r=wanzhoumo&sign=b2421d52da01cb5a162ac55846f1f74f&timestamp=1410849763&type=system&v=2.0",wayText,textViewText] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation start];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        NSLog(@"====hahh===%@",dic[@"status"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===============error");
    }];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"FeedBackCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ContractCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self.view addSubview:_tableView];
    _tableView.scrollEnabled = NO;
    normal = @[@"line_phone_normal",@"line_qq_normal",@"line_weixin_normal"];
    select = @[@"line_phone_inverse",@"line_qq_inverse",@"line_weixin_inverse"];
    
}

#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        FeedBackCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell1.textView.delegate = self;
        return cell1;
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell.textField.placeholder = @"请输入你的手机号码";
        cell.textField.delegate = self;
        cell.textField.borderStyle = UITextBorderStyleNone;
        return cell;
    }
}

#pragma mark UItextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    textViewText = textView.text;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark UItextFieldDelegate

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10,self.view.frame.size.width - 40 , 30)];
        UILabel *detail = [[UILabel alloc]initWithFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y + label.frame.size.height, label.frame.size.width, 40)];
        detail.text = @"感谢你告诉我们活动的错误信息，请输入你认为有误的信息或者修改意见";
        detail.numberOfLines = 2;
        detail.textColor = [UIColor grayColor];
        detail.font = [UIFont systemFontOfSize:12];
        label.text = @"报错详情";
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:12];
        [view1 addSubview:label];
        [view1 addSubview:detail];
        return view1;
    }
    else
    {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 100)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, self.view.frame.size.width-40, 30)];
        label.text = @"联系方式";
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:12];
        UILabel *detail = [[UILabel alloc]initWithFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y + label.frame.size.height, label.frame.size.width, label.frame.size.height)];
        detail.textColor = [UIColor grayColor];
        detail.text = @"我们可能会联系你了解信息,并不定期送出礼物哦~";
        detail.font = [UIFont systemFontOfSize:12];
        
       
        for (int i = 0; i < 3; i++)
        {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20*(i+1) + 30*i, detail.frame.size.height + detail.frame.origin.y, 30, 30)];
            btn.tag = i + 1;
            [btn setImage:[UIImage imageNamed:normal[i]] forState:(UIControlStateNormal)];
            [btn setImage:[UIImage imageNamed:select[i]] forState:(UIControlStateSelected)];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
            if (i == 0)
            {
                btn.selected = YES;
            }
            [view addSubview:btn];
        }
        
        
        [view addSubview:label];
        [view addSubview:detail];
        
        return view;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

- (void)btnClick:(UIButton*)btn
{
   
    for (UIButton *button in view.subviews) {
        if ([button isKindOfClass:[UIButton class]])
        {
            if (btn == button) {
                button.selected = YES;
            }
            else
            {
                button.selected = NO;
            }
        }
       
    }
    
    btn.selected = YES;
    
    switch (btn.tag) {
        case 1:
           
            cell.textField.placeholder = @"请输入你的手机号码";
            break;
        case 2:
           
            cell.textField.placeholder = @"请输入你的QQ号码";
            break;
        case 3:
            
            cell.textField.placeholder = @"请输入你的微信号码";
            break;
        default:
            break;
    }
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect rect = _tableView.frame;
    rect.origin.y = -186;
    _tableView.frame = rect;
    wayText = textField.text;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    
    UIView *view1 = [_tableView hitTest:point withEvent:event];
    [view1 endEditing:YES];
    
    return view1;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    CGRect rect = _tableView.frame;
    rect.origin.y = 0;
    _tableView.frame = rect;
    return YES;
}

@end







