//
//  DetailTableViewCell.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/2.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface DetailTableViewCell ()
{
    
    UIPageControl *_pageCtl;
    int page;
}
@end
@implementation DetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)setModel:(StoryModel *)model
{
//    showScroll.contentSize = CGSizeMake((model.picShowArray.count - 1)*showScroll.frame.size.width, 0);
//    for (int i = 0; i < model.picShowArray.count - 1; i++) {
//        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(showScroll.frame.size.width * i, 0, showScroll.frame.size.width, showScroll.frame.size.height)];
//        [imgView setImageWithURL:[NSURL URLWithString:model.picShowArray[i+1]] placeholderImage:nil];
//        [showScroll addSubview:imgView];
//    }
//    NSLog(@"=======x =%f======count = %d",showScroll.contentSize.width,model.picShowArray.count);
//    
//    _pageCtl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, showScroll.frame.size.width, 30)];
//    _pageCtl.numberOfPages = model.picShowArray.count - 1;
//    titleLabel.text = model.title;
//    titleLabel.textColor = [UIColor whiteColor];
//    
//    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoShow) userInfo:nil repeats:YES];
    
    
    
    
}

//- (void)autoShow
//{
//    [showScroll setContentOffset:(CGPoint){showScroll.frame.size.width *page,0} animated:YES];
//    _pageCtl.currentPage = page;
//    page++;
//    if ( page > 2) page = 0;
//}



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
