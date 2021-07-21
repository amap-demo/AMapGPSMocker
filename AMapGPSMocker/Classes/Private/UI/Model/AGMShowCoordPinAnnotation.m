//
//  AGMShowCoordPinAnnotation.m
//  AMapGPSMocker
//
//  Created by lly on 2021/7/20.
//

#import "AGMShowCoordPinAnnotation.h"
#import "AGMCoordConvertUtil.h"

@implementation AGMShowCoordPinAnnotation

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate {
    _coordinate = coordinate;
    self.title = [AGMCoordConvertUtil stringFromCoord:coordinate];
}

@end
