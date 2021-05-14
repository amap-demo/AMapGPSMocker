//
//  AMapGPSMocker.h

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/// 多个连续点模拟器（如mock路线行驶等）
@interface AGMMultiPointMocker : NSObject

@property (atomic, readonly) BOOL isMocking;

/**
 *  连续mock时的速度(单位: km/h; 默认值: 60km/h;)
 */
@property (nonatomic, assign) double speed;


+ (instancetype)sharedInstance;

/**
 *  设置模拟行驶路线的关键坐标点（如起终点、路口，拐角等位置的坐标点），经纬度默认为世界标准地理坐标（WGS-84）
 *  注意：该方法需要在startMockPoint之前调用，开始mock之后，设置无效
 *  @param coordinates 关键坐标列表
 *  @param count 关键坐标数量
 */
- (void)setKeyCoordinates:(CLLocationCoordinate2D *)coordinates count:(unsigned long)count;

/// 开始根据速度，回放设置的坐标点（会根据速度在keyCoordinates之间插入坐标来完成经纬度回放）
- (void)startMockPoint;

- (void)stopMockPoint;

@end
