//
//  TableViewCell.m
//  PPRevealSliderDemo1
//
//  Created by pangfuli on 14/9/1.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "ThreeCell.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

#define kTextFont 15
#define kSubTextFont 10

@implementation ThreeCell
{
    __weak IBOutlet UIView *showView;
    
    __weak IBOutlet UIButton *btn;
    __weak IBOutlet UIImageView *segmentView;
    __weak IBOutlet UIButton *favBtn;
    __weak IBOutlet UIImageView *pisitionView;
    __weak IBOutlet UILabel *pisitionLabel;
    __weak IBOutlet UIImageView *markView;
    __weak IBOutlet UILabel *markLabel;
    __weak IBOutlet UIImageView *imgView;
   
    __weak IBOutlet UILabel *distanceLabel;
    __weak IBOutlet UILabel *title;

    __weak IBOutlet UILabel *subTitle;
}

- (IBAction)btn:(UIButton *)sender
{   AppDelegate *dele = [UIApplication sharedApplication].delegate;
    
    if ([[sender imageForState:(UIControlStateNormal)] isEqual:[UIImage imageNamed:@"like_inverse"]]) {
        [sender setImage:[UIImage imageNamed:@"like_normal"] forState:UIControlStateNormal];
        [dele.selectedArray removeLastObject];
        
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"like_inverse"] forState:UIControlStateNormal];
        [dele.selectedArray addObject:_model];
//        
//        NSLog(@"count = %d",dele.selectedArray.count);
    }
    
}

- (void)setModel:(StoryModel *)model
{
    _model = model;
    [favBtn setImage:[UIImage imageNamed:@"like_inverse"] forState:UIControlStateNormal];
    [imgView setImageWithURL:[NSURL URLWithString:model.picShowArray[0]] placeholderImage:nil];
    
    [title setTextColor:[UIColor whiteColor]];
    title.font = [UIFont systemFontOfSize:kTextFont];
    pisitionLabel.text = model.position;
    [pisitionLabel setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]]];
    pisitionLabel.font = [UIFont systemFontOfSize:kSubTextFont];
    [markLabel setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]]];
    markLabel.font = [UIFont systemFontOfSize:kSubTextFont];
    markLabel.text = model.genre_main_show;
    distanceLabel.text = model.distance_show;
    [distanceLabel setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]]];
    distanceLabel.font = [UIFont systemFontOfSize:kSubTextFont];
    subTitle.font = [UIFont systemFontOfSize:kTextFont];
    subTitle.textColor = [UIColor whiteColor];
    if (model.title_vice.length == 0)
    {
        title.hidden = YES;
        subTitle.text = model.title;
    }else
    {
        title.text = model.title;
        subTitle.text = model.title_vice;
    }
    
    
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
