//
//  AGMViewController.h
//  AMapGPSMocker
//
//  Created by xuefeng.lly on 03/23/2020.
//  Copyright (c) 2020 xuefeng.lly. All rights reserved.
//

@import UIKit;
#if __has_include(<AMapNaviKit/MAMapKit.h>)
#import <AMapNaviKit/MAMapKit.h>
#elif __has_include(<MAMapKit/MAMapKit.h>)
#import <MAMapKit/MAMapKit.h>
#elif __has_include("MAMapKit.h")
#import "MAMapKit.h"
#endif


@interface AGMViewController : UIViewController

@property (weak, nonatomic) IBOutlet MAMapView *mapView;

@end
