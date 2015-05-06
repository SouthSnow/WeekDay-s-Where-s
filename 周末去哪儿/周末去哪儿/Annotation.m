//
//  Annotation.m
//  MapDemo
//
//  Created by pangfuli on 14/8/21.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation
- (NSString*)title
{
    return _title;
}
- (NSString*)subTitle
{
    return _subTitle;
}
- (CLLocationCoordinate2D)coordinate
{
    return _coordinate;
}
- (id)initWithTitle:(NSString*)tempTitle withSubTitle:(NSString *)tempSubTitle withCoordinate:(CLLocationCoordinate2D)tempCoordinate
{
    self = [super init];
    if (self) {
        _coordinate = tempCoordinate;
        _title = tempTitle;
        _subTitle = tempSubTitle;
        
    }
    return self;
}


@end
