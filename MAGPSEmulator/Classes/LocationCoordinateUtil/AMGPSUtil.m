//
//  AMGPSUtil.m
//  MAGPSEmulator
//
//  Created by lly on 2021/4/28.
//

#import "AMGPSUtil.h"

@implementation AMGPSUtil

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

@end
