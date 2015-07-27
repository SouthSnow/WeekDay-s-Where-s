//
//  DetailCell2.m
//  周末去哪儿
//
//  Created by pangfuli on 14/9/4.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "DetailCell2.h"

@interface DetailCell2 ()<UIWebViewDelegate>

@end


@implementation DetailCell2
{
    __weak IBOutlet UILabel *bodyLabel;
    CGFloat _height;
    UILabel *label;
//    __weak IBOutlet UIWebView *webView;
}


- (void)setHeight:(NSString *)string
{
    CGFloat height = 0;
    bodyLabel.text = string;
    bodyLabel.font = [UIFont systemFontOfSize:14];
    bodyLabel.numberOfLines = 0;
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
    
    
    bodyLabel.frame = CGRectMake(bodyLabel.frame.origin.x, bodyLabel.frame.origin.y, bodyLabel.frame.size.width, height);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,height + 20);
 
    self.cellHeight = CGRectGetMaxY(self.frame);
}

#if 0

- (void)setDetailString:(NSString *)detailString
{
    _detailString = detailString;

    bodyLabel.text = detailString;
    bodyLabel.font = [UIFont systemFontOfSize:14];
    bodyLabel.numberOfLines = 0;
    bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    bodyLabel.textColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0];
    
    CGFloat height = 0;
    
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
    bodyFrame.size.height = height;
    bodyLabel.frame = bodyFrame;
    bodyLabel.hidden = NO;
//    bodyLabel.backgroundColor = [UIColor redColor];
    self.cellHeight = height;
//
    CGRect rect = self.frame;
    rect.size.height = CGRectGetHeight(bodyLabel.frame);
    self.frame = rect;

    [webView loadHTMLString:self.detailString baseURL:nil];
//    webView.delegate = self;
    webView.paginationBreakingMode = UIWebPaginationBreakingModePage;
    webView.paginationMode = UIWebPaginationModeBottomToTop;
//    webView.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 320);
    webView.scalesPageToFit = NO;
    webView.hidden = YES;
//    NSLog(@"height = %f",height);
    
}


//#if 1
- (void)layoutSubviews
{
    
//    CGFloat height = 0;
//    
//    bodyLabel.text = self.detailString;
//    bodyLabel.font = [UIFont systemFontOfSize:14];
//    bodyLabel.numberOfLines = 12;
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
//       height = [bodyLabel.text sizeWithFont:bodyLabel.font constrainedToSize:CGSizeMake(300, 2999)].height;
//        
//    }
//    
//    CGRect bodyFrame = bodyLabel.frame;
//    bodyFrame.size.height = self.cellHeight;
//    bodyLabel.frame = bodyFrame;
//    bodyLabel.backgroundColor = [UIColor redColor];

//
    
    // 父视图的高度必须与子视图高度不同才使得layoutViews生效
    CGRect rect = self.frame;
    rect.size.height = CGRectGetMaxY(bodyLabel.frame);
//    webView.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 320);
    self.frame = rect;
//    bodyLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    NSLog(@"height = %f",rect.size.height);

    
    
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
    
//    _cellHeight = height+20;
}

//#if 1

- (void)awakeFromNib
{
    // Initialization code
    
//    CGFloat height;
    bodyLabel.frame = CGRectMake(10, 10, 300, 44);
    bodyLabel.text = self.detailString;
    bodyLabel.font = [UIFont systemFontOfSize:14];
    bodyLabel.numberOfLines = 0;
    bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGRect rect = self.frame;
    rect.size.height = CGRectGetMaxY(bodyLabel.frame);
    //    webView.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 320);
    self.frame = rect;
    
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
