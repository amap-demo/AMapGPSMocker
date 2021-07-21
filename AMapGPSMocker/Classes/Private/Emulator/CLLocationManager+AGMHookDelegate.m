//
//  CLLocationManager+Doraemon.m
//  AMapGPSMocker
//
//

#import "CLLocationManager+AGMHookDelegate.h"
#import "AGMSinglePointMocker.h"
#import "AGMSinglePointMocker+Private.h"
#import <objc/runtime.h>

@implementation CLLocationManager (AGMHookDelegate)

- (void)agm_swizzleLocationDelegate:(id)delegate {
    if (delegate) {
        [self agm_swizzleLocationDelegate:[AGMSinglePointMocker sharedInstance]];
        [[AGMSinglePointMocker sharedInstance] addLocationBinder:self delegate:delegate];
        
        Protocol *proto = objc_getProtocol("CLLocationManagerDelegate");
        unsigned int count;
        struct objc_method_description *methods = protocol_copyMethodDescriptionList(proto, NO, YES, &count);
        for(unsigned i = 0; i < count; i++)
        {
            SEL sel = methods[i].name;
            if ([delegate respondsToSelector:sel]) {
                if (![[AGMSinglePointMocker sharedInstance] respondsToSelector:sel]) {
                    NSAssert(NO, @"Delegate : %@ not implementation SEL : %@",delegate,NSStringFromSelector(sel));

                }
            }
        }
        free(methods);
        
    } else {
        [self agm_swizzleLocationDelegate:delegate];
    }
}

@end
