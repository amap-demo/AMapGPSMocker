//
//  AMGPSMenuViewController.m
//  MAGPSEmulator
//
//  Created by lly on 2021/4/27.
//

#import "AMGPSMenuViewController.h"
#import "AMGPSPositionEditViewController.h"
#import "AMGPSFloatWindowManager.h"
#import "AMGPSHomeBtnViewController.h"

@interface AMGPSMenuViewController ()

@property (nonatomic,strong) UIButton *singlePosBtn;
@property (nonatomic,strong) UIButton *routePosBtn;
@property (nonatomic,strong) UIButton *gobackBtn;

@end

@implementation AMGPSMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.singlePosBtn = [self creatBtnWithTitle:@"单点" andAction:@selector(singlePosBtnClicked:)];
    self.routePosBtn = [self creatBtnWithTitle:@"多点" andAction:@selector(routePosBtnClicked:)];
    self.gobackBtn = [self creatBtnWithTitle:@"返回" andAction:@selector(gobackBtnClicked:)];
    [self.view addSubview:_singlePosBtn];
    [self.view addSubview:_routePosBtn];
    [self.view addSubview:_gobackBtn];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.view.widthAnchor constraintEqualToConstant:100],
        [self.view.heightAnchor constraintEqualToConstant:125],
        [_singlePosBtn.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [_singlePosBtn.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [_routePosBtn.topAnchor constraintEqualToAnchor:_singlePosBtn.bottomAnchor constant:25],
        [_routePosBtn.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [_routePosBtn.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [_gobackBtn.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [_gobackBtn.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];
}

- (UIButton *)creatBtnWithTitle:(NSString *)title andAction:(SEL)action {
    UIButton *btn = [[UIButton alloc] init];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [NSLayoutConstraint activateConstraints:@[
        [btn.widthAnchor constraintEqualToConstant:50],
        [btn.heightAnchor constraintEqualToConstant:50]
    ]];
    btn.layer.cornerRadius = 25.0;
    [btn addTarget:self
            action:action
  forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)singlePosBtnClicked:(id)sender {
    AMGPSPositionEditViewController *posEditVC = [[AMGPSPositionEditViewController alloc] initWithNibName:NSStringFromClass([AMGPSPositionEditViewController class]) bundle:nil];
    [[AMGPSFloatWindowManager sharedManager].rootVC presentViewController:posEditVC
                                                                 animated:YES
                                                               completion:nil];
}

- (void)routePosBtnClicked:(id)sender {
    NSLog(@"route clicked！");
}

- (void)gobackBtnClicked:(id)sender {
    AMGPSHomeBtnViewController *homeVC = [[AMGPSHomeBtnViewController alloc] init];
    [[AMGPSFloatWindowManager sharedManager] showWithContent:homeVC];
}

@end
