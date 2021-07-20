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


/// 开始mock经纬度的坐标点（经纬度需要是中国国测局地理坐标（GCJ-02）<火星坐标>）
/// @param coord 经纬度
- (void)startMockCoord:(CLLocationCoordinate2D)coord;

/// 开始mock坐标点
/// @param location 坐标点，注意入参中的经纬度需要是中国国测局地理坐标（GCJ-02）<火星坐标>
- (void)startMockPoint:(CLLocation*)location;

- (void)stopMockPoint;

//内部私有方法，外部用户无需调用该接口
- (void)addLocationBinder:(id)binder delegate:(id)delegate;

@end
