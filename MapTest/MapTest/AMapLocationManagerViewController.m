//
//  AMapLocationManagerViewController.m
//  MapTest
//
//  Created by 翟安娜 on 17/3/17.
//  Copyright © 2017年 房融界. All rights reserved.
//

#import "CustomMAAnimatedAnnotation.h"
#import "AMapLocationManagerViewController.h"

@interface AMapLocationManagerViewController ()<MAMapViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) UIImageView *pointview;


@property (nonatomic, strong) UIImageView *centerview;
@property (nonatomic, strong) CustomMAAnimatedAnnotation *car1;
@property (nonatomic, strong) AMapSearchAPI *search;

@property(nonatomic,  strong)AMapReGeocodeSearchRequest *regeo ;

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic ,assign) BOOL isUpdateOrgin;
@property (nonatomic ,assign) BOOL isUpdateLocation;

@property (nonatomic, strong) CLLocation *currentLocation;
@end

@implementation AMapLocationManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    
    _mapView.backgroundColor = [UIColor whiteColor];
    
    self.mapView.delegate = self;
    
    _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;

    
    
    _mapView.showsCompass = NO;
    _mapView.showsIndoorMap = NO;
    _mapView.rotateEnabled = NO;
    _mapView.showsScale = NO;

    
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:NO];

    
    
    [self.view addSubview:self.mapView];
    
    
    _pointview =[[UIImageView alloc]initWithFrame:CGRectMake(self.mapView.center.x, self.mapView.center.y, 20, 20)];
    _pointview.image =[UIImage imageNamed:@"icon_passenger"];
    
    [_mapView addSubview:_pointview];
    

    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    
    [self initBtn];
    
    [self configLocationManager];
    
    
    
}

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    
    [self.locationManager setDistanceFilter:5];
    //设置允许连续定位逆地理
    [self.locationManager setLocatingWithReGeocode:YES];
    
    [self.locationManager startUpdatingLocation];
    

}




#pragma mark - AMapLocationManager Delegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    
    if (location.coordinate.latitude!=self.currentLocation.coordinate.latitude||location.coordinate.longitude!=self.currentLocation.coordinate.longitude) {
        
            NSLog(@"location:{lat:%f; lon:%f; accuracy:%f; reGeocode:%@}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy, reGeocode.formattedAddress);
        
        
        self.currentLocation=location;
        
        self.isUpdateLocation =YES;
    }
    
    
    if (self.isUpdateLocation) {
        
        [self.mapView setCenterCoordinate:location.coordinate];
        [self.mapView setZoomLevel:15.1 animated:NO];

    }


}


- (void)initBtn {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(0, 100, 60, 40);
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:@"move" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(mov) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.frame = CGRectMake(0, 200, 60, 40);
    btn1.backgroundColor = [UIColor grayColor];
    [btn1 setTitle:@"stop" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn1];
}

- (void)mov {
    
    if (_isUpdateOrgin) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
    }
    
    
    _isUpdateOrgin=NO;
    
}

- (void)stop {
    
    
}

//- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
//
////    NSLog(@"%@",userLocation.location);
////    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
//}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    /* 自定义userLocation对应的annotationView. */
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:userLocationStyleReuseIndetifier];
            
        }
        UIImage *image = [UIImage imageNamed:@"icon_passenger"];
        annotationView.image = image;
        
        annotationView.canShowCallout = NO;
        
        
        
        return annotationView;
    }
    return nil;
}



/**
 * @brief 地图将要发生移动时调用此接口
 * @param mapView       地图view
 * @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction;
{
    
    
    self.pointview.center =[self.mapView convertCoordinate:self.mapView.centerCoordinate toPointToView:mapView];
    
    
    
    
    _isUpdateOrgin=YES;
}
/**
 *  地图移动结束后调用此接口
 *
 *  @param mapView       地图view
 *  @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    
    
    //    NSLog(@"centerCoordinate is %f",self.mapView.centerCoordinate.latitude);
    //
    //    NSLog(@"userLocation is %f",self.mapView.userLocation.coordinate.latitude);
    
    _regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    _regeo.location = [AMapGeoPoint locationWithLatitude:mapView.region.center.latitude longitude:mapView.region.center.longitude];
    
    _regeo.requireExtension = YES;
    
    
    [self.search AMapReGoecodeSearch:_regeo];
    
    
}


#pragma mark -  AMapSearchDelegate




#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    // NSLog(@"Error: %@ - %@", error, [ErrorInfoUtility errorDescriptionWithCode:error.code]);
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        
        //        NSLog(@"reGeocode:%@", response.regeocode.formattedAddress);//获得的中心点地址
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
        //        ReGeocodeAnnotation *reGeocodeAnnotation = [[ReGeocodeAnnotation alloc] initWithCoordinate:coordinate
        //                                                                                         reGeocode:response.regeocode];
        //
        //        [self.mapView addAnnotation:reGeocodeAnnotation];
        //        [self.mapView selectAnnotation:reGeocodeAnnotation animated:YES];
    }
    else /* from drag search, update address */
    {
        //        [self.annotation setAMapReGeocode:response.regeocode];
        //        [self.mapView selectAnnotation:self.annotation animated:YES];
    }
}


@end

