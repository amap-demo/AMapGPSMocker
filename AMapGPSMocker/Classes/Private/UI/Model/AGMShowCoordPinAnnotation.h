//
//  AGMShowCoordPinAnnotation.h
//  AMapGPSMocker
//
//  Created by lly on 2021/7/20.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN


/// 默认显示坐标位置的大头针
@interface AGMShowCoordPinAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy, nullable) NSString *title;

@end

NS_ASSUME_NONNULL_END
