//
//  CLLocationManager+Doraemon.h
//  AMapGPSMocker
//

#import <CoreLocation/CoreLocation.h>

//参考wander
@interface CLLocationManager (AGMHookDelegate)

- (void)agm_swizzleLocationDelegate:(id)delegate;

@end
