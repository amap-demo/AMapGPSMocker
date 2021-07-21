//
//  AGMSinglePointMocker+Private.h
//  AMapGPSMocker
//
//  Created by lly on 2021/7/21.
//

#import "AGMSinglePointMocker.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGMSinglePointMocker (Private)

//内部私有方法，外部用户无需调用该接口
- (void)addLocationBinder:(id)binder delegate:(id)delegate;

@end

NS_ASSUME_NONNULL_END
