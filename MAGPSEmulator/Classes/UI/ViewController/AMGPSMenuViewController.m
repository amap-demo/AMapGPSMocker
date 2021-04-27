//
//  AMGPSMenuViewController.m
//  MAGPSEmulator
//
//  Created by lly on 2021/4/27.
//

#import "AMGPSMenuViewController.h"
#import "AMGPSPostionEditViewController.h"
#import "AMGPSFloatWindowManager.h"

@interface AMGPSMenuViewController ()

@property (nonatomic,strong) UIButton *singlePosBtn;
@property (nonatomic,strong) UIButton *routePosBtn;

@end

@implementation AMGPSMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.singlePosBtn = [self creatBtnWithTitle:@"单点" andAction:@selector(singlePosBtnClicked:)];
    self.routePosBtn = [self creatBtnWithTitle:@"多点" andAction:@selector(routePosBtn:)];
    [self.view addSubview:_singlePosBtn];
    [self.view addSubview:_routePosBtn];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.view.widthAnchor constraintEqualToConstant:100],
        [self.view.heightAnchor constraintEqualToConstant:125],
        [_singlePosBtn.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [_singlePosBtn.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [_routePosBtn.topAnchor constraintEqualToAnchor:_singlePosBtn.bottomAnchor constant:25],
        [_routePosBtn.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [_routePosBtn.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
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
    AMGPSPostionEditViewController *posEditVC = [[AMGPSPostionEditViewController alloc] initWithNibName:NSStringFromClass([AMGPSPostionEditViewController class]) bundle:nil];
    [[AMGPSFloatWindowManager sharedManager].rootVC presentViewController:posEditVC
                                                                 animated:YES
                                                               completion:nil];
//    [[AMGPSFloatWindowManager sharedManager] showWithContent:posEditVC];
}

- (void)routePosBtn:(id)sender {
    NSLog(@"route clicked！");
}

@end
