//
//  DetCell.m
//  周末去哪儿
//
//  Created by pangfuli on 14-9-24.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "DetCell.h"
#import "Annotation.h"
#import <MapKit/MapKit.h>

@interface DetCell()<MKMapViewDelegate,CLLocationManagerDelegate>



@end

@implementation DetCell
{
    __weak IBOutlet MKMapView *map;
    
    __weak IBOutlet UILabel *distance;
    __weak IBOutlet UILabel *address;
}


- (void)setModel:(DetailModel*)model
{
    _model = model;
    CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DMake(model.latitude.floatValue,model.longitude.floatValue);
    MKCoordinateSpan span = {0.005,0.005};
    map.region = MKCoordinateRegionMake(coordinate2D, span);
    address.text = model.address;
    address.font = [UIFont systemFontOfSize:10];
    distance.text = model.distance_show;
    distance.font = [UIFont systemFontOfSize:8];
    distance.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]];
    Annotation *annotion = [[Annotation alloc]initWithTitle:nil withSubTitle:nil withCoordinate:coordinate2D];
    [map addAnnotation:annotion];
    map.delegate = self;
    
    
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"view"];
    if (!view) {
        view = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"view"];
    }
    view.image = [UIImage imageNamed:@"sign"];
    return view;
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

