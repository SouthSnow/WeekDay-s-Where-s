//
//  DetailCell2.h
//  周末去哪儿
//
//  Created by pangfuli on 14/9/4.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCell2 : UITableViewCell

@property (nonatomic, copy) NSString *detailString;
@property (nonatomic, assign) CGFloat cellHeight;
- (void)setHeight:(NSString*)string;

@end
