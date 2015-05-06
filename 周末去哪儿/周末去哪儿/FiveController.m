//
//  FiveController.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/9.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "FiveController.h"
#import "LoginController.h"
#import "UserController.h"
#import "SettingController.h"
#import "ComtentCell.h"
#import "ActCell.h"
#import "AFHTTPRequestOperation.h"
#import "UserData.h"
#import "AttentionCell.h"
#import "SegmentCell.h"
#import "UIImageView+WebCache.h"


@interface FiveController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *_imgView;
    UIScrollView *_bodyScrollView;
    UISwipeGestureRecognizer *_leftSwipe;
    UISwipeGestureRecognizer *_rightSwipe;
    UITableView *_tableView;
    UITableView *_myTableView;
    NSMutableData *_data;
    NSMutableArray *_dataArray;
    NSMutableArray *_topStoryArray;
    UIPageControl *_pageCtl;
    NSTimer *_timer;
    NSMutableArray *_loopArray;
    AppDelegate *dele;
    UIView *_view;
    UIView *_view1;
    UISegmentedControl *segment;
    UILabel *label;
    UILabel *label2;
    UIActivityIndicatorView *_act;
    CategoryActivity *activity;
    
    UILabel *_label;
    UIImageView *icon;
    UIView *footerView;
    NSArray *urlArray;
    UIView *view;
    UIImagePickerController *imagePicke;
    UIImage *theImage;
    UIImageView *imgView;
    NSString *path;
}
@end

@implementation FiveController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ico_set"] style:(UIBarButtonItemStyleDone) target:self action:@selector(set)];
        self.title = @"我的主页";
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
     
        [self initAll];
        
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
    if (![dele.loginStatus isEqualToString:@"success"])
    {
        [self addTips];
    }
   else
   {
       [self addTableView];
       [self addSegmentControl];
   }
  
}

- (void)initAll
{
    _userDataArray = [NSMutableArray array];
    _data = [NSMutableData data];
    _dataArray = [NSMutableArray array];
    _topStoryArray = [NSMutableArray array];
    dele = [UIApplication sharedApplication].delegate;
    activity = [CategoryActivity shareCategory];
    urlArray = [NSArray arrayWithObjects:@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&method=user.commentList&os=iphone&pagesize=30&r=wanzhoumo&sign=b67bee1c7978fd07a9dd90872da9efe9&timestamp=1410532245&top_session=52s1h1418emkofq76v120r6g75&user_id=403461.000000&v=2.0",@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&lat=22.562432&lon=113.904414&method=user.poiList&os=iphone&pagesize=30&r=wanzhoumo&sign=e4b4731ecc6533e26c216bfd9e036540&timestamp=1410534020&top_session=52s1h1418emkofq76v120r6g75&user_id=403461&v=2.0",nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    dele.customView.hidden = NO;
    if ([dele.loginStatus isEqualToString:@"success"])
    {
        
        // 移除所有的原控件
        for (int i = 0; i < self.view.subviews.count; i++)
        {
            [[self.view.subviews objectAtIndex:i] removeFromSuperview];
        }
        

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey:@"userData"];
        UserData *userData =(UserData*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
       [_userDataArray addObject:userData];
        //_userDataArray = activity.userData;
        [self addTableView];
        segment.selectedSegmentIndex = 0;
        [self sendRequest:urlArray[0]];
        [self dragRefresh];
        [self addSegmentControl];
       
        if (theImage) {
            imgView.image = theImage;
        }
    }
    
    else
    {
        [self addTips];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)addTips
{
    // 移除所有的原控件
    for (UITableView *tabView in self.view.subviews)
    {
        [tabView removeFromSuperview];
    }
    UIImageView *imagView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 53)/2, 90, 53, 53)];
    imagView.image = [UIImage imageNamed:@"pic_empty_link"];
    [self.view addSubview:imagView];
    
    UILabel *noLogin = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 170)/2, imagView.frame.size.height + imagView.frame.origin.y + 40, 170, 21)];
    noLogin.text = @"你还没有登录";
    noLogin.textAlignment = NSTextAlignmentCenter;
    noLogin.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:noLogin];
    
    UILabel *afterLogin = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 280)/2, noLogin.frame.size.height + noLogin.frame.origin.y + 40, 280, noLogin.frame.size.height)];
    afterLogin.text = @"登录后才可查看你的[评论]和[关注的地点]";
    afterLogin.textAlignment = NSTextAlignmentCenter;
    afterLogin.font = [UIFont systemFontOfSize:12];
    [self.view addSubview: afterLogin];
    
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 200)/2, afterLogin.frame.size.height + afterLogin.frame.origin.y + 40, 200, 30)];
    [loginBtn setTitle:@"立即登录" forState:(UIControlStateNormal)];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    loginBtn.backgroundColor = [UIColor redColor];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:loginBtn];
}

- (void)login
{
    LoginController *login = [[LoginController alloc]init];
    [self.navigationController pushViewController:login animated:YES];
}

#if 1

- (void)dragRefresh
{
    _view = [[UIView alloc]initWithFrame:(CGRect){0,-64,self.view.frame.size.width,64}];
    [_tableView addSubview:_view];
    
    UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    act.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
    [_view addSubview:act];
    _view.backgroundColor = [UIColor grayColor];
    _act = act;
}

- (void)beginRefresh:(UIScrollView*)scrollView
{
    NSLog(@"scrollView.contentOffset.y ==%F",scrollView.contentOffset.y );
    [_act startAnimating];
    if (scrollView.contentOffset.y < -64.0)
    {
        
        [UIView animateWithDuration:0.5 animations:^{
            _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        }];
        [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2.0];
    }
    
}

- (void)stopRefresh
{
    [UIView animateWithDuration:.5 animations:^{
        [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }];
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:dele.selectedArray];
    [_tableView reloadData];
   // [segment setTitle:[NSString stringWithFormat:@"正在进行(%ld)",dele.selectedArray.count] forSegmentAtIndex:0];
    
    [_act stopAnimating];
}


- (void)addTableView
{
    _bodyScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _bodyScrollView.delegate = self;
    _bodyScrollView.contentSize = CGSizeMake(0, _dataArray.count * 150);
    [_bodyScrollView addSubview:[self customHeaderView]];
    [_bodyScrollView addSubview:_tableView];
    _bodyScrollView.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [self.view addSubview:_tableView];
 
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [self customHeaderView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
    [_tableView registerNib:[UINib nibWithNibName:@"ActCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
    [_tableView registerNib:[UINib nibWithNibName:@"AttentionCell" bundle:nil] forCellReuseIdentifier:@"cell3"];
    [_tableView registerNib:[UINib nibWithNibName:@"SegmentCell" bundle:nil] forCellReuseIdentifier:@"cell4"];
}

#pragma mark UITableViewDataSource,UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return _dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
   
        if (segment.selectedSegmentIndex == 0)
        {
            ActCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            cell.userData = _dataArray[indexPath.row];
            return cell;
        }
        else
        {
            AttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
            cell.data = _dataArray[indexPath.row];
            return cell;
        }
    

  
}

- (UIView*)customHeaderView
{
    
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 175 + 40)];
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 175)];
    imgView.image = [UIImage imageNamed:@"default_user_cover"];
    
    icon = [[UIImageView alloc]initWithFrame:CGRectMake(20,135, 60, 60)];
    icon.image = [UIImage imageNamed:@"avatardefault"];
    // 添加手势获取本地图片
    imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getImage:)];
    [imgView addGestureRecognizer:tap];
    
    
    
    UILabel *nick = [[UILabel alloc]initWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width + 10, 135, 100, 30)];
    
    if (_userDataArray.count)
    {
       UserData *user = _userDataArray[0];
        nick.font = [UIFont systemFontOfSize:12];
        nick.textColor = [UIColor whiteColor];
        nick.text = user.userNick;
        if(user.userIcon)
        {
            [icon setImageWithURL:[NSURL URLWithString:user.userIcon] placeholderImage:nil];;
        }
     
        UILabel *atten = [[UILabel alloc]initWithFrame:CGRectMake(nick.frame.origin.x + 10, imgView.frame.origin.y + imgView.frame.size.height + 10, 60, nick.frame.size.height)];
        atten.text = [NSString stringWithFormat:@"%d关注",user.userActivity.intValue];
        atten.font = [UIFont systemFontOfSize:12];
        UILabel *fan = [[UILabel alloc]initWithFrame:CGRectMake(atten.frame.size.width + atten.frame.origin.x + 20, imgView.frame.origin.y + imgView.frame.size.height + 10, 60, nick.frame.size.height)];
        fan.text = [NSString stringWithFormat:@"%d粉丝",user.userFollower.intValue];
        fan.font = [UIFont systemFontOfSize:12];
        [view addSubview:atten];
        [view addSubview:fan];
    }
    else
    {
        
    }
    UILabel *edit = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 70, imgView.frame.size.height - 25, 60, 20)];
    edit.text = @"编辑资料";
    edit.textAlignment = NSTextAlignmentCenter;
    edit.font = [UIFont systemFontOfSize:12];
    edit.textColor = [UIColor whiteColor];
    edit.backgroundColor = [UIColor colorWithWhite:.4 alpha:0.6];
    UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(edit:)];
    [edit addGestureRecognizer:myTap];

    [view addSubview:imgView];
    [view addSubview:icon];
    [view addSubview:nick];
   
    [view addSubview:edit];
    return view;
}

- (void)getImage:(UITapGestureRecognizer*)tap
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"更改相册封面" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"手机相册",@"拍照", nil];
    [sheet showInView:self.view];
    
}

#pragma mark UIAlertViewDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
 
    if (buttonIndex == 0)
    {
        
        [self pickImageFromAlbum];
        
        
    }
    else if (buttonIndex == 1)
    {
        [self pickImageFromCamera];
    }
    else
    {
        NSLog(@"======theimge=====%@",theImage);
    }
}


- (void)edit:(UITapGestureRecognizer*)tap
{
    
}
 #pragma mark 从用户相册获取活动图片
- (void)pickImageFromAlbum
{
    imagePicke = [[UIImagePickerController alloc]init];
    imagePicke.delegate = self;
    imagePicke.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicke.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicke.allowsEditing = YES;
    [self presentViewController:imagePicke animated:YES completion:^{
        
    }];
}
#pragma mark 从摄像头获取活动图片
- (void)pickImageFromCamera
{
    imagePicke = [[UIImagePickerController alloc]init];
    imagePicke.delegate = self;
    imagePicke.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicke.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicke.allowsEditing = YES;
    [self presentViewController:imagePicke animated:YES completion:^{
        
    }];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    theImage = info[UIImagePickerControllerEditedImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(theImage, nil, nil, nil);
    }

    NSData *imageData = UIImageJPEGRepresentation(theImage, 0);
    path = [NSHomeDirectory() stringByAppendingPathComponent:@"image"];
    [imageData writeToFile:path atomically:YES];
//    imgView.image = [UIImage imageWithData:imageData];
//    imgView.image = theImage;

    [picker dismissViewControllerAnimated:YES completion:^{}];
}



#if 1
- (void)addSegmentControl
{
    if (_userDataArray.count) {
        UserData *data = _userDataArray[0];
        NSString *com = [NSString stringWithFormat:@"评论(%d)",data.userComment.intValue];
        NSString *poi = [NSString stringWithFormat:@"地点(%d)",data.userpoi.intValue];
        segment = [[UISegmentedControl alloc]initWithItems:@[com,poi]];
    }
    else
    {
        NSString *com = [NSString stringWithFormat:@"评论(%d)",0];
        NSString *poi = [NSString stringWithFormat:@"地点(%d)",0];
        segment = [[UISegmentedControl alloc]initWithItems:@[com,poi]];
    }
    
 
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(observeChange) forControlEvents:(UIControlEventValueChanged)];
    view.userInteractionEnabled = YES;
    segment.tintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
    
   
}
#endif

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [_view1 addSubview:segment];
    _view1.backgroundColor = [UIColor redColor];
    return segment;
}


- (void)observeChange
{
    
    if (segment.selectedSegmentIndex == 0)
    {
        [self sendRequest:urlArray[0]];
    }
    else
    {
        
        [self sendRequest:urlArray[1]];
    }
    
}


- (void)sendRequest:(NSString*)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation start];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        [_dataArray removeAllObjects];
         
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        
        for (NSDictionary *dic in dict[@"result"][@"list"])
        {
            UserData *data = [[UserData alloc]init];
            if (segment.selectedSegmentIndex == 0)
            {
                data.userID = dic[@"user_id"];
                data.userContent = dic[@"content"];
                data.userType = dic[@"type"];
                data.userNick = dic[@"user.nick"];
                data.userpoi = dic[@"poi.title"];
                data.userActivity = dic[@"activity.title"];
                data.userActivityVice = dic[@"activity.title.vice"];
                [data.userPoiPicArray arrayByAddingObjectsFromArray:dic[@"poi.pic_usercommentlist"]];
                [data.userCommentlistArray addObjectsFromArray:dic[@"activity.pic_usercommentlist"]];
                data.userCreateTime = dic[@"create_time"];
                data.userReplyNum = dic[@"reply_num"];
                data.targetPic = dic[@"activity.pic_usercommentlist"][0];
            }
            else
            {
                data.title = dic[@"title"];
                data.fllowNum = dic[@"statis.follow_num"];
                data.activityNum = dic[@"statis.activity_num"];
                data.city = dic[@"parent.title"];
                data.userActivityVice = dic[@"activity.title.vice"];
                [data.userPoiPicArray arrayByAddingObjectsFromArray:dic[@"pic_list_show"]];
                [data.userCommentlistArray addObjectsFromArray:dic[@"pic_show"]];
                data.userCreateTime = dic[@"create_time"];
                
            }
            
            [_dataArray addObject:data];
           
        
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"failure");
    }];
}



- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    footerView = [[UIView alloc]initWithFrame:CGRectZero];
    UIImageView *imagView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 135)/2, 20, 135, 9)];
    imagView.image = [UIImage imageNamed:@"end"];
    [footerView addSubview:imagView];
    footerView.frame = CGRectMake(0, 0, self.view.frame.size.width, imagView.frame.size.height);
    return footerView;
  

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
}


#endif



@end
