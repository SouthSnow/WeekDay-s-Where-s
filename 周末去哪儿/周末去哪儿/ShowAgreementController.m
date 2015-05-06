//
//  ShowViewController.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/9.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "ShowAgreementController.h"

@interface ShowAgreementController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *agreement;
}
@end

@implementation ShowAgreementController

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
    UITableView *myTableView = [[UITableView alloc]initWithFrame:self.view.frame style:(UITableViewStylePlain)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    [myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    agreement = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"agreement.txt" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
  
}

#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.text = agreement;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSLog(@"rect====%@",NSStringFromCGRect(cell.textLabel.frame));
    return cell;
}

- (CGFloat)getHeight:(NSString*)text
{
    CGFloat height;
    CGFloat version = [UIDevice currentDevice].systemVersion.floatValue;
    if (version >= 7.0)
    {
        height = [text boundingRectWithSize:(CGSize){285,299909} options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil].size.height;
        
    }
    else
    {
        height = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}].height;
        
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getHeight:agreement];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}


@end









