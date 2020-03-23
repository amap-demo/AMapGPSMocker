//
//  MAGPSEmulatorUtil.h
//  MAGPSEmulator
//
//  Created by lly on 2020/3/23.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

double distanceBetweenCoordinates(CLLocationCoordinate2D pointA, CLLocationCoordinate2D pointB);
CLLocationCoordinate2D coordinateAtRateOfCoordinates(CLLocationCoordinate2D from, CLLocationCoordinate2D to, double rate);
double normalizeDegree(double degree);
double angleBetweenCoordinates(CLLocationCoordinate2D pointA, CLLocationCoordinate2D pointB);

NS_ASSUME_NONNULL_BEGIN

@interface MAGPSEmulatorUtil : NSObject

@end

NS_ASSUME_NONNULL_END
