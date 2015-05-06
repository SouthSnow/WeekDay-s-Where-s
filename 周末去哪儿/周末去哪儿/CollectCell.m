//
//  CollectCell.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/10.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "CollectCell.h"
#import "User.h"
#import "UserData.h"
#import "StoryModel.h"
#import "UIImageView+WebCache.h"


@implementation CollectCell
{
    __weak IBOutlet UIImageView *iconView;
    __weak IBOutlet UILabel *nick;
    __weak IBOutlet UILabel *recommend;
    __weak IBOutlet UIView *activity;
    
    __weak IBOutlet UIImageView *kindIcon;
    __weak IBOutlet UILabel *time;
    __weak IBOutlet UILabel *actTitle;
    __weak IBOutlet UIImageView *activityView;
    CategoryActivity *act;
    AppDelegate *dele;
}

- (void)setUser
{
    act = [CategoryActivity shareCategory];
    dele = [UIApplication sharedApplication].delegate;
    NSArray *arrIcon = @[@"ico_avatar_collect",@"ico_avatar_like",@"ico_btn_good_yellow"];
    
    if (dele.trendsArray.count)
    {
        
        for (int i = 0; i < dele.trendsArray.count; i++)
        {
            StoryModel *model = dele.trendsArray[i];
            _user = act.userData[0];
            nick.text = _user.userNick;
            nick.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
            if (!_user.userIcon.length) {
                iconView.image = [UIImage imageNamed:@"avatardefault"];
            }
            else
            {
                 iconView.image = [UIImage imageNamed:_user.userIcon];
            }
            actTitle.text = model.title;
            NSLog(@"title=====%@",actTitle.text);
          [activityView setImageWithURL:[NSURL URLWithString:model.picShowArray[0]] placeholderImage:[UIImage imageNamed:nil]];
            time.text = [self formatterDate:model.showTime];
            recommend.text = @"推荐了地点";
            recommend.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
            kindIcon.image = [UIImage imageNamed:arrIcon[0]];
            
        }
    }
    
    
    
}

- (NSString*)formatterDate:(NSString*)dateStr
{
    NSDate *date =[NSDate dateWithTimeIntervalSinceNow:dateStr.intValue];
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
