//
//  AGMDriveCarEmulatorViewController.h
//  AMapGPSMocker
//
//  Created by lly on 2020/3/24.
//  Copyright © 2020 xuefeng.lly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AGMDriveCarEmulatorViewControllerDelegate <NSObject>

- (void)updateSpeed:(CGFloat)currentSpeed;

- (void)updateDirection:(CLLocationDirection)direction;

@end


@interface AGMDriveCarEmulatorViewController : UIViewController

@property (nonatomic,weak) id<AGMDriveCarEmulatorViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
