//
//  AboatController.m
//  周末去哪儿
//
//  Created by pangfuli on 14-9-15.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "AboatController.h"

@interface AboatController ()<SinaWeiboRequestDelegate,SinaWeiboDelegate>

@end

@implementation AboatController

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
    self.title = @"关于我们";
    _tel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
    _weibo.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:.9];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(call:)];
    _tel.userInteractionEnabled = YES;
    [_tel addGestureRecognizer:tap];
    
    UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weibo:)];
    _weibo.userInteractionEnabled = YES;
    [_weibo addGestureRecognizer:myTap];
    
}

- (void)call:(UITapGestureRecognizer*)tap
{

    UIWebView *phineCall = [[UIWebView alloc]initWithFrame:CGRectZero];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"4006543179"]]];
    
    [phineCall loadRequest:request];
    [self.view addSubview:phineCall];
}

- (void)weibo:(UITapGestureRecognizer*)tap
{
    _myWeibo = [[SinaWeibo alloc]initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kRedirectUri andDelegate:self];
    [_myWeibo logIn];
    [_myWeibo requestWithURL:@"statuses/update.json" params:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"弯弯的河水从天上来...",@"status",nil] httpMethod:@"POST" delegate:self];
}

#pragma mark SinaWeiboDelegate
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"=============longinSuccess======%@",sinaweibo.accessToken);
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"======loginFailed======");
    
}

#pragma mark SinaWeiboRequestDelegate

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"=====requestSuccess======");
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"=========requestFailed=======");
}


@end





