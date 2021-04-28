//
//  AGMCaclUtil.m
//  MAGPSEmulator
//
//  Created by lly on 2021/4/28.
//

#import "AGMCaclUtil.h"

@implementation AGMCaclUtil

+ (BOOL)isEqualWith:(CLLocationCoordinate2D)coord to:(CLLocationCoordinate2D)targetCoord {
    if (fabs(coord.latitude - targetCoord.latitude) > 0.000001 || fabs(coord.longitude - targetCoord.longitude) > 0.000001) {
        return NO;
    }
    return YES;
}

//把经纬度转化为字符串
+ (NSString *)stringFromCoord:(CLLocationCoordinate2D)coord {
    if (CLLocationCoordinate2DIsValid(coord) == NO) {
        return @"";
    }
    return [NSString stringWithFormat:@"%.6f,%.6f", coord.longitude, coord.latitude];
}

///把 x,y形式的字符串，转换为经纬度，如无效则返回kCLLocationCoordinate2DInvalid
+ (CLLocationCoordinate2D)coordinateFromString:(NSString *)coordString {
    CLLocationCoordinate2D coor = kCLLocationCoordinate2DInvalid;

    NSArray<NSString *> *positionArr = [coordString componentsSeparatedByString:@","];
    if (positionArr.count == 2) {
        coor = CLLocationCoordinate2DMake([positionArr.lastObject doubleValue], [positionArr.firstObject doubleValue]);
    }

    return coor;
}

+ (double)distanceBetweenCoord:(CLLocationCoordinate2D)pointA
                      andCoord:(CLLocationCoordinate2D)pointB {
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

+ (CLLocationCoordinate2D)coordFromCoord:(CLLocationCoordinate2D)from
                                 toCoord:(CLLocationCoordinate2D)to
                                withRate:(float)rate {
    if (rate >= 1.f) return to;
    if (rate <= 0.f) return from;

    double latitudeDelta = (to.latitude - from.latitude) * rate;
    double longitudeDelta = (to.longitude - from.longitude) * rate;

    return CLLocationCoordinate2DMake(from.latitude + latitudeDelta, from.longitude + longitudeDelta);
}

+ (double)normalizeDegree:(double)degree {
    double normalizationDegree = fmod(degree, 360.f);
    return (normalizationDegree < 0) ? normalizationDegree += 360.f : normalizationDegree;
}

+ (double)angleBetweenCoord:(CLLocationCoordinate2D)pointA
                   andCoord:(CLLocationCoordinate2D)pointB {
    double longitudeDelta = pointB.longitude - pointA.longitude;
    double latitudeDelta = pointB.latitude - pointA.latitude;
    double azimuth = (M_PI * .5f) - atan2(latitudeDelta, longitudeDelta);

    return [self normalizeDegree:(azimuth * 180 / M_PI)];
}

@end
