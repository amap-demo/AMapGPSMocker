//
//  MADriveCarEmulatorViewController.m
//  MAGPSEmulator_Example
//
//  Created by lly on 2020/3/24.
//  Copyright © 2020 xuefeng.lly. All rights reserved.
//

#import "MADriveCarEmulatorViewController.h"
#import "AMGPSRotaryWheel.h"

@interface MADriveCarEmulatorViewController ()<MARotaryWheelDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *mileageLable;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *speedLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIStepper *speedStepper;
@property (unsafe_unretained, nonatomic) IBOutlet AMGPSRotaryWheel *wheel;

@end

@implementation MADriveCarEmulatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self initSpeedStepper];
    
    self.wheel.delegate = self;
}

- (void)initSpeedStepper {
    self.speedStepper.value = 80;
    self.speedStepper.minimumValue = 0;
    self.speedStepper.maximumValue = 200;
    self.speedStepper.stepValue = 5;
    [self speedStepperValueChanged:self.speedStepper];
}

- (IBAction)speedStepperValueChanged:(id)sender {
    self.speedLabel.text = [NSString stringWithFormat:@"%.0fkm/h",self.speedStepper.value];
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateSpeed:)]) {
        [self.delegate updateSpeed:self.speedStepper.value];
    }
}

- (void)wheelDidChangeValue:(CGFloat)currentValue {
    if (currentValue < 0) {
        currentValue = 2 * M_PI + currentValue;
    }
    CGFloat degree = currentValue * 180 / M_PI;
    NSLog(@"current Degree:%f",degree);
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateDirection:)]) {
        [self.delegate updateDirection:degree];
    }
}


@end
