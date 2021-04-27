//
//  DoraemonGPSMocker.h
//  DoraemonKit-DoraemonKit
//
//  Created by yixiang on 2018/7/4.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

//参考wander
@interface DoraemonGPSMocker : NSObject

@property (nonatomic, assign, readonly) BOOL isMocking;

+ (DoraemonGPSMocker *)shareInstance;

- (void)addLocationBinder:(id)binder delegate:(id)delegate;

- (BOOL)mockPoint:(CLLocation*)location;

- (void)stopMockPoint;

@end
