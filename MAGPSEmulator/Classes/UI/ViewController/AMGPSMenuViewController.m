//
//  AMGPSMenuViewController.m
//  MAGPSEmulator
//
//  Created by lly on 2021/4/27.
//

#import "AMGPSMenuViewController.h"

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
        [NSLayoutConstraint constraintWithItem:_singlePosBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0],
        [NSLayoutConstraint constraintWithItem:_singlePosBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0],
        [NSLayoutConstraint constraintWithItem:_singlePosBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
        [NSLayoutConstraint constraintWithItem:_routePosBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_singlePosBtn attribute:NSLayoutAttributeBottom multiplier:1.0 constant:25],
        [NSLayoutConstraint constraintWithItem:_routePosBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]
    ]];
}

- (UIButton *)creatBtnWithTitle:(NSString *)title andAction:(SEL)action {
    UIButton *btn = [[UIButton alloc] init];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [NSLayoutConstraint activateConstraints:@[
        [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50],
        [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50]
    ]];
    btn.layer.cornerRadius = 25.0;
    [btn addTarget:self
            action:action
  forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)singlePosBtnClicked:(id)sender {
    NSLog(@"single clicked！");
}

- (void)routePosBtn:(id)sender {
    NSLog(@"route clicked！");
}

@end
