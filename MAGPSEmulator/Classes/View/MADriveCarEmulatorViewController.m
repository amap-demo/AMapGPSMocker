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
@property (nonatomic,strong)  UIPanGestureRecognizer *panGR;
@property (nonatomic,assign)  CGPoint startPoint;
@property (nonatomic,assign)  CGPoint currentPoint;

@end

@implementation MADriveCarEmulatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self initSpeedStepper];
    [self initWheelImageView];
}

- (void)initSpeedStepper {
    self.speedStepper.value = 80;
    self.speedStepper.minimumValue = 0;
    self.speedStepper.maximumValue = 200;
    self.speedStepper.stepValue = 5;
    [self speedStepperValueChanged:self.speedStepper];
}

- (void)initWheelImageView {
    self.wheelImageView.userInteractionEnabled = YES;
    self.panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(wheelPan:)];
    self.panGR.delaysTouchesBegan = YES;
    [self.wheelImageView addGestureRecognizer:self.panGR];
}

- (IBAction)speedStepperValueChanged:(id)sender {
    self.speedLabel.text = [NSString stringWithFormat:@"%.0fkm/h",self.speedStepper.value];
}

- (void)wheelPan:(UIPanGestureRecognizer *)panGR {
    if (panGR.state == UIGestureRecognizerStateBegan) {
        self.startPoint = [panGR locationInView:self.wheelImageView];
        NSLog(@"++++++pan GR begin!");
    } else if (panGR.state == UIGestureRecognizerStateChanged) {
        self.currentPoint = [panGR locationInView:self.wheelImageView];
        double radian = [self rotationFromStartPoint:self.startPoint toEndPoint:self.currentPoint];
        NSLog(@"current roattion:%f",radian * 180/M_PI);
        self.wheelImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, radian);
    } else if (panGR.state == UIGestureRecognizerStateEnded) {//手势结束，同步给模拟器角度
        self.currentPoint = [panGR locationInView:self.wheelImageView];
        double radian = [self rotationFromStartPoint:self.startPoint toEndPoint:self.currentPoint];
        double degree = radian * 180 /M_PI;
        NSLog(@"final rotation:%f",degree);
    } else if (panGR.state == UIGestureRecognizerStateCancelled) {
        NSLog(@"事件被取消");
        self.wheelImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 0);
    }
}

/// 计算手势起点到终点，绕方向盘ImageView的旋转角度
/// @param startPoint 起点坐标
/// @param endPoint 终点坐标
- (double)rotationFromStartPoint:(CGPoint)startPoint toEndPoint:(CGPoint)endPoint {
    CGPoint centerPoint = self.wheelImageView.center;
    startPoint = CGPointMake(startPoint.x - centerPoint.x, startPoint.y - centerPoint.y);
    endPoint = CGPointMake(endPoint.x - centerPoint.x, endPoint.y - centerPoint.y);
    NSLog(@"after Transport startPoint:%@,endPoint:%@",NSStringFromCGPoint(startPoint),NSStringFromCGPoint(endPoint));
    double dianji = startPoint.x * endPoint.x + startPoint.y * endPoint.y;
    double distanceStart = sqrt(startPoint.x * startPoint.x + startPoint.y * startPoint.y);
    double distanceEnd = sqrt(endPoint.x * endPoint.x + endPoint.y * endPoint.y);
    double radian = asin(dianji / (distanceStart * distanceEnd));
    if (endPoint.x < startPoint.x) {//向左，即逆时针旋转，角度为负
        radian = radian * -1;
    }
//    return radian * M_PI / 180;
    return radian;
}





@end
