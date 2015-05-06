//
//  TwoCell.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/3.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "TwoCell.h"
#import "UIImageView+WebCache.h"

@implementation TwoCell
{
    __weak IBOutlet UIImageView *showView;
    
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *bodyLabel;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UIView *view;
}

- (void)setModel:(StoryModel *)model
{
    _model = model;
    titleLabel.text = _model.title;
    dateLabel.text = _model.start_time_show;
    [self setHeight:_model.introdution];
    bodyLabel.numberOfLines = 0;
    bodyLabel.textColor = [UIColor grayColor];
    bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [showView setImageWithURL:[NSURL URLWithString:_model.picShowArray[0]] placeholderImage:nil];
}

- (void)setHeight:(NSString *)text
{
    CGFloat height;
    bodyLabel.text = text;
    
    CGFloat verSion = [[UIDevice currentDevice].systemVersion floatValue];
    if (verSion >= 7.0)
    {
       height = [text boundingRectWithSize:CGSizeMake(300, 2999) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size.height;
    }
    else
    {
        height = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}].height;
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, showView.frame.size.height + titleLabel.frame.size.height + height + 20);
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
