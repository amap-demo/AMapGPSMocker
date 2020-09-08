//
//  MAGPSEmulatorUtil.h
//  AMGPSEmulator
//
//  Created by lly on 2020/3/23.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

double emu_distanceBetweenCoordinates(CLLocationCoordinate2D pointA, CLLocationCoordinate2D pointB);
CLLocationCoordinate2D emu_coordinateAtRateOfCoordinates(CLLocationCoordinate2D from, CLLocationCoordinate2D to, double rate);
double emu_normalizeDegree(double degree);
double emu_angleBetweenCoordinates(CLLocationCoordinate2D pointA, CLLocationCoordinate2D pointB);

NS_ASSUME_NONNULL_BEGIN

@interface MAGPSEmulatorUtil : NSObject

@end

NS_ASSUME_NONNULL_END
