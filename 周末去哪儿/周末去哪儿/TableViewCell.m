//
//  TableViewCell.m
//  PPRevealSliderDemo1
//
//  Created by pangfuli on 14/9/1.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "TableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "LoginController.h"
#import "AFHTTPRequestOperation.h"

#define kTextFont 15
#define kSubTextFont 10

@implementation TableViewCell
{
    __weak IBOutlet UIView *showView;
    
    
    __weak IBOutlet UILabel *annimationLabel;
    __weak IBOutlet UIImageView *segmentView;

    __weak IBOutlet UIImageView *pisitionView;
    __weak IBOutlet UILabel *pisitionLabel;
    __weak IBOutlet UIImageView *markView;
    __weak IBOutlet UILabel *markLabel;
    __weak IBOutlet UIImageView *imgView;
   
    __weak IBOutlet UILabel *distanceLabel;
    __weak IBOutlet UILabel *title;

    __weak IBOutlet UILabel *subTitle;
    AppDelegate *dele;
}
- (NSString *)timestamp
{
    NSDate *date = [NSDate date];
    NSTimeInterval timestamp = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%lld",(long long)timestamp];
}
- (IBAction)btn:(UIButton *)sender
{
    if ([dele.loginStatus isEqualToString:@"success"])
    {
        if (_model.isFollow.intValue == 1) {
            [sender setImage:[UIImage imageNamed:@"like_normal"] forState:UIControlStateNormal];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&activity_id=%@&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&method=activity.follow&os=iphone&r=wanzhoumo&sign=98bba8fb2f312e856286c5c2a30a7f0b&timestamp=%@&top_session=4umjf9imft713s4s7skjurv0a0&v=2.0",@"12110",[self timestamp]]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
            [operation start];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
              
               __unused NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
               
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error");
            }];
            
            
         
        }
        else
        {
            
             NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.wanzhoumo.com/wanzhoumo?UUID=97B42FCB-7D7A-4D41-A80B-24644CBEE429&activity_id=%@&app_key=800000002&app_v_code=12&app_v_name=2.2.1&format=json&method=activity.follow&os=iphone&r=wanzhoumo&sign=f2cc7989dc732cdf0e963ffdb8775fb9&timestamp=%@&top_session=4umjf9imft713s4s7skjurv0a0&v=2.0",_model.sID,[self timestamp]]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
            [operation start];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                
            __unused NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
               
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error");
            }];
            
            [sender setImage:[UIImage imageNamed:@"like_inverse"] forState:UIControlStateNormal];
   
           
        }
        
        CGRect frame = annimationLabel.frame;
        [UIView animateWithDuration:2.0f animations:^{
            annimationLabel.font = [UIFont systemFontOfSize:12];
            annimationLabel.backgroundColor = [UIColor lightGrayColor];
            CGRect rect = annimationLabel.frame;
            rect.origin.x -= 120;
            rect.size.width += 120;
            annimationLabel.frame  = rect;
            annimationLabel.text = [NSString stringWithFormat:@"你是第%d个收藏的人",_model.follow_num.intValue + 1];
            
        } completion:^(BOOL finished) {
          
            annimationLabel.frame = frame;
        }];
        
 
    }
    else
    {
       
        
    }
    
}

- (void)setModel:(StoryModel *)model
{
    dele = [UIApplication sharedApplication].delegate;
    _model = model;
     if ([dele.loginStatus isEqualToString:@"success"])
     {
        
        
        if (model.isFollow.intValue == 1) {
            [_favBtn setImage:[UIImage imageNamed:@"like_inverse"] forState:UIControlStateNormal];
            NSLog(@"=======%d",model.isFollow.intValue);
        }
        else
        {
            [_favBtn setImage:[UIImage imageNamed:@"like_normal"] forState:UIControlStateNormal];
        }
     }
    else
    {
        [_favBtn setImage:[UIImage imageNamed:@"like_normal"] forState:UIControlStateNormal];
        
    }
    
    if (dele.error) {
         imgView.image = [UIImage imageWithData:model.facePic];
    }
    else{
        [imgView setImageWithURL:[NSURL URLWithString:model.face] placeholderImage:nil];
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            
//            UIImage *thumbImage;
//            
//            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.face]]];
//            float scale = [UIScreen mainScreen].scale;
//            UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, scale);
//            [image drawInRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
//            thumbImage = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.imageView.image = thumbImage;
//            });
//        });
        
    }
   
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
        title.hidden = NO;
        title.text = model.title;
        subTitle.text = model.title_vice;
    }
    
    
}

- (void)setAct:(Activity *)act
{
    dele = [UIApplication sharedApplication].delegate;
    _act = act;
    if ([dele.loginStatus isEqualToString:@"success"])
    {
        
        
        if (act.isFollow.intValue == 1) {
            [_favBtn setImage:[UIImage imageNamed:@"like_inverse"] forState:UIControlStateNormal];
            NSLog(@"=======%d",act.isFollow.intValue);
        }
        else
        {
            [_favBtn setImage:[UIImage imageNamed:@"like_normal"] forState:UIControlStateNormal];
        }
    }
    else
    {
        [_favBtn setImage:[UIImage imageNamed:@"like_normal"] forState:UIControlStateNormal];
        
    }
    [imgView setImageWithURL:[NSURL URLWithString:act.picShowArray[0]] placeholderImage:nil];
    
    [title setTextColor:[UIColor whiteColor]];
    title.font = [UIFont systemFontOfSize:kTextFont];
    pisitionLabel.text = act.activityPoiName;
    [pisitionLabel setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]]];
    pisitionLabel.font = [UIFont systemFontOfSize:kSubTextFont];
    [markLabel setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]]];
    markLabel.font = [UIFont systemFontOfSize:kSubTextFont];
    markLabel.text = act.genre_main_show;
    distanceLabel.text = act.distance_show;
    [distanceLabel setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]]];
    distanceLabel.font = [UIFont systemFontOfSize:kSubTextFont];
    subTitle.font = [UIFont systemFontOfSize:kTextFont];
    subTitle.textColor = [UIColor whiteColor];
    if (act.title_vice.length == 0)
    {
        title.hidden = YES;
        subTitle.text = act.title;
    }else
    {
        title.hidden = NO;
        title.text = act.title;
        subTitle.text = act.title_vice;
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
