//
//  AGMViewController.h
//  AMapGPSMocker
//
//  Created by xuefeng.lly on 03/23/2020.
//  Copyright (c) 2020 xuefeng.lly. All rights reserved.
//

@import UIKit;
#import <MAMapKit/MAMapKit.h>

@interface AGMViewController : UIViewController

@property (weak, nonatomic) IBOutlet MAMapView *mapView;

@end