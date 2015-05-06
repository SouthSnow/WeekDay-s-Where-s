//
//  ComtentCell.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/6.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "ComtentCell.h"
#import "UIImageView+WebCache.h"

#define kFont 12
@implementation ComtentCell
{
    
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
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,height +icon.frame.size.height + time.frame.size.height + 30);
}


- (NSString*)formatterDate:(NSString*)dateStr
{
    NSDate *date =[NSDate dateWithTimeIntervalSince1970:dateStr.intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
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
