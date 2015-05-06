//
//  Annotation.h
//  MapDemo
//
//  Created by pangfuli on 14/8/21.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D _coordinate;
    NSString *_title;
    NSString *_subTitle;
    
}

- (NSString*)title;
- (NSString*)subTitle;
- (CLLocationCoordinate2D)coordinate;
- (id)initWithTitle:(NSString*)tempTitle withSubTitle:(NSString *)tempSubTitle withCoordinate:(CLLocationCoordinate2D)tempCoordinate;

@end
