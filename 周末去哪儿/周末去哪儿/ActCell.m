//
//  ActCell.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/6.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "ActCell.h"
#import "UIImageView+WebCache.h"
#import "PoiViewController.h"

#define kFont 12
@implementation ActCell
{
    __weak IBOutlet UIView *actPlaceView;
    
    __weak IBOutlet UIImageView *typeView;
    __weak IBOutlet UILabel *actPlaceLabel;
    __weak IBOutlet UIImageView *placeImgView;
    __weak IBOutlet UIImageView *icon;
    
    __weak IBOutlet UILabel *time;
    __weak IBOutlet UILabel *name;
    
    __weak IBOutlet UILabel *reply;
    __weak IBOutlet UILabel *body;
    __weak IBOutlet UILabel *place;
    
    __weak IBOutlet UILabel *agree;
}

- (void)setUser:(User *)user
{
    _user = user;
    CategoryActivity *activity = [CategoryActivity shareCategory];
    [placeImgView setImageWithURL:[NSURL URLWithString:activity.picUrl] placeholderImage:[UIImage imageNamed:@"default_photo_trends"]];
    actPlaceLabel.text = activity.actPlace;
    body.text = user.content;
    reply.text = [NSString stringWithFormat:@"%d回复",user.replyNum.intValue];
    agree.text = [NSString stringWithFormat:@"%d赞同",user.agreeNum.intValue];
    time.text = [self formatterDate:user.createTime];
    name.text = user.userNick;
    name.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
    body.font = [UIFont systemFontOfSize:kFont];
    time.font = [UIFont systemFontOfSize:kFont];
    reply.font = [UIFont systemFontOfSize:kFont];
    agree.font = [UIFont systemFontOfSize:kFont];
    name.font = [UIFont systemFontOfSize:kFont + 2];
    place.font = [UIFont systemFontOfSize:kFont + 2];
    
    body.numberOfLines = 0;
    body.lineBreakMode = NSLineBreakByWordWrapping;
    place.textColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0];
    time.textColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0];
    reply.textColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0];
    agree.textColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0];
    
    [icon setImageWithURL:[NSURL URLWithString:user.userIcon] placeholderImage:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myTap:)];
    placeImgView.userInteractionEnabled = YES;
    [placeImgView addGestureRecognizer:tap];
    
    CGFloat height;
    CGFloat verSion = [[UIDevice currentDevice].systemVersion floatValue];
    if (verSion >= 7.0)
    {
        height = [body.text boundingRectWithSize:CGSizeMake(body.frame.size.width, 2999) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: body.font} context:nil].size.height;
    }
    else
    {
        height = [body.text sizeWithAttributes:@{NSFontAttributeName:body.font}].height;
    }
    body.frame = CGRectMake(body.frame.origin.x, body.frame.origin.y, body.frame.size.width, height);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,time.frame.size.height + time.frame.origin.y);
}

- (void)myTap:(UITapGestureRecognizer*)tap
{
   
   
}

- (void)setUserData:(UserData *)userData
{
    NSArray *array = @[@"details_recommend",@"ico_avatar_collect",@"ico_avatar_like"];
    NSArray *type = @[@"act_comment",@"poi_attent",@"act_join"];
    NSArray *text = @[@"推荐了活动",@"关注了地点",@"收藏了活动"];
    for (int i = 0; i < array.count; i++)
    {
        if ([userData.userType isEqual:type[i]])
        {
            typeView.image = [UIImage imageNamed:array[i]];
            place.text = text[i];
        }
    }
   
    body.text = userData.userContent;
    reply.text = [NSString stringWithFormat:@"%d回复",userData.userReplyNum.intValue];
    time.text = [self formatterDate:userData.userCreateTime];
    name.text = userData.userNick;
    name.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
    body.font = [UIFont systemFontOfSize:kFont];
    time.font = [UIFont systemFontOfSize:kFont];
    reply.font = [UIFont systemFontOfSize:kFont];
    agree.font = [UIFont systemFontOfSize:kFont];
    name.font = [UIFont systemFontOfSize:kFont + 2];

    place.font = [UIFont systemFontOfSize:kFont + 2];
    [placeImgView setImageWithURL:[NSURL URLWithString:userData.targetPic] placeholderImage:nil];
    actPlaceLabel.text = userData.userActivity;
    actPlaceLabel.font = [UIFont systemFontOfSize:kFont];
    body.numberOfLines = 0;
    body.lineBreakMode = NSLineBreakByWordWrapping;
    place.textColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0];
    time.textColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0];
    reply.textColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0];
    agree.textColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0];
    if (userData.userIcon.length != 0) {
        [icon setImageWithURL:[NSURL URLWithString:userData.userIcon] placeholderImage:nil];
    }
    else
        icon.image = [UIImage imageNamed:@"avatardefault"];
    
        
    
    
    CGFloat height;
    CGFloat verSion = [[UIDevice currentDevice].systemVersion floatValue];
    if (verSion >= 7.0)
    {
        height = [body.text boundingRectWithSize:CGSizeMake(body.frame.size.width, 2999) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: body.font} context:nil].size.height;
    }
    else
    {
        height = [body.text sizeWithAttributes:@{NSFontAttributeName:body.font}].height;
    }
    body.frame = CGRectMake(body.frame.origin.x, body.frame.origin.y, body.frame.size.width, height);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,time.frame.size.height + time.frame.origin.y);
}

- (NSString*)formatterDate:(NSString*)dateStr
{
    NSDate *date =[NSDate dateWithTimeIntervalSince1970:dateStr.intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd hh:mm";
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
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
