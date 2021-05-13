//
//  AGMViewController.m
//  AMapGPSMocker
//
//  Created by xuefeng.lly on 03/23/2020.
//  Copyright (c) 2020 xuefeng.lly. All rights reserved.
//

#import "AGMViewController.h"
#import <AMapGPSMocker/AGMMultiPointMocker.h>
#import <AMapGPSMocker/AGMManualMode.h>
#import "AGMFloatWindowManager.h"
#import "AGMDriveCarEmulatorViewController.h"

@interface AGMViewController ()<MAMapViewDelegate,AGMMultiPointMockerDelegate>

//@property (nonatomic,strong) AGMManualMode *emulator;
//@property (nonatomic,strong) MAPointAnnotation *currentPointAnnotation;

@end

@implementation AGMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initEmulator];
    [self initMapView];
}

//- (void)initEmulator {
//    self.emulator = [[AGMManualMode alloc] init];
//    self.emulator.delegate = self;
//}

- (void)initMapView {
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.mapView.zoomLevel = 16.0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[AGMFloatWindowManager sharedManager] showFloatWindow];
}

//MARK: mapViewDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (updatingLocation) {
    }
}
//MARK: AGMMultiPointMockerDelegate

- (void)gpsEmulatorUpdateLocation:(CLLocation *)location {
    NSLog(@"gpsEmulatorUpdateLocation:%@",location);
    CLLocationCoordinate2D point = location.coordinate;
    if (CLLocationCoordinate2DIsValid(point)) {
//        MAPointAnnotation *annotation = self.currentPointAnnotation;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            annotation.coordinate = point;
//            if ([self.mapView.annotations containsObject:annotation]) {
//                return;
//            } else {
//                [self.mapView addAnnotation:annotation];
//            }
//        });
    }
}

//- (MAPointAnnotation *)currentPointAnnotation {
//    if (_currentPointAnnotation == nil) {
//        _currentPointAnnotation = [[MAPointAnnotation alloc] init];
//    }
//    return _currentPointAnnotation;
//}

@end
