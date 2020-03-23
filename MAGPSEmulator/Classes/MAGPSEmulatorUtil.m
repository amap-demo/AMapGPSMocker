//
//  MAGPSEmulatorUtil.m
//  MAGPSEmulator
//
//  Created by lly on 2020/3/23.
//

#import "MAGPSEmulatorUtil.h"

double distanceBetweenCoordinates(CLLocationCoordinate2D pointA, CLLocationCoordinate2D pointB) {
#define AMAPLOC_DEG_TO_RAD 0.0174532925199432958f
#define AMAPLOC_EARTH_RADIUS 6378137.0f

    double latitudeArc = (pointA.latitude - pointB.latitude) * AMAPLOC_DEG_TO_RAD;
    double longitudeArc = (pointA.longitude - pointB.longitude) * AMAPLOC_DEG_TO_RAD;

    double latitudeH = sin(latitudeArc * 0.5);
    latitudeH *= latitudeH;
    double lontitudeH = sin(longitudeArc * 0.5);
    lontitudeH *= lontitudeH;

    double tmp = cos(pointA.latitude * AMAPLOC_DEG_TO_RAD) * cos(pointB.latitude * AMAPLOC_DEG_TO_RAD);
    return AMAPLOC_EARTH_RADIUS * 2.0 * asin(sqrt(latitudeH + tmp * lontitudeH));
}

CLLocationCoordinate2D coordinateAtRateOfCoordinates(CLLocationCoordinate2D from, CLLocationCoordinate2D to, double rate) {
    if (rate >= 1.f) return to;
    if (rate <= 0.f) return from;

    double latitudeDelta = (to.latitude - from.latitude) * rate;
    double longitudeDelta = (to.longitude - from.longitude) * rate;

    return CLLocationCoordinate2DMake(from.latitude + latitudeDelta, from.longitude + longitudeDelta);
}

double normalizeDegree(double degree) {
    double normalizationDegree = fmod(degree, 360.f);
    return (normalizationDegree < 0) ? normalizationDegree += 360.f : normalizationDegree;
}

double angleBetweenCoordinates(CLLocationCoordinate2D pointA, CLLocationCoordinate2D pointB) {
    double longitudeDelta = pointB.longitude - pointA.longitude;
    double latitudeDelta = pointB.latitude - pointA.latitude;
    double azimuth = (M_PI * .5f) - atan2(latitudeDelta, longitudeDelta);

    return normalizeDegree(azimuth * 180 / M_PI);
}

@implementation MAGPSEmulatorUtil



@end
