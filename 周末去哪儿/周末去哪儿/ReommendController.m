//
//  ReommendController.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/8.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "ReommendController.h"
#import "RecommendCell.h"
#import "ContractCell.h"

@interface ReommendController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    UIButton *actBtn;
    UIButton *placeBtn;
    UITextView *_textView;
    ContractCell *cell1;
}
@end

@implementation ReommendController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我有线报";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:(UIBarButtonItemStylePlain) target:self action:@selector(sumbit)];
    }
    return self;
}

- (void)sumbit
{
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self addTableView];
}

- (void)addTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)style:(UITableViewStyleGrouped)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"RecommendCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ContractCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
  //  _tableView.tableHeaderView = [self customHeaderView];
    
    
}

#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
  
    if (indexPath.section == 2) {
        _textView = cell.textView;
        cell.textView.showsVerticalScrollIndicator = NO;
        cell.textView.textColor = [UIColor grayColor];
        cell.textView.text = @"活动:活动是什么,时间,参与对象......靠谱信息是活动快速上线的保证";
        CGRect rect = cell.textView.frame;
        rect.size.height = 100;
        cell.textView.frame = rect;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textView.delegate = self;
        return cell;
    }
    
    else if (indexPath.section == 3) {
        cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell1.textField.placeholder = @"请输入你的手机号码";
        cell1.textField.delegate = self;
        cell1.textField.borderStyle = UITextBorderStyleNone;
        return cell1;
    }
    else
    {
        return cell;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [self customHeaderView];
    }
    else if (section == 3)
    {
        NSArray *normal = @[@"line_phone_normal",@"line_qq_normal",@"line_weixin_normal"];
        NSArray *select = @[@"line_phone_inverse",@"line_qq_inverse",@"line_weixin_inverse"];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 100)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width-40, 30)];
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
            [btn addTarget:self action:@selector(btnClicks:) forControlEvents:(UIControlEventTouchUpInside)];
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
    else
    {
        {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, 30)];
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:12];
            if (section == 1)
                label.text = @"  活动名称/地点名称";
            else if (section == 2)
                
                label.text = @"  线报详情";
            
            return label;
        }
    }
}

- (void)btnClicks:(UIButton*)btn
{
    UIView *view = [btn superview];
    for (UIButton *button in view.subviews)
    {
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
    
    switch (btn.tag) {
        case 1:
            btn.selected = YES;
            cell1.textField.placeholder = @"请输入你的手机号码";
            break;
        case 2:
            btn.selected = YES;
            cell1.textField.placeholder = @"请输入你的QQ号码";
            break;
        case 3:
            btn.selected = YES;
            cell1.textField.placeholder = @"请输入你的微信号码";
            break;
        default:
            break;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"清除成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3)
    {
        return 30;
    }
    else
        return (indexPath.section == 2)?100:44;
    
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 90;
    }
    return (section == 3)?100:40;
}

- (UIView*)customHeaderView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    UILabel *type = [[UILabel alloc]initWithFrame:CGRectMake(10,10, 80, 20)];
    type.font = [UIFont systemFontOfSize:10];
    type.textColor = [UIColor grayColor];
    type.text = @"类型";
    actBtn = [[UIButton alloc]initWithFrame:CGRectMake(type.frame.origin.x, type.frame.origin.y + type.frame.size.height, 140, 20)];
    actBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [actBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [actBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
    [actBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [actBtn setTitle:@"推荐活动" forState:(UIControlStateNormal)];

    placeBtn = [[UIButton alloc]initWithFrame:CGRectMake(actBtn.frame.origin.x + actBtn.frame.size.width + 20, actBtn.frame.origin.y, actBtn.frame.size.width, actBtn.frame.size.height)];
    placeBtn.layer.cornerRadius = placeBtn.frame.size.height/2;
    placeBtn.clipsToBounds = YES;
    placeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [placeBtn setTitle:@"推荐地点" forState:(UIControlStateNormal)];
    [placeBtn setTintColor:[UIColor grayColor]];
    [placeBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [placeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
    [placeBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UILabel *city = [[UILabel alloc]initWithFrame:CGRectMake(actBtn.frame.origin.x, actBtn.frame.origin.y + actBtn.frame.size.height + 10, type.frame.size.width, actBtn.frame.size.height)];
    city.font = [UIFont systemFontOfSize:10];
    city.text =  @"所属城市";
    city.textColor = [UIColor grayColor];
    
    [view addSubview:type];
    [view addSubview:actBtn];
    [view addSubview:placeBtn];
    [view addSubview:city];
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, city.frame.size.height + city.frame.origin.y);
    //view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    return view;
}
- (void)btnClick:(UIButton*)btn
{
    if (btn == actBtn)
    {
        _textView.text = @"活动:活动是什么,时间,参与对象......靠谱信息是活动快速上线的保证";
        btn.selected = YES;
        placeBtn.selected = !btn.selected;
        
       
    }
    else
    {
        _textView.text = @"地点:好玩的地方,总有它好玩的理由,不妨写在这里";
        btn.selected = YES;
        actBtn.selected = !btn.selected;
    }
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (!textView.text.length)
    {
        if (actBtn.selected)
            textView.text = @"活动:活动是什么,时间,参与对象......靠谱信息是活动快速上线的保证";
        else
            textView.text = @"地点:好玩的地方,总有它好玩的理由,不妨写在这里";
    }
}


#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect rect = _tableView.frame;
    rect.origin.y = -250;
    _tableView.frame = rect;
    
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    CGRect rect = _tableView.frame;
    rect.origin.y = 0;
    _tableView.frame = rect;
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}



@end











