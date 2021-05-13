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

- (void)startMockPoint:(CLLocation*)location;

- (void)stopMockPoint;

//内部私有方法，外部用户无需调用该接口
- (void)addLocationBinder:(id)binder delegate:(id)delegate;

@end
