//
//  TelCell.h
//  周末去哪儿
//
//  Created by dongbailan on 14-9-14.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TelCell : UITableViewCell

@property (nonatomic, copy) NSString *telString;

@property (weak, nonatomic) IBOutlet UILabel *tel;
@property (weak, nonatomic) IBOutlet UILabel *underLine;

@end
