//
//  HomeBtnViewController.m
//  MAGPSEmulator
//
//  Created by lly on 2021/4/26.
//

#import "AMGPSHomeBtnViewController.h"
#import "MADriveCarEmulatorViewController.h"
#import "AMGPSFloatWindowManager.h"

CGFloat const kBtnWidth = 50.0;

@interface AMGPSHomeBtnViewController ()

@property (nonatomic,strong) UIButton *homeBtn;

@end

@implementation AMGPSHomeBtnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.homeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kBtnWidth, kBtnWidth)];
    _homeBtn.backgroundColor = [UIColor whiteColor];
    [_homeBtn setTitle:@"GPS" forState:UIControlStateNormal];
    [_homeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _homeBtn.layer.cornerRadius = kBtnWidth/2;
    [_homeBtn addTarget:self action:@selector(homeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_homeBtn];
    
    [NSLayoutConstraint activateConstraints:@[
        [NSLayoutConstraint constraintWithItem:_homeBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0],
        [NSLayoutConstraint constraintWithItem:_homeBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0],
        [NSLayoutConstraint constraintWithItem:_homeBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
        [NSLayoutConstraint constraintWithItem:_homeBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]
    ]];
}

- (void)homeBtnClicked:(id)sender {
    MADriveCarEmulatorViewController *driverCarVC = [[MADriveCarEmulatorViewController alloc] initWithNibName:NSStringFromClass([MADriveCarEmulatorViewController class])
                                                                          bundle:nil];
    AMGPSFloatWindowManager *floatingWindowManager = [AMGPSFloatWindowManager sharedManager];
    [floatingWindowManager showWithContent:driverCarVC];
//    self.driverCarVC.delegate = self;
}

@end
