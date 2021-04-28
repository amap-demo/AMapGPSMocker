//
//  AGMCaclUtil.h
//  MAGPSEmulator
//
//  Created by lly on 2021/4/28.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN


/// 计算工具类
@interface AGMCaclUtil : NSObject

+ (BOOL)isEqualWith:(CLLocationCoordinate2D)coord to:(CLLocationCoordinate2D)targetCoord;

//把经纬度转化为字符串
+ (NSString *)stringFromCoord:(CLLocationCoordinate2D)coord;

///把 x,y形式的字符串，转换为经纬度，如无效则返回kCLLocationCoordinate2DInvalid
+ (CLLocationCoordinate2D)coordinateFromString:(NSString *)coordString;


/// 计算两点之间的距离
/// @param pointA a点
/// @param pointB b点
+ (double)distanceBetweenCoord:(CLLocationCoordinate2D)pointA
                      andCoord:(CLLocationCoordinate2D)pointB;


/// 两点之间的特定距离百分比的点
/// @param from 起点
/// @param to 终点
/// @param rate 距离百分比（从起点到终点的距离百分比为1,两点中间位置为0.5）
+ (CLLocationCoordinate2D)coordFromCoord:(CLLocationCoordinate2D)from
                                 toCoord:(CLLocationCoordinate2D)to
                                withRate:(float)rate;


/// 标准话度数值（将度数调整到0-360度之间）
/// @param degree 原始度数
+ (double)normalizeDegree:(double)degree;


/// 两点之间的角度
/// @param pointA a点
/// @param pointB b点
+ (double)angleBetweenCoord:(CLLocationCoordinate2D)pointA
                   andCoord:(CLLocationCoordinate2D)pointB;

@end

NS_ASSUME_NONNULL_END
