//
//  MapController.m
//  周末去哪儿
//
//  Created by pangfuli on 14-9-25.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "MapController.h"

#import "Annotation.h"
#import <MapKit/MapKit.h>


@interface MapController ()<MKMapViewDelegate,UIActionSheetDelegate>
{
    MKMapView *_mapView;
    CLLocationCoordinate2D _coordinate2D;
    NSMutableArray *availableMaps;
    
}
@end

@implementation MapController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        availableMaps = [NSMutableArray array];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"details_top_blue_back_normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
        
        
    }
    return self;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    
    [self addMapView];
    
    
    
}

- (void)addActionSheet
{
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:@"高德导航"] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"使用系统自带地图导航" , nil];
    [action showInView:self.view];
    
    
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //        CLLocationCoordinate2D myCoor = CLLocationCoordinate2DMake(_model.latitude.floatValue - .001, _model.longitude.floatValue - .001);
        CLLocationCoordinate2D endCoor = CLLocationCoordinate2DMake(_model.latitude.floatValue, _model.longitude.floatValue);
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        NSLog(@"currentLocation=======%@",currentLocation);
        MKPlacemark *placemark = [[MKPlacemark alloc]initWithCoordinate:endCoor addressDictionary:nil];
        MKMapItem *toLocation = [[MKMapItem alloc]initWithPlacemark:placemark];
        toLocation.name = _model.address;
        [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
        
    }
}

- (void)addMapView
{
    _mapView = [[MKMapView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _mapView.mapType = MKMapTypeStandard;
    _mapView.userInteractionEnabled = YES;
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    _coordinate2D = CLLocationCoordinate2DMake(_model.latitude.floatValue, _model.longitude.floatValue);
    MKCoordinateSpan span = {.0055,.0055};
    MKCoordinateRegion region = MKCoordinateRegionMake(_coordinate2D, span);
    _mapView.region = region;
    [self.view addSubview:_mapView];
    Annotation *annotation = [[Annotation alloc]initWithTitle:_model.address withSubTitle:nil withCoordinate:_coordinate2D];
    
    [_mapView addAnnotation:annotation];
    
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"cell"];
    if (!view) {
        view = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"cell"];
    }
    view.image = [UIImage imageNamed:@"sign"];
    UILabel *label = [[UILabel alloc]initWithFrame:view.frame];
    label.text = _model.address;
    label.font = [UIFont systemFontOfSize:12];
    [view addSubview:label];
    
    view.canShowCallout = YES;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 48, 48)];
    [btn setImage:[UIImage imageNamed:@"map_nav_go"] forState:(UIControlStateNormal)];
    [btn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"default_user_cover_other"]]];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:(UIControlEventTouchUpInside)];
    view.rightCalloutAccessoryView = btn;
    
    
    return view;
}

- (void)btnClick
{
    [self availableMapsApps];
    [self addActionSheet];
}

- (void)availableMapsApps
{
    [availableMaps removeAllObjects];
    //    CLLocationCoordinate2D myCoor = CLLocationCoordinate2DMake(_model.latitude.floatValue - .001, _model.longitude.floatValue - .001);
    CLLocationCoordinate2D endCoor = CLLocationCoordinate2DMake(_model.latitude.floatValue, _model.longitude.floatValue);
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
    {
        NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=applicationScheme&poiname=fangheng&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=3",
                               @"云华时代", endCoor.latitude, endCoor.longitude];
        NSDictionary *dic = @{@"name": @"高德地图",
                              @"url": urlString};
        [availableMaps addObject:dic];
    }
    
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
@end

