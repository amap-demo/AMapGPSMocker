//
//  AMGPSUtil.h
//  MAGPSEmulator
//
//  Created by lly on 2021/4/28.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMGPSUtil : NSObject

+ (BOOL)isEqualWith:(CLLocationCoordinate2D)coord to:(CLLocationCoordinate2D)targetCoord;

//把经纬度转化为字符串
+ (NSString *)stringFromCoord:(CLLocationCoordinate2D)coord;

///把 x,y形式的字符串，转换为经纬度，如无效则返回kCLLocationCoordinate2DInvalid
+ (CLLocationCoordinate2D)coordinateFromString:(NSString *)coordString;

@end

NS_ASSUME_NONNULL_END
