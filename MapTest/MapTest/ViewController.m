//
//  ViewController.m
//  MapTest
//
//  Created by 翟安娜 on 17/3/16.
//  Copyright © 2017年 房融界. All rights reserved.
//

#import "ViewController.h"
#import "CustomMAAnimatedAnnotation.h"

typedef void(^CompletionBlock)();


@interface ViewController ()<MAMapViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) UIImageView *pointview;


@property (nonatomic, strong) UIImageView *centerview;
@property (nonatomic, strong) CustomMAAnimatedAnnotation *car1;
@property (nonatomic, strong) AMapSearchAPI *search;

@property(nonatomic,  strong)AMapReGeocodeSearchRequest *regeo ;

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic ,assign) BOOL isUpdateOrgin;

@property (nonatomic ,copy)CompletionBlock completion;
@end

@implementation ViewController

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
    _mapView.distanceFilter=5;
    
    _mapView.zoomLevel = 18;

//    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:NO];
////    
//    _mapView.showsUserLocation = YES;
    
    [self.view addSubview:self.mapView];
    
    
    _pointview =[[UIImageView alloc]initWithFrame:CGRectMake(self.mapView.center.x, self.mapView.center.y, 20, 20)];
    _pointview.image =[UIImage imageNamed:@"icon_passenger"];
    
    [_mapView addSubview:_pointview];
    
//
//    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];

    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    
    [self initBtn];
 //   __weak __typeof(&*self)weakSelf = self;

//    self.completion=^(){
//    
//        weakSelf.mapView.hidden =NO;
//
//    };
   
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 开启定位
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
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

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
    
    
    
//    __weak __typeof(&*self)weakSelf = self;

   
//    if (updatingLocation) {
//        
//        
//        if (self.completion) {
//            
//            self.completion();
//        }
//
//    }

//    if (updatingLocation) {
//        
//        weakSelf.completion();
//    }
//    NSLog(@"%@",userLocation.location);
//    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
}

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

    
    [UIView animateWithDuration:0.5 animations:^{
        
//        self.pointview.transform=CGAffineTransformMakeScale(2.0, 2.0);
        
        self.pointview.transform =CGAffineTransformMakeTranslation(0,-10.0);
    } completion:^(BOOL finished) {
//        self.pointview.transform=CGAffineTransformMakeScale(1, 1);
        self.pointview.transform =CGAffineTransformMakeTranslation(0,0);
//        [UIView animateWithDuration:0.6 animations:^{
//        
////            self.pointview.transform=CGAffineTransformMakeScale(2.0, 2.0);
//            
//            self.pointview.transform =CGAffineTransformMakeTranslation(0,-10.0);
//
//        } completion:^(BOOL finished) {
////            self.pointview.transform=CGAffineTransformMakeScale(1, 1);
//            self.pointview.transform =CGAffineTransformMakeTranslation(0,0);
//        }];
    }];
    
    
    
    
//    [UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.pointview.transform=CGAffineTransformMakeScale(1.5, 1.5);
//
//    } completion:^(BOOL finished) {
//        
//         self.pointview.transform=CGAffineTransformMakeScale(1, 1);
//    }];
   
    
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
