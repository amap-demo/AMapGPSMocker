//
//  MADriveCarEmulatorViewController.h
//  MAGPSEmulator_Example
//
//  Created by lly on 2020/3/24.
//  Copyright © 2020 xuefeng.lly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MADriveCarEmulatorViewControllerDelegate <NSObject>

- (void)updateSpeed:(CGFloat)currentSpeed;

- (void)updateDirection:(CLLocationDirection)direction;

@end


@interface MADriveCarEmulatorViewController : UIViewController

@property (nonatomic,weak) id<MADriveCarEmulatorViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
