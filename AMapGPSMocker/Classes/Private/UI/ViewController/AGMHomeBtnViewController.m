//
//  AGMHomeBtnViewController.m
//  AMapGPSMocker
//
//  Created by lly on 2021/4/26.
//

#import "AGMHomeBtnViewController.h"
#import "AGMFloatWindowManager.h"
#import "AGMMenuViewController.h"

CGFloat const kBtnWidth = 50.0;

@interface AGMHomeBtnViewController ()

@property (nonatomic,strong) UIButton *homeBtn;

@end

@implementation AGMHomeBtnViewController

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
        [_homeBtn.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [_homeBtn.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [_homeBtn.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [_homeBtn.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

- (void)homeBtnClicked:(id)sender {
    AGMMenuViewController *menuVC = [[AGMMenuViewController alloc] init];
    [[AGMFloatWindowManager sharedManager] showWithContent:menuVC];
}

@end
