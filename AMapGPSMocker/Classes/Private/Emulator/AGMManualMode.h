//
//  AGMManualMode.h
//  AMapGPSMocker
//
//  Created by lly on 2020/3/23.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AGMManualModeDelegate <NSObject>
@required

/**
 *  回调mock的新位置
 *
 *  @param location 新的位置
 */
- (void)gpsEmulatorUpdateLocation:(CLLocation *)location;

@end

//开发中，暂时不对外
@interface AGMManualMode : NSObject

/**
 *  A object adopt the ATGPSEmulatorDelegate protocol
 */
@property (nonatomic, weak) id<AGMManualModeDelegate> delegate;

/**
 *  Indicate whether the GPS emulator isSimulating.
 */
@property (atomic, readonly) BOOL isSimulating;

/**
 *  Simulate Speed(Unit: km/h; Default: 60km/h;)
 */
@property (nonatomic, assign) double simulateSpeed;

@property (nonatomic, assign) CLLocationDirection direction;//方向

@property (nonatomic, assign) CLLocationCoordinate2D startPosition;//起点

@property (nonatomic, assign, readonly) CLLocationCoordinate2D currentPosition;
/**
 *  Assign coordiantes that used for simulate. Invoke this method after start emulator has no effect.
 *
 *  @param coordinates coordinate list
 *  @param count coordiantes count
 */
//- (void)setCoordinates:(CLLocationCoordinate2D *)coordinates count:(unsigned long)count;

/**
 *  Start Emulator
 */
- (void)startEmulator;

/**
 *  Stop Emulator
 */
- (void)stopEmulator;

@end

NS_ASSUME_NONNULL_END
