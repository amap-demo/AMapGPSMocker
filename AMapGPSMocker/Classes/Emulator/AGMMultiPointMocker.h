//
//  AMapGPSMocker.h

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol AGMMultiPointMockerDelegate <NSObject>
@required

/**
 *  回调mock的新位置
 *
 *  @param location 新的位置
 */
- (void)gpsEmulatorUpdateLocation:(CLLocation *)location;

@end


/// 多个连续点模拟器（如mock路线行驶等）
@interface AGMMultiPointMocker : NSObject

@property (nonatomic, weak) id<AGMMultiPointMockerDelegate> delegate;

@property (atomic, readonly) BOOL isMocking;

/**
 *  连续mock时的速度(单位: km/h; 默认值: 60km/h;)
 */
@property (nonatomic, assign) double simulateSpeed;

/**
 *  设置模拟行驶路线的关键坐标点（如起终点、路口，拐角等位置的坐标点）
 *  注意：该方法需要在startMockPoint之前调用，开始mock之后，设置无效
 *  @param coordinates 关键坐标列表
 *  @param count 关键坐标数量
 */
- (void)setKeyCoordinates:(CLLocationCoordinate2D *)coordinates count:(unsigned long)count;

- (void)startMockPoint;

- (void)stopMockPoint;

@end
