//
//  MAViewController.m
//  AMGPSEmulator
//
//  Created by xuefeng.lly on 03/23/2020.
//  Copyright (c) 2020 xuefeng.lly. All rights reserved.
//

#import "MAViewController.h"
#import <MAGPSEmulator/AMGPSEmulator.h>
#import <MAGPSEmulator/MAGPSEmulatorManualMode.h>
#import "AMGPSFloatWindowManager.h"
#import "MADriveCarEmulatorViewController.h"

@interface MAViewController ()<MAMapViewDelegate,MAGPSEmulatorDelegate>

@property (nonatomic,strong) MAGPSEmulatorManualMode *emulator;
@property (nonatomic,strong) MAPointAnnotation *currentPointAnnotation;

@end

@implementation MAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initEmulator];
    [self initMapView];
}

- (void)initEmulator {
    self.emulator = [[MAGPSEmulatorManualMode alloc] init];
    self.emulator.delegate = self;
}

- (void)initMapView {
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.mapView.zoomLevel = 16.0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.emulator showFloatWindow];
}

//MARK: mapViewDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (updatingLocation) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.emulator.startPosition = userLocation.location.coordinate;
            self.emulator.direction = 0;
            [self.emulator startEmulator];
            [self.mapView showAnnotations:@[userLocation] animated:YES];
        });
    }
}
//MARK: MAGPSEmulatorDelegate

- (void)gpsEmulatorUpdateLocation:(CLLocation *)location {
    NSLog(@"gpsEmulatorUpdateLocation:%@",location);
    CLLocationCoordinate2D point = location.coordinate;
    if (CLLocationCoordinate2DIsValid(point)) {
        MAPointAnnotation *annotation = self.currentPointAnnotation;
        dispatch_async(dispatch_get_main_queue(), ^{
            annotation.coordinate = point;
            if ([self.mapView.annotations containsObject:annotation]) {
                return;
            } else {
                [self.mapView addAnnotation:annotation];
            }
        });
    }
}

- (MAPointAnnotation *)currentPointAnnotation {
    if (_currentPointAnnotation == nil) {
        _currentPointAnnotation = [[MAPointAnnotation alloc] init];
    }
    return _currentPointAnnotation;
}

@end
