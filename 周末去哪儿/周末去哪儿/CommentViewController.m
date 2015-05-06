//
//  CommentViewController.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/2.
//  Copyright (c) 2014年 pfl. All rights reserved.
//
#import "CommentCell.h"
#import "CommentViewController.h"

@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,NSURLConnectionDataDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UIButton *actBtn;
    UIButton *placeBtn;
    UITextView *_textView;
    NSMutableData *_data;
}
@end

@implementation CommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:(UIBarButtonItemStyleDone) target:self action:@selector(pulish)];
        _data = [NSMutableData data];
    }
    return self;
}

//http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&belong_id=12018&content=Hgffggjkjnn&format=json&is_recommend=1&method=comment.createnew&os=iphone&r=wanzhoumo&sign=9420deee44ddc5501f4255f46d5d35df&timestamp=1410404978&top_session=eoo0tided9rcvqcnb5jao29kf6&type=activity&v=2.0
- (void)pulish
{
    NSString *urlStr = [[NSString stringWithFormat:@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&belong_id=%@&content=%@&format=json&is_recommend=1&method=comment.createnew&os=iphone&r=wanzhoumo&sign=9420deee44ddc5501f4255f46d5d35df&timestamp=%@&top_session=plmr6mni4gsh87dcb0uim3ce33&type=activity&v=2.0",_model.sID,_textView.text,@"1410335762"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"text==ID===%@==%@=====%@",_textView.text,_model.sID,[self timestamp]);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    
}
- (NSString *)timestamp
{
    NSDate *date = [NSDate date];
    NSTimeInterval timestamp = [date timeIntervalSince1970] - 10;
    return [NSString stringWithFormat:@"%lld",(long long)timestamp];
}

#pragma mark NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"响应");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:_data options:(NSJSONReadingMutableContainers) error:nil];
    NSLog(@"dic===%@",dic);
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"失败");
}

//http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&belong_id=12018&content=Hgdgffhhjjjj&format=json&is_recommend=1&is_share_weibo=1&method=comment.createnew&os=iphone&r=wanzhoumo&sign=fc09c2ae019ed4449b382467bed1d641&timestamp=1410399027&top_session=ht14kmh14l7ppr4eiv879husa6&type=activity&v=2.0
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加评论";
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
   
    [self addTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.layer.opacity = 1.0;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:1.0 alpha:1.0];
}

- (void)addTableView
{
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [self customHeaderView];
    _tableView.tableFooterView = [self customFooterView];
    [_tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}

#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    _textView = cell.textView;
    cell.textView.showsVerticalScrollIndicator = NO;
    cell.textView.textColor = [UIColor grayColor];
    cell.textView.text = @"推荐:活动是什么,时间,参与对象......靠谱信息是活动快速上线的保证";
    CGRect rect = cell.textView.frame;
    rect.size.height = 100;
    cell.textView.frame = rect;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textView.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
}

- (UIView*)customHeaderView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    actBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10 , 140, 30)];
    actBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [actBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [actBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
    [actBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [actBtn setTitle:@"推荐" forState:(UIControlStateNormal)];
    
    placeBtn = [[UIButton alloc]initWithFrame:CGRectMake(actBtn.frame.origin.x + actBtn.frame.size.width + 20, actBtn.frame.origin.y, actBtn.frame.size.width, actBtn.frame.size.height)];
    placeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [placeBtn setTitle:@"吐槽" forState:(UIControlStateNormal)];
    [placeBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [placeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
    [placeBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    

    [view addSubview:actBtn];
    [view addSubview:placeBtn];
    view.frame = CGRectMake(0, 0, self.view.frame.size.width,44);
    view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    return view;
}



- (UIView*)customFooterView
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 180,5,200, 20)];
    label.text = [NSString stringWithFormat: @"评论不能少于10个字"];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0];
    UIButton *weiboBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, label.frame.origin.y + label.frame.size.height + 10, 120, 20)];
    [weiboBtn setTitle:@"分享到新浪微博" forState:(UIControlStateNormal)];
    [weiboBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    weiboBtn.tag = 100;
    weiboBtn.selected = YES;
    [weiboBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    weiboBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [weiboBtn setImage:[UIImage imageNamed:@"checkbox_inverse"] forState:(UIControlStateSelected)];
    [weiboBtn setImage:[UIImage imageNamed:@"checkbox_normal"] forState:(UIControlStateNormal)];
    
     UIButton *QQBtn = [[UIButton alloc]initWithFrame:CGRectMake(weiboBtn.frame.origin.x,weiboBtn.frame.size.height + weiboBtn.frame.origin.y + 10, weiboBtn.frame.size.width, weiboBtn.frame.size.height)];
    [QQBtn setTitle:@"分享到腾讯微博" forState:(UIControlStateNormal)];
    QQBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    QQBtn.tag = 200;
    QQBtn.selected = YES;
    [QQBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [QQBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [QQBtn setImage:[UIImage imageNamed:@"checkbox_inverse"] forState:(UIControlStateSelected)];
    [QQBtn setImage:[UIImage imageNamed:@"checkbox_normal"] forState:(UIControlStateNormal)];
    [view addSubview:QQBtn];
    [view addSubview:weiboBtn];
    [view addSubview:label];
    return view;
}

- (void)btnClick:(UIButton*)btn
{
    if (btn == actBtn)
    {
        _textView.text = @"推荐:活动是什么,时间,参与对象......靠谱信息是活动快速上线的保证";
        btn.selected = YES;
        placeBtn.selected = !btn.selected;
    }
    if (btn == placeBtn)
    {
        _textView.text = @"吐槽:吐槽的理由,不妨写在这里";
        btn.selected = YES;
        actBtn.selected = !btn.selected;
    }
    
    if (btn.tag == 100)
    {
      
        btn.selected = !btn.selected;
    }
    if (btn.tag == 200)
    {
        
        btn.selected = !btn.selected;
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
            textView.text = @"推荐:活动是什么,时间,参与对象......靠谱信息是活动快速上线的保证";
        else
            textView.text = @"吐槽:吐槽的理由,不妨写在这里";
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.layer.opacity = 1.0;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:1.0 alpha:1.0];
}


@end











