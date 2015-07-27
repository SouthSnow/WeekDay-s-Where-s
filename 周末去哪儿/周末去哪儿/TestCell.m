//
//  TestCell.m
//  周末去哪儿
//
//  Created by pangfuli on 14-9-24.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "TestCell.h"



@implementation TestCell
{
    
    __weak IBOutlet UILabel *bodyLabel;
    
}


- (void)setHeight:(NSString *)string
{
    CGFloat height;
    bodyLabel.text = string;
    bodyLabel.font = [UIFont systemFontOfSize:14];
    bodyLabel.numberOfLines = 0;
    bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    bodyLabel.textColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0];
    
    CGFloat verSion = [[UIDevice currentDevice].systemVersion floatValue];
    if (verSion >= 7.0)
    {
        height = [string boundingRectWithSize:CGSizeMake(300, 2999) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: bodyLabel.font} context:nil].size.height;
    }
    else
    {
       height = [string sizeWithFont:bodyLabel.font constrainedToSize:CGSizeMake(300, 2999)].height;
        
    }
    bodyLabel.frame = CGRectMake(bodyLabel.frame.origin.x, bodyLabel.frame.origin.y, bodyLabel.frame.size.width, height);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,height + 20);
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