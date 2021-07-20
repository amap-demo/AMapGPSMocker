//
//  AGMViewController.m
//  AMapGPSMocker
//
//  Created by xuefeng.lly on 03/23/2020.
//  Copyright (c) 2020 xuefeng.lly. All rights reserved.
//

#import "AGMViewController.h"
#import <AMapGPSMocker/AGMFloatWindowManager.h>

@interface AGMViewController ()<MAMapViewDelegate>

@end

@implementation AGMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMapView];
    [[AGMFloatWindowManager sharedManager] showFloatWindow];
}

- (void)initMapView {
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.mapView.zoomLevel = 16.0;
}

//MARK: mapViewDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (updatingLocation) {
    }
}

@end
