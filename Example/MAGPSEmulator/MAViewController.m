//
//  MAViewController.m
//  MAGPSEmulator
//
//  Created by xuefeng.lly on 03/23/2020.
//  Copyright (c) 2020 xuefeng.lly. All rights reserved.
//

#import "MAViewController.h"
#import <MAGPSEmulator/MAGPSEmulator.h>
#import <MAGPSEmulator/MAGPSEmulatorManualMode.h>

@interface MAViewController ()<MAMapViewDelegate,MAGPSEmulatorDelegate>

@property (nonatomic,strong) MAGPSEmulatorManualMode *emulator;

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
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: mapViewDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (updatingLocation) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.emulator.startPosition = userLocation.location.coordinate;
            self.emulator.direction = 0;
            [self.emulator startEmulator];
        });
    }
}
//MARK: MAGPSEmulatorDelegate

- (void)gpsEmulatorUpdateLocation:(CLLocation *)location {
    NSLog(@"gpsEmulatorUpdateLocation:%@",location);
    CLLocationCoordinate2D point = location.coordinate;
    if (CLLocationCoordinate2DIsValid(point)) {
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        annotation.coordinate = point;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"new point coordinate:%f,%f",annotation.coordinate.latitude,annotation.coordinate.longitude);
            NSLog(@"annotationCount:%d",self.mapView.annotations.count);
            [self.mapView addAnnotation:annotation];
        });
    }
}

//MARK: btnAction

- (IBAction)upClicked:(id)sender {
    self.emulator.direction = 0;
}
- (IBAction)downClicked:(id)sender {
    self.emulator.direction = 180;
}
- (IBAction)leftClicked:(id)sender {
    self.emulator.direction = 270;
}
- (IBAction)rightClicked:(id)sender {
    self.emulator.direction = 90;
}

- (IBAction)stopClicked:(id)sender {
    [self.emulator stopEmulator];
}
@end
