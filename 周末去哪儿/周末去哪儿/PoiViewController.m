//
//  PoiViewController.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/4.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"
#import "DetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "CommentViewController.h"
#import "DetTableViewCell.h"
#import <MapKit/MapKit.h>
#import "AFHTTPRequestOperation.h"
#import "DetailModel.h"
#import "DetailCell2.h"
#import "PoiViewController.h"
#import "TableViewCell.h"
#import "ShowImageCell.h"
#import "User.h"
#import "ComtentCell.h"
#import "ContentController.h"
#import "SingleUserController.h"
#import "MapViewController.h"



@interface PoiViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIScrollView *_bodyScrollView;
    UISwipeGestureRecognizer *_leftSwipe;
    UISwipeGestureRecognizer *_rightSwipe;
    UITableView *_tableView;
    NSMutableData *_data;
    NSMutableArray *_dataArray;
    NSMutableArray *_topStoryArray;
    UIPageControl *_pageCtl;
    NSTimer *_timer;
    NSMutableArray *_loopArray;
    DetailTableViewCell *_cell;
    int page;
    UIView *footerView;
    UIView *headerView;
    UIView *pageView;
    NSString *commentNum;
    CategoryActivity *categ;
    UIView *contentView;
    NSMutableArray *tempArray;
    UIPageControl *pageCtl;
    AppDelegate *dele;
    UIImageView *imgView;
    NSCache *imageCache;
    
    NSCache *imageCache2;
    
    
}


@end
//@implementation UINavigationBar (CustomImage)
//
//-(void)drawRect:(CGRect)rect
//{
////    UIImage *image = [UIImage imageNamed:@"mm.jpg"];
////    [image drawInRect:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
//}
//
//@end
@implementation PoiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initAll];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"details_top_white_back_inverse"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"details_top_white_back_inverse"]];
      
    }
    return self;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setModel:(StoryModel *)model
{
    _model = model;
    [_tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageCache = [[NSCache alloc]init];
    imageCache2 = [[NSCache alloc]init];
    dele.customView.hidden = YES;
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"2"] forBarMetrics:(UIBarMetricsDefault)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addTableView];
    [self sendRequest];
    [self addCommentBtn];
 
   ///self.edgesForExtendedLayout = UIRectEdgeTop;
}


- (void)viewWillAppear:(BOOL)animated
{
//    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, 320, 64)];
//    for (UIView *view in self.navigationController.view.subviews) {
//        if (![view isMemberOfClass:[UINavigationBar class]]) {
//            [view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height + 64)];//这里调整内容区域大小位置
//        }
//    }
//   
}
- (void)sendRequest
{
    NSURL *url = [NSURL URLWithString:@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&id=18617&lat=22.562468&lon=113.904374&method=poi.detail&os=iphone&r=wanzhoumo&sign=7da64a3edad431b23b7aeb40d5575987&timestamp=1409981420&v=2.0"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation start];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        
        NSDictionary *dic = dictionary[@"result"];
        
        DetailModel *model = [[DetailModel alloc]init];
        model.title = dic[@"title"];
        model.tel = dic[@"tel"];
        model.cost = dic[@"cost"];
        model.address = dic[@"address"];
        model.openTime = dic[@"open_time"];
        [model.picShowArray arrayByAddingObjectsFromArray: dic[@"pic_show"]];
        categ.picUrl = dic[@"pic_show"][0];
        model.introdution = dic[@"intro"];
        model.start_time_show = dic[@"start_time_show"];
        model.distance_show = dic[@"distance_show"];
        model.follow_num = dic[@"statis.follow_num"];
        model.comment_num = dic[@"statis.comment_num"];
        model.pic_details_show = dic[@"pic_details_show"];
        commentNum = dic[@"statis.comment_num"];
        model.city = dic[@"citypoi.title"];
        model.latitude = dic[@"lat"];
        model.longitude = dic[@"lon"];
        [model.pic_list_thumb addObjectsFromArray:dic[@"pic_list_thumb"]];
        model.ID = dic[@"id"];
        [_dataArray addObject:model];
        
        for (NSDictionary *dict in dic[@"all_comment"][@"list"])
        {
             User *user = [[User alloc]init];
            user.ID = dict[@"id"];
            user.userID = dict[@"user_id"];
            user.belongID = dict[@"belong_id"];
            user.recommend = dict[@"is_recommend"];
            user.type = dict[@"type"];
            user.content = dict[@"content"];
            user.status = dict[@"status"];
            user.createTime = dict[@"create_time"];
            user.agreeNum = dict[@"agree_num"];
            user.userNick = dict[@"user.nick"];
            user.replyNum = dict[@"reply_num"];
            user.userIcon = dict[@"user.icon_url"];
            user.excellent = dict[@"is_excellent"];
            [_topStoryArray addObject:user];
        }
        
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
    }];
    
    
}
- (void)addCommentBtn
{//self.view.frame.size.height - 100
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 40, [UIScreen mainScreen].bounds.size.width, 40)];
    contentView.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, 34)];
    [btn setImage:[UIImage imageNamed:@"details_btn_comment_normal"] forState:(UIControlStateNormal)];
    btn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
    [btn addTarget:self action:@selector(comment:) forControlEvents:(UIControlEventTouchUpInside)];
    [contentView addSubview:btn];
    
    [self.view addSubview:contentView];
}


- (void)comment:(UIButton*)btn
{
    CommentViewController *com = [[CommentViewController alloc]init];
    [self.navigationController pushViewController:com animated:YES];
}

- (void)addTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height) style:(UITableViewStyleGrouped)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ComtentCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
    [_tableView registerNib:[UINib nibWithNibName:@"DetTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [_tableView registerNib:[UINib nibWithNibName:@"ShowImageCell" bundle:nil] forCellReuseIdentifier:@"cell4"];
    [_tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"cell5"];
    _tableView.tableHeaderView = [self customHeaderView];
    _tableView.tableFooterView = [self customFooterView];
    [_tableView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:nil];
}

- (void)initAll
{
    dele = [UIApplication sharedApplication].delegate;
    categ = [CategoryActivity shareCategory];
    _dataArray = [NSMutableArray array];
    _topStoryArray = [NSMutableArray array];
    _headArray = [NSMutableArray array];
    tempArray = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
#pragma mark <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 3;
    }
    else if (section == 2)
    {
        if (!_topStoryArray.count) {
            return 0;
        }
        return 2;
    }
    else
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        DetTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
        cell.model = _model;
        return cell;
    }
    else if(indexPath.section == 1)
    {
        
        if (_dataArray.count)
        {
            
            DetailModel *model = _dataArray[0];
            NSArray *textArray = [NSArray arrayWithObjects:model.tel,model.openTime,model.cost, nil];
            NSArray *array = [NSArray arrayWithObjects:@"details_place",@"ico_open",@"details_cost", nil];
            
            return [self tabelView:tableView ForindexPath:indexPath WithText:textArray[indexPath.row] WithImage:array[indexPath.row]];
        }
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            return cell;
        }
      
        
    }
    else if(indexPath.section == 2)
    {
       
       
        if (_topStoryArray.count)
        {
            if (indexPath.row == 0)
            {
                ComtentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
                User *user = _topStoryArray[0];
                cell.user = user;
                return cell;
            }
           else
           {
               UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
               cell.textLabel.text =  @"查看全部评论";
               cell.textLabel.font = [UIFont systemFontOfSize:15];
               cell.textLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
               cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
               return cell;
           }
         
        }
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
           
            return cell;
        }
        
       
    }
    else if (indexPath.section == 3)
    {
        ShowImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
        if (_dataArray.count)
        {
            DetailModel *model = _dataArray[0];
//             cell.array = model.pic_list_thumb;
            NSMutableArray *array = [model.pic_list_thumb mutableCopy];
            tempArray = model.pic_details_show;
          
            int count = (int)array.count;
            if ( count < 5)
            {
                for (int i = 0; i < 5 - count; i++)
                {
                    [array addObject:@"pic_default"];
                }
                
            }
            
            NSArray *imageArr = @[cell.img1,cell.img2,cell.img3,cell.img4,cell.img5];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                for (int i = 0; i < imageArr.count; i++) {
                    
                    __block UIImage *thumbImage = [imageCache2 objectForKey:[NSString stringWithFormat:@"%d",i]];
                    if (thumbImage) {
                        ((UIImageView *)imageArr[i]).image = thumbImage;
                    }
                    
                    if (!thumbImage) {
                        
                        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:array[i]]]]?:[UIImage imageNamed:@"pic_default"];
                        float scale = [UIScreen mainScreen].scale;
                        UIGraphicsBeginImageContextWithOptions(((UIImageView *)imageArr[i]).bounds.size, YES, scale);
                        [image drawInRect:CGRectMake(0, 0, ((UIImageView *)imageArr[i]).bounds.size.width, ((UIImageView *)imageArr[i]).bounds.size.height)];
                        thumbImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        dispatch_async(dispatch_get_main_queue(), ^{
                            ((UIImageView *)imageArr[i]).image = thumbImage;
                            [imageCache2 setObject:thumbImage forKey:[NSString stringWithFormat:@"%d",i]];
                        });
                        
                    }
                    
                }
                
            });
            
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myTap:)];
            cell.userInteractionEnabled = YES;
            [cell addGestureRecognizer:tap];
        }
        
       
        return cell;
    }
    else
    {
        
        TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell5"];
        cell.model = _model;
        return cell;
    }
    return nil;
    
}

- (void)myTap:(UITapGestureRecognizer*)tap
{
    CGRect rect = contentView.frame;
      rect.origin.x = -self.view.frame.size.width;
    self.show = [[ShowImageController alloc]init];
    self.show.showArray = tempArray;
    self.show.view.frame = [UIScreen mainScreen].bounds;
    [UIView animateWithDuration:1 animations:^{
        contentView.frame = rect;
    }];
    [self presentViewController:self.show animated:YES completion:^{
        
    }];
   
    UITapGestureRecognizer *newTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resize:)];
    self.show.view.userInteractionEnabled = YES;
    [self.show.view addGestureRecognizer:newTap];
}

- (void)resize:(UITapGestureRecognizer*)tap
{
    CGRect rect = contentView.frame;
    rect.origin.x = 0;
    [self.show dismissViewControllerAnimated:YES completion:^{
        
    }];
    [UIView animateWithDuration:.5 animations:^{
        contentView.frame = rect;
    }];
    
}



- (UITableViewCell*)tabelView:(UITableView*)tableView ForindexPath:(NSIndexPath *)indexPath WithText:(NSString*)text WithImage:(NSString*)image
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%d",(int)indexPath.row]];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:[NSString stringWithFormat:@"%d",(int)indexPath.row]];
    }
    if (indexPath.row == 0)
    {
        
        cell.textLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
       
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (indexPath.row != 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.imageView.image = [UIImage imageNamed:image];
    cell.textLabel.text = text;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        MapViewController * map = [[MapViewController alloc]init];
         map.model = _model;
        [self.navigationController pushViewController:map animated:YES];
    }
    
    if (indexPath.section == 2 )
    {
        if (indexPath.row == 1) {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            ContentController *pVc = [[ContentController alloc]init];
            pVc.contentArray = _topStoryArray;
            [self.navigationController pushViewController:pVc animated:YES];
        }
        else
        {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            SingleUserController *pVc = [[SingleUserController alloc]init];
            pVc.contentArray = _topStoryArray;
            [self.navigationController pushViewController:pVc animated:YES];
        }

    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectZero];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_model.tel]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [webView loadRequest:request];
            [self.view addSubview:webView];
            
        }
    }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    if (indexPath.section == 4) {
        return 250;
    }
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
    
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (section == 2) {
        if (_topStoryArray.count)
        {
           return [NSString stringWithFormat:@"评论(%d条)",(int)_topStoryArray.count];
        }
        
    }
    else if (section == 3)
    {
        return [NSString stringWithFormat:@"相册(%d)",(int)2];
    }
    else if (section == 4)
    {
        return @"正在进行的活动...";
    }
    return nil;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_topStoryArray.count == 0)
    {
        if (section == 2)
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
            
            UIImageView *replyView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 72)/2, 40, 72, 53)];
            replyView.image = [UIImage imageNamed:@"pic_empty_reply"];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60, replyView.frame.size.height + replyView.frame.origin.y + 40, self.view.frame.size.width - 120, 30)];
            label.text = @"还没有评论,你先来一条呗";
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor colorWithRed:160.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0];
            label.font = [UIFont systemFontOfSize:14];
            [view addSubview:replyView];
            [view addSubview:label];
            view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
            
            return view;
        }

    }
        return nil;
}

- (UIView*)customFooterView
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    UILabel *label = [[UILabel alloc]initWithFrame:view.frame];
    label.text = @"往期活动";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0];
    label.font = [UIFont systemFontOfSize:12];
    [view addSubview:label];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
    if (section == 2)
    {
        if (!_topStoryArray.count)
            return 200;
        else
            return 40;
    }
    else if (section == 3 || section == 4)
        return 40;
        return 5;
}


- (UIView*)customHeaderView
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 175 + 40)];
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, view.frame.origin.y, view.frame.size.width, 175)];
    [imgView setImageWithURL:[NSURL URLWithString:_model.picShowArray[0]] placeholderImage:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block UIImage *thumbIamge = [imageCache objectForKey:@"iamge"];
        imgView.image = thumbIamge;
        if (!thumbIamge) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_model.picShowArray[0]]]];
            float scale = [UIScreen mainScreen].scale;
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.bounds.size.width, 175), YES, scale);
            [image drawInRect:CGRectMake(0, 0, self.view.bounds.size.width,175)];
            thumbIamge = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            dispatch_async(dispatch_get_main_queue(), ^{
                imgView.image = thumbIamge;
                [imageCache setObject:thumbIamge forKey:@"image"];
            });
            
        }
        
    });
    
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(20,135, 60, 60)];
    icon.image = [UIImage imageNamed:@"avatardefault_place"];
    UILabel *nick = [[UILabel alloc]initWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width + 10, 135, 100, 30)];
    
    nick.font = [UIFont systemFontOfSize:12];
    nick.textColor = [UIColor whiteColor];
   
    
    UILabel *atten = [[UILabel alloc]initWithFrame:CGRectMake(nick.frame.origin.x + 10, imgView.frame.origin.y + imgView.frame.size.height + 10, 40, nick.frame.size.height)];
    atten.text = [NSString stringWithFormat:@"深圳"];
    
    UIImageView *dot = [[UIImageView alloc]initWithFrame:CGRectMake(atten.frame.origin.x + 29, atten.frame.origin.y + 11.5, 7, 7)];
    dot.image = [UIImage imageNamed:@"details_zero_normal.png"];
    
    
    atten.font = [UIFont systemFontOfSize:12];
    UILabel *fan = [[UILabel alloc]initWithFrame:CGRectMake(atten.frame.size.width + atten.frame.origin.x, imgView.frame.origin.y + imgView.frame.size.height + 10, 60, nick.frame.size.height)];
    fan.text = [NSString stringWithFormat:@"%d粉丝",_model.follow_num.intValue];
    fan.font = [UIFont systemFontOfSize:12];
    
    UILabel *address = [[UILabel alloc]initWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width + 10, icon.frame.origin.y + 10, 150, 20)];
    address.text = _model.position;
    address.font = [UIFont systemFontOfSize:13];
    address.textColor = [UIColor whiteColor];

    self.title = _model.position;
    
    
    //friend_add
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 70, imgView.frame.size.height - 25, 60, 20)];
    [btn setImage:[UIImage imageNamed:@"friend_add"] forState:(UIControlStateNormal)];
    [btn setImage:[UIImage imageNamed:@"friend_add_end"] forState:(UIControlStateSelected)];
    btn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];

    
    [view addSubview:imgView];
    [view addSubview:icon];
    [view addSubview:address];
    [view addSubview:nick];
    [view addSubview:atten];
    [view addSubview:dot];
    [view addSubview:fan];
    [view addSubview:btn];
    
    return view;
}

- (void)btnClick:(UIButton*)btn
{
    btn.selected = YES;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"chang=======%@",change);
    
    if ([keyPath  isEqual: @"contentOffset"]) {
        
        NSLog(@"=====keyPath======%@",keyPath);
       
        
        if (_tableView.contentOffset.y < 0)
        {
            
            self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"details_top_white_back_inverse"]; //= [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"details_top_white_back_inverse"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
            self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
            // 这样设置颜色会是蓝色
            //self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
            
            // 拉伸动画
            imgView.frame=CGRectMake(0+_tableView.contentOffset.y/2, 0+_tableView.contentOffset.y, 320-_tableView.contentOffset.y, 175-_tableView.contentOffset.y);
            
            self.navigationController.navigationBar.layer.borderColor =  [[UIColor colorWithRed:226/255.0
                                                                                          green:230/255.0 blue:232/255.0 alpha:1] CGColor];
            
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"2"] forBarMetrics:UIBarMetricsDefault];
            self.title = @"";
            NSLog(@"====1==%f",_tableView.contentOffset.y);
            
        }
        else{
            
            self.navigationController.navigationBar.translucent = YES;
            [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:(UIBarMetricsDefault)];
            
            //更改透明度
            self.navigationController.navigationBar.layer.opacity = fabsf(_tableView.contentOffset.y)/64.0;
            //[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHue:0.0 saturation:0.0 brightness:scrollView.contentOffset.y / 64.0 alpha:0.5]];
            
            contentView.frame = CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40);
            
            self.title = _model.position;
            
            self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"details_top_blue_back_normal"]];
            self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"details_top_blue_back_normal"] ;
        }
        
        
    }
    
    
    
}

- (void)dealloc
{
    [_tableView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)addPageControl
{
    _pageCtl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, (pageView.frame.size.height - 30)/2,60, 30)];
    _pageCtl.numberOfPages = _model.picShowArray.count - 1;
    _pageCtl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"details_zero_inverse"]];
    _pageCtl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"details_zero_normal"]];
    [pageView addSubview:_pageCtl];
}
- (void)autoShow
{
    [_scrollView setContentOffset:(CGPoint){_scrollView.frame.size.width *page,0} animated:YES];
    _pageCtl.currentPage = page;
    page++;
    if ( page > _model.picShowArray.count - 2) page = 0;
}
#if 1
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.navigationController.navigationBar.translucent = YES;
    
    contentView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 40, [UIScreen mainScreen].bounds.size.width, 40);
   
//    if (scrollView.contentOffset.y < 0)
//    {
//
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"details_top_white_back_inverse"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
//        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
//        // 这样设置颜色会是蓝色
//        //self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//        
//        // 拉伸动画
//        imgView.frame=CGRectMake(0+scrollView.contentOffset.y/2, 0+scrollView.contentOffset.y, 320-scrollView.contentOffset.y, 175-scrollView.contentOffset.y);
//       
//        self.navigationController.navigationBar.layer.borderColor =  [[UIColor colorWithRed:226/255.0
//                                                                                      green:230/255.0 blue:232/255.0 alpha:1] CGColor];
//        
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"2"] forBarMetrics:UIBarMetricsDefault];
//        self.title = @"";
//        NSLog(@"====1==%f",scrollView.contentOffset.y);
//        
//    }
//    
//    else
//    {
//       
//        self.navigationController.navigationBar.translucent = YES;
//        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:(UIBarMetricsDefault)];
//       
//        //更改透明度
//        self.navigationController.navigationBar.layer.opacity = abs(scrollView.contentOffset.y)/64.0;
//        //[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHue:0.0 saturation:0.0 brightness:scrollView.contentOffset.y / 64.0 alpha:0.5]];
//
//        contentView.frame = CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40);
//        
//        self.title = _model.position;
//        
//        self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"details_top_blue_back_normal"]];
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"details_top_blue_back_normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
//    }
    
}
#endif


//#ifdef _FOR_DEBUG_
//-(BOOL) respondsToSelector:(SEL)aSelector {
//    printf("SELECTOR: %sn", [NSStringFromSelector(aSelector) UTF8String]);
//    return [super respondsToSelector:aSelector];
//}
//#endif
//创建CGColorRef方法

+(CGColorRef) getColorFromRed:(int)red Green:(int)green Blue:(int)blue Alpha:(int)alpha
{
    CGFloat r = (CGFloat) red/255.0;
    CGFloat g = (CGFloat) green/255.0;
    CGFloat b = (CGFloat) blue/255.0;
    CGFloat a = (CGFloat) alpha/255.0;
    CGFloat components[4] = {r,g,b,a};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGColorRef color = (CGColorRef)CGColorCreate(colorSpace, components);
   
    
    return color;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.layer.opacity = 1.0;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:1.0 alpha:1.0];
}




@end
