//
//  DetailCell2.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/4.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "DetailCell2.h"



@implementation DetailCell2
{
    __weak IBOutlet UILabel *bodyLabel;
    CGFloat _height;
    UILabel *label;
}


- (void)setHeight:(NSString *)string
{
//    CGFloat height;
//    bodyLabel.text = string;
//    bodyLabel.font = [UIFont systemFontOfSize:14];
//    bodyLabel.numberOfLines = 0;
//    bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    bodyLabel.textColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0];
//    
//    CGFloat verSion = [[UIDevice currentDevice].systemVersion floatValue];
//    if (verSion >= 7.0)
//    {
//        height = [bodyLabel.text boundingRectWithSize:CGSizeMake(300, 2999) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: bodyLabel.font} context:nil].size.height;
//    }
//    else
//    {
//        [bodyLabel.text sizeWithFont:bodyLabel.font constrainedToSize:CGSizeMake(300, 2999)];
//        
//    }
//    bodyLabel.frame = CGRectMake(bodyLabel.frame.origin.x, bodyLabel.frame.origin.y, bodyLabel.frame.size.width, height);
//    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,height + 20);
 
    
}

- (void)setDetailString:(NSString *)detailString
{
    _detailString = detailString;
////    
//    bodyLabel.text = detailString;
//    bodyLabel.font = [UIFont systemFontOfSize:14];
//    bodyLabel.numberOfLines = 0;
//    bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    bodyLabel.textColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0];
//    
//    CGFloat height = 0;
//    
//    CGFloat verSion = [[UIDevice currentDevice].systemVersion floatValue];
//    if (verSion >= 7.0)
//    {
//        height = [bodyLabel.text boundingRectWithSize:CGSizeMake(300, 2999) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: bodyLabel.font} context:nil].size.height;
//    }
//    else
//    {
//       height = [bodyLabel.text sizeWithFont:bodyLabel.font constrainedToSize:CGSizeMake(300, 2999)].height;
//        
//    }
//    
//    CGRect bodyFrame = bodyLabel.frame;
//    bodyFrame.size.height = CGRectGetMaxY(bodyFrame) + height;
//    bodyLabel.frame = bodyFrame;
////    bodyLabel.backgroundColor = [UIColor redColor];
//
//
//    CGRect rect = self.frame;
//    rect.size.height = CGRectGetMaxY(bodyLabel.frame) + 10;
//    self.frame = rect;
//
//    NSLog(@"height = %f",height);
    
}



- (void)layoutSubviews
{
    
    CGFloat height;
    
    bodyLabel.text = self.detailString;
    bodyLabel.font = [UIFont systemFontOfSize:14];
    bodyLabel.numberOfLines = 12;
    bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    bodyLabel.textColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0];
    
    CGFloat verSion = [[UIDevice currentDevice].systemVersion floatValue];
    if (verSion >= 7.0)
    {
        height = [bodyLabel.text boundingRectWithSize:CGSizeMake(300, 2999) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: bodyLabel.font} context:nil].size.height;
    }
    else
    {
       height = [bodyLabel.text sizeWithFont:bodyLabel.font constrainedToSize:CGSizeMake(300, 2999)].height;
        
    }
    
    CGRect bodyFrame = bodyLabel.frame;
    bodyFrame.size.height = CGRectGetMaxY(bodyFrame) + height;
    bodyLabel.frame = bodyFrame;
    bodyLabel.backgroundColor = [UIColor redColor];

    
    CGRect rect = self.frame;
    rect.size.height = CGRectGetMaxY(bodyLabel.frame) + 10;
    self.frame = rect;
    
    NSLog(@"height = %f",height);

    
    
//    CGFloat height;
////    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 44)];
//    label.text = @"其实不管你是用IB还是用手写代码生成界面，viewDidLoad都会被调用的，我们可以这么认为，它就是loadView的后续处理，比如用来初始化一些界面元素或者注册其实不管你是用IB还是用手写代码生成界面，viewDidLoad都会被调用的，我们可以这么认为，它就是loadView的后续处理，比如用来初始化一些界面元素或者注册一些系统通其实不管你是用IB还是用手写代码生成界面，viewDidLoad都会被调用的，我们可以这么认为，它就是loadView的后续处理，比如用来初始化一些界面元素或者注册一些系统通一些系统通";
//    label.font = [UIFont systemFontOfSize:14];
//    [self addSubview:label];
    
//    label.text = self.detailString;
//    CGFloat verSion = [[UIDevice currentDevice].systemVersion floatValue];
//    if (verSion >= 7.0)
//    {
//        height = [label.text boundingRectWithSize:CGSizeMake(300, 2999) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: label.font} context:nil].size.height;
//    }
//    else
//    {
//        [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(300, 2999)];
//        
//    }
//    
//    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, height);
//    
//    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,label.frame.size.height + 20);
    
    _cellHeight = height+20;
}

#if 0

- (void)awakeFromNib
{
    // Initialization code
    
    CGFloat height;
    bodyLabel.frame = CGRectMake(10, 10, 300, 44);
    bodyLabel.text = self.detailString;
    bodyLabel.font = [UIFont systemFontOfSize:14];
    bodyLabel.numberOfLines = 0;
    bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    [self.contentView addSubview:bodyLabel];
//////
//    CGFloat verSion = [[UIDevice currentDevice].systemVersion floatValue];
//    if (verSion >= 7.0)
//    {
//        height = [bodyLabel.text boundingRectWithSize:CGSizeMake(300, 2999) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: bodyLabel.font} context:nil].size.height;
//    }
//    else
//    {
//       height =  [bodyLabel.text sizeWithFont:bodyLabel.font constrainedToSize:CGSizeMake(300, 2999)].height;
//    }
//    
//    
//
//    CGRect rect = self.frame;
//    rect.size.height = CGRectGetMaxY(bodyLabel.frame) + 10;
//    self.frame = rect;
//    
//    NSLog(@"%@",NSStringFromCGSize(bodyLabel.frame.size));
}

#endif

@end
