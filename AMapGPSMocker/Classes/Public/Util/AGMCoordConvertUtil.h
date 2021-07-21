//
//  AGMCoordConvertUtil.h
//  AMapGPSMocker
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/// 各种坐标系统转换工具
@interface AGMCoordConvertUtil : NSObject

/// @brief 把经纬度转化为字符串
/// @param coord 经纬度
/// @return 返回的字符串格式为  经度,维度
+ (NSString *)stringFromCoord:(CLLocationCoordinate2D)coord;

///


/// @brief 把 x,y形式的字符串，转换为经纬度，注意：经度在前，维度在后
/// 如无效则返回kCLLocationCoordinate2DInvalid
/// @param coordString 经纬度字符串格式为 经度,维度
/// @return 经纬度坐标
+ (CLLocationCoordinate2D)coordinateFromString:(NSString *)coordString;

/**
 *  @brief  世界标准地理坐标(WGS-84) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
 *
 *  ####只在中国大陆的范围的坐标有效，以外直接返回世界标准坐标
 *
 *  @param  location    世界标准地理坐标(WGS-84)
 *
 *  @return 中国国测局地理坐标（GCJ-02）<火星坐标>
 */
+ (CLLocationCoordinate2D)gcj02FromWgs84:(CLLocationCoordinate2D)location;


/**
 *  @brief  中国国测局地理坐标（GCJ-02） 转换成 世界标准地理坐标（WGS-84）
 *
 *  ####此接口有1－2米左右的误差，需要精确定位情景慎用
 *
 *  @param  location    中国国测局地理坐标（GCJ-02）
 *
 *  @return 世界标准地理坐标（WGS-84）
 */
+ (CLLocationCoordinate2D)wgs84FromGcj02:(CLLocationCoordinate2D)location;


/**
 *  @brief  世界标准地理坐标(WGS-84) 转换成 百度地理坐标（BD-09)
 *
 *  @param  location    世界标准地理坐标(WGS-84)
 *
 *  @return 百度地理坐标（BD-09)
 */
+ (CLLocationCoordinate2D)bd09FromWgs84:(CLLocationCoordinate2D)location;


/**
 *  @brief  中国国测局地理坐标（GCJ-02）<火星坐标> 转换成 百度地理坐标（BD-09)
 *
 *  @param  location    中国国测局地理坐标（GCJ-02）<火星坐标>
 *
 *  @return 百度地理坐标（BD-09)
 */
+ (CLLocationCoordinate2D)bd09FromGcj02:(CLLocationCoordinate2D)location;


/**
 *  @brief  百度地理坐标（BD-09) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
 *
 *  @param  location    百度地理坐标（BD-09)
 *
 *  @return 中国国测局地理坐标（GCJ-02）<火星坐标>
 */
+ (CLLocationCoordinate2D)gcj02FromBd09:(CLLocationCoordinate2D)location;


/**
 *  @brief  百度地理坐标（BD-09) 转换成 世界标准地理坐标（WGS-84）
 *
 *  ####此接口有1－2米左右的误差，需要精确定位情景慎用
 *
 *  @param  location    百度地理坐标（BD-09)
 *
 *  @return 世界标准地理坐标（WGS-84）
 */
+ (CLLocationCoordinate2D)wgs84FromBd09:(CLLocationCoordinate2D)location;

@end
