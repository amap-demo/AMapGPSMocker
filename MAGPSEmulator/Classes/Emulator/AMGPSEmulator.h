//
//  AMGPSEmulator.h

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol MAGPSEmulatorDelegate <NSObject>
@required

/**
 *  Called when GPS emulator produce new location.
 *
 *  @param location a new location
 */
- (void)gpsEmulatorUpdateLocation:(CLLocation *)location;

@end


@interface AMGPSEmulator : NSObject

/**
 *  A object adopt the ATGPSEmulatorDelegate protocol
 */
@property (nonatomic, weak) id<MAGPSEmulatorDelegate> delegate;

/**
 *  Indicate whether the GPS emulator isSimulating.
 */
@property (atomic, readonly) BOOL isSimulating;

/**
 *  Simulate Speed(Unit: km/h; Default: 60km/h;)
 */
@property (nonatomic, assign) double simulateSpeed;

/**
 *  Assign coordiantes that used for simulate. Invoke this method after start emulator has no effect.
 *
 *  @param coordinates coordinate list
 *  @param count coordiantes count
 */
- (void)setCoordinates:(CLLocationCoordinate2D *)coordinates count:(unsigned long)count;

/**
 *  Start Emulator
 */
- (void)startEmulator;

/**
 *  Stop Emulator
 */
- (void)stopEmulator;

@end
