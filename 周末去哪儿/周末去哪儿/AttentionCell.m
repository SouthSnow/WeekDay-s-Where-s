//
//  AttentionCell.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/13.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "AttentionCell.h"
#import "UIImageView+WebCache.h"

@implementation AttentionCell
{
    __weak IBOutlet UILabel *fans;
    __weak IBOutlet UILabel *activity;
    __weak IBOutlet UIImageView *imgView;
    __weak IBOutlet UILabel *city;
    
    __weak IBOutlet UILabel *attention;
    __weak IBOutlet UIView *listView;
    __weak IBOutlet UILabel *title;
}

- (void)setData:(UserData *)data
{
    
    fans.text = [NSString stringWithFormat:@"%d粉丝",data.fllowNum.intValue];
    fans.font = [UIFont systemFontOfSize:12];
    fans.textAlignment = NSTextAlignmentCenter;
    fans.textColor = [UIColor lightGrayColor];
    
    activity.text = [NSString stringWithFormat:@"%d活动",data.activityNum.intValue];
    activity.font = [UIFont systemFontOfSize:12];
    activity.textAlignment = NSTextAlignmentCenter;
    activity.textColor = [UIColor lightGrayColor];
    
    city.text = data.city;
    city.font = [UIFont systemFontOfSize:12];
    city.textAlignment = NSTextAlignmentCenter;
    city.textColor = [UIColor lightGrayColor];
    
    title.text = data.title;
    title.font = [UIFont systemFontOfSize:13];
    title.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
   
    
    attention.text = @"已关注";
    attention.font = [UIFont systemFontOfSize:12];
    attention.textColor = [UIColor whiteColor];
    attention.textAlignment = NSTextAlignmentCenter;
    
    imgView.layer.cornerRadius = imgView.frame.size.width / 2;
    imgView.clipsToBounds = YES;
    [imgView setImageWithURL:[NSURL URLWithString:data.userCommentlistArray[0]] placeholderImage:nil];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
