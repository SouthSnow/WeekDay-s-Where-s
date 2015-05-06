//
//  TelCell.m
//  周末去哪儿
//
//  Created by dongbailan on 14-9-14.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "TelCell.h"

@implementation TelCell



- (void)awakeFromNib
{
    // Initialization code
    
    
    
    
}

- (void)layoutSubviews
{
    CGFloat version = [UIDevice currentDevice].systemVersion.floatValue;
    CGFloat width;
    if (version >= 7.0) {
        width = [_tel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}].width;
    }
    else
    {
        width = [_tel.text sizeWithFont:_tel.font].width;
    }
    
    CGRect rect = _underLine.frame;
    rect.size.width = width;
    self.underLine.frame = rect;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
