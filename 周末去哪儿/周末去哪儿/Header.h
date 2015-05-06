//
//  Header.h
//  周末去哪儿
//
//  Created by pangfuli on 14/9/3.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#ifndef ______Header_h
#define ______Header_h

http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&id=103&lat=22.534790&lon=113.944979&method=topic.detail&os=iphone&pagesize=20&r=wanzhoumo&sign=5d3a55862505b0cbf5729245ad194864&timestamp=1409725165&top_session=pqr2e1q3skdqiinui7vddbvbn5&v=2.0
http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&id=103&lat=22.562437&lon=113.904369&method=topic.detail&os=iphone&pagesize=20&r=wanzhoumo&sign=24eeedaa50dc054331d280d936c58ac7&timestamp=1409706326&top_session=u96eu235ali11gaf2u3g9csh32&v=2.0
#endif
lat=22.534790
on=113.944979
sign=5d3a55862505b0cbf5729245ad194864
lat=22.562437
lon=113.904369
sign=24eeedaa50dc054331d280d936c58ac7


http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&lat=22.534790&lon=113.944979&method=topic.list&os=iphone&pagesize=20&r=wanzhoumo&sign=89ce9db267b9bf3ffdabbe05e1ea19c9&timestamp=1409727070&top_session=pqr2e1q3skdqiinui7vddbvbn5&v=2.0
http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&lat=22.534790&lon=113.944979&method=topic.list&os=iphone&pagesize=20&r=wanzhoumo&sign=658810e09ee0cfb175e923f3f597af48&timestamp=1409727102&top_session=pqr2e1q3skdqiinui7vddbvbn5&v=2.0
http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&lat=22.534790&lon=113.944979&method=topic.list&os=iphone&pagesize=20&r=wanzhoumo&sign=6d4ecf481d94f7f334f8dca52ef72cd1&timestamp=1409727236&top_session=pqr2e1q3skdqiinui7vddbvbn5&v=2.0

http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&is_near=1&is_valid=1&lat=22.534790&lon=113.944979&method=activity.List&offset=60&os=iphone&pagesize=30&r=wanzhoumo&sign=9be167d1d5f95d7182ab67260804bdda&sort=distance&timestamp=1409743247&top_session=pqr2e1q3skdqiinui7vddbvbn5&v=2.0

http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&is_near=1&is_valid=1&lat=22.534790&lon=113.944979&method=activity.List&offset=90&os=iphone&pagesize=30&r=wanzhoumo&sign=852cbbd7705352641c01d4259fcf73c7&sort=distance&timestamp=1409743359&top_session=pqr2e1q3skdqiinui7vddbvbn5&v=2.0

- (void)setData
{
    _cell.titleLabel.textColor = [UIColor whiteColor];
    _cell.praiseLabel.text = [NSString stringWithFormat:@"%@人收藏",_model.follow_num];
    _cell.titleLabel.text = _model.title;
    _cell.positionLabel.font = [UIFont systemFontOfSize:10];
    _cell.distanceLabel.font = [UIFont systemFontOfSize:10];
    _cell.distanceLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
    _cell.positionLabel.text = _model.address;
    _cell.distanceLabel.text = _model.distance_show;
    _cell.showScroll.contentSize = CGSizeMake((_model.picShowArray.count - 1)*_cell.showScroll.frame.size.width, 0);
    _cell.showScroll.scrollEnabled = YES;
    for (int i = 0; i < _model.picShowArray.count - 1; i++)
    {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(_cell.showScroll.frame.size.width * i, 0, _cell.showScroll.frame.size.width, _cell.showScroll.frame.size.height)];
        [imgView setImageWithURL:[NSURL URLWithString:_model.picShowArray[i+1]] placeholderImage:nil];
        [_cell.showScroll addSubview:imgView];
    }
    NSLog(@"=======x =%f======count = %lu",_cell.showScroll.contentSize.width,(unsigned long)_model.picShowArray.count);
    [self addPageControl];
    
    
    
    
    
    // NSTimer *_timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoShow) userInfo:nil repeats:YES];
    
    
}
#if 0
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        headerView = [[UIView alloc] initWithFrame:CGRectZero];
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 250)];
        _scrollView.contentSize = CGSizeMake((_model.picShowArray.count - 1)*_scrollView.frame.size.width, 0);
        _scrollView.backgroundColor = [UIColor redColor];
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        for (int i = 0; i < _model.picShowArray.count - 1; i++)
        {
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width * i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
            [imgView setImageWithURL:[NSURL URLWithString:_model.picShowArray[i+1]] placeholderImage:[UIImage imageNamed:@"picture_default_350"]];
            [_scrollView addSubview:imgView];
        }
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoShow) userInfo:nil repeats:YES];
        
        pageView = [[UIView alloc]initWithFrame:CGRectMake(0, _scrollView.frame.size.height, self.view.frame.size.width, 44)];
        pageView.backgroundColor = [UIColor clearColor];
        [self addPageControl];
        
        
        UIImageView *praiseView = [[UIImageView alloc]initWithFrame:CGRectMake(230, (pageView.frame.size.height - 15)/2, 14, 15)];
        praiseView.image = [UIImage imageNamed:@"ico_like_normal_little"];
        UILabel *praiseLabel = [[UILabel alloc]initWithFrame:CGRectMake(praiseView.frame.origin.x + praiseView.frame.size.width + 3,0,80, pageView.frame.size.height)];
        praiseLabel.text = [NSString stringWithFormat:@"%@人收藏",_model.follow_num];
        praiseLabel.textColor = [UIColor grayColor];
        praiseLabel.font = [UIFont systemFontOfSize:11];
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 190+30, self.view.frame.size.width - 20, 30)];
        title.text = _model.title;
        title.textColor = [UIColor whiteColor];
        title.font = [UIFont systemFontOfSize:15];
        UILabel *subTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, title.frame.origin.y + title.frame.size.height + 10, self.view.frame.size.width, 30)];
        subTitle.textColor = [UIColor whiteColor];
        subTitle.font = [UIFont systemFontOfSize:13];
        
        [pageView addSubview:praiseLabel];
        [pageView addSubview:praiseView];
        [headerView addSubview:_scrollView];
        [headerView addSubview:pageView];
        [headerView addSubview:title];
        [headerView addSubview:subTitle];
        [pageView addSubview:praiseView];
        headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, _scrollView.frame.size.height + pageView.frame.size.height);
        NSLog(@"height = %f",headerView.frame.size.height);
        return headerView;
    }
    return nil;
}


#endif
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].textLabel.backgroundColor=[UIColor blueColor];
}



- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView cellForRowAtIndexPath:indexPath].textLabel.backgroundColor=[UIColor whiteColor];
    
}
int width = 49;
int height = 49;
int gap = 49;
int index = 0;
for (int i = 0; i < 4; i++)
{
    for (int j = 0; j < 3; j++)
    {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(gap*(j+1)+ width*j , gap *(i + 1) + height * i, 49, 49)];
        
        [btn setTitle:title[index++] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:9.5];
        [btn setImage:[UIImage imageNamed:@"102"] forState:(UIControlStateSelected)];
        [btn setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"101"] forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(30, -12, 0, 12)];
        [btn setImageEdgeInsets:(UIEdgeInsetsMake(5, 20, 20, 20))];
        
        //[self.view addSubview:btn];
    }
}
- (void)addArray:(NSString *)text WithModel:(StoryModel*)model
{
    
    [activity.allArray addObject:model];
    
    if ([@"热门" rangeOfString:text].location != NSNotFound)
    {
        [activity.hotArray addObject:model];
    }
    else if ([@"周边游"rangeOfString:text].location != NSNotFound)
    {
        [activity.roundArray addObject:model];
        
    }
    else if ([@"田园" rangeOfString:text].location != NSNotFound)
    {
        [activity.countryArray addObject:model];
        
    }
    else if ([@"展览" rangeOfString:text].location != NSNotFound)
    {
        [activity.showArray addObject:model];
        
    }
    else if ([@"音乐" rangeOfString:text].location != NSNotFound)
    {
        [activity.muiscArray addObject:model];
        
    }
    else if ([@"戏剧" rangeOfString:text].location != NSNotFound)
    {
        [activity.operaArray addObject:model];
        
    }
    else if ([@"聚会" rangeOfString:text].location != NSNotFound)
    {
        [activity.partyArray addObject:model];
        
    }
    else if ([@"亲子" rangeOfString:text].location != NSNotFound)
    {
        [activity.familyArray addObject:model];
    }
    else if ([@"约会" rangeOfString:text].location != NSNotFound)
    {
        [activity.meetingArray addObject:model];
        
    }
    else if ([@"文艺" rangeOfString:text].location != NSNotFound)
    {
        [activity.artArray addObject:model];
        
    }
    else if ([@"赏秋" rangeOfString:text].location != NSNotFound)
    {
        [activity.automdArray addObject:model];
        
    }
    
    
}

#pragma 日期转化
- (NSString*)backDate:(NSString*)date
{
    NSDate *now1 =[NSDate dateWithTimeIntervalSince1970:0];
    NSDate *now =[NSDate dateWithTimeIntervalSince1970:1406093054];
    NSLog(@"%@",now);
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSUInteger unitInteger = NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents *components = [calender components:unitInteger fromDate:now1 toDate:now options:NSCalendarWrapComponents];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSString *ymdDate = [NSString stringWithFormat:@"%lu-%lu-%lu",year,month,day];
    return ymdDate;
}
