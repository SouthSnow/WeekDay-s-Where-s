//
//  ActivityCell.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/3.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "ActivityCell.h"
#import "UIImageView+WebCache.h"

@implementation ActivityCell
{
    __weak IBOutlet UIImageView *showView;
    
    __weak IBOutlet UILabel *bodyLabel;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *positionLabel;
}

- (IBAction)btn:(UIButton *)sender
{
    
    
}

- (void)setModel:(ActivityModel *)model
{
    _model = model;
    [showView setImageWithURL:[NSURL URLWithString:_model.activity_pic_h5list] placeholderImage:nil];
    showView.alpha = .8;
    titleLabel.text = _model.activityTitle;
    NSLog(@"title = %@",_model.activityTitle);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    positionLabel.text = [NSString stringWithFormat:@"%@,%@",_model.activity_address,_model.distance_show];
    [positionLabel setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]]];
    positionLabel.font = [UIFont systemFontOfSize:12];
    bodyLabel.numberOfLines = 0;
    bodyLabel.textColor = [UIColor grayColor];
    bodyLabel.font = [UIFont systemFontOfSize:15];
    bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self setHeight:_model.introdution];
}

- (void)setHeight:(NSString *)text
{
    CGFloat height;
    bodyLabel.text = text;
    
    CGFloat verSion = [[UIDevice currentDevice].systemVersion floatValue];
    if (verSion >= 7.0)
    {
        height = [bodyLabel.text boundingRectWithSize:CGSizeMake(300, 2999) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil].size.height;
    }
    else
    {
        height = [bodyLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}].height;
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, showView.frame.size.height + titleLabel.frame.size.height + height);
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
