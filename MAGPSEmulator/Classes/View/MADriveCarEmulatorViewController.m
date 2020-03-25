//
//  MADriveCarEmulatorViewController.m
//  MAGPSEmulator_Example
//
//  Created by lly on 2020/3/24.
//  Copyright © 2020 xuefeng.lly. All rights reserved.
//

#import "MADriveCarEmulatorViewController.h"

@interface MADriveCarEmulatorViewController ()

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *mileageLable;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *speedLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIStepper *speedStepper;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *wheelImageView;

@end

@implementation MADriveCarEmulatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self initSpeedStepper];
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
}



@end
