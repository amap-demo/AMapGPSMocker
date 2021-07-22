//
//  AGMViewController.m
//  AMapGPSMocker
//
//  Created by xuefeng.lly on 03/23/2020.
//  Copyright (c) 2020 xuefeng.lly. All rights reserved.
//

#import "AGMViewController.h"
#import <CoreLocation/CLLocation.h>
#import <AMapGPSMocker/AMapGPSMocker.h>

@interface AGMViewController ()<MAMapViewDelegate,CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation AGMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    }
    [_locationManager startUpdatingLocation];
    [self initMapView];
    [[AGMFloatWindowManager sharedManager] showFloatWindow];
}

- (void)initMapView {
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.mapView.zoomLevel = 16.0;
}

//MARK: CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (locations.count > 0) {
//        locationManager回调的经纬度是WGS84坐标，但是高德地图MAMapView和苹果地图MKMapView中的坐标系是高德坐标，即GCJ02坐标；
        CLLocationCoordinate2D coord = locations.firstObject.coordinate;
        NSLog(@"locationManager update location:%@",[AGMCoordConvertUtil stringFromCoord:coord]);
        CLLocationCoordinate2D coord02 = [AGMCoordConvertUtil gcj02FromWgs84:coord];
        NSLog(@"locationManager coord02 get location:%@",[AGMCoordConvertUtil stringFromCoord:coord02]);
    }
}

//MARK: mapViewDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (updatingLocation) {
        NSLog(@"MAMapView update user location:%@",[AGMCoordConvertUtil stringFromCoord:userLocation.coordinate]);
        [mapView setCenterCoordinate:userLocation.coordinate animated:YES];
    }
}

/**
 *  @brief 当plist配置NSLocationAlwaysUsageDescription或者NSLocationAlwaysAndWhenInUseUsageDescription，并且[CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined，会调用代理的此方法。
    此方法实现调用后台权限API即可（ 该回调必须实现 [locationManager requestAlwaysAuthorization] ）; since 6.8.0
 *  @param locationManager  地图的CLLocationManager。
 */
- (void)mapViewRequireLocationAuth:(CLLocationManager *)locationManager {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {    
        [locationManager requestAlwaysAuthorization];
    }
}

@end
