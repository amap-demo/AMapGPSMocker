//
//  AGMSinglePointMocker.h
//  AMapGPSMocker
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


/// 单个GPS位置点模拟
@interface AGMSinglePointMocker : NSObject

@property (nonatomic, assign, readonly) BOOL isMocking;

+ (instancetype)sharedInstance;


/// 开始mock经纬度的坐标点
/// @param coord 经纬度 （注意：经纬度需要是WGS84坐标系，因为CLLocationManager回调的都是WGS84坐标）
- (void)startMockCoord:(CLLocationCoordinate2D)coord;

/// 开始mock坐标点
/// @param location 坐标点（注意：经纬度需要是WGS84坐标系，因为CLLocationManager回调的都是WGS84坐标）
- (void)startMockPoint:(CLLocation*)location;

- (void)stopMockPoint;

//内部私有方法，外部用户无需调用该接口
- (void)addLocationBinder:(id)binder delegate:(id)delegate;

@end
