//
//  AMGPSFloatWindowRootVC.m
//  AMGPSEmulator
//
//  Created by lly on 2020/3/25.
//

#import "AMGPSFloatWindowRootVC.h"
#import "AMGPSDragableView.h"

@interface AMGPSFloatWindowRootVC ()

@end

@implementation AMGPSFloatWindowRootVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self _setupDragableView];
}

- (void)_setupDragableView
{
    [self.view addSubview:self.dragableView];
    
    //设置默认位置,这里实际可以不添加任何约束，dragableView和其subView，即contentVC的View建立约束关系，其大小由其subView的约束间接控制
    CGFloat heightOfScreen = [UIScreen mainScreen].bounds.size.height;
    CGFloat widthOfScreen = [UIScreen mainScreen].bounds.size.width;
//    CGFloat widthOfView = MIN(heightOfScreen, widthOfScreen) * 0.3;
    NSArray<NSLayoutConstraint *> *constraints = @[
        [self.dragableView.widthAnchor constraintLessThanOrEqualToConstant:widthOfScreen],
        [self.dragableView.heightAnchor constraintLessThanOrEqualToConstant:heightOfScreen]];
    
    for (NSLayoutConstraint *constraint in constraints) {
        constraint.priority = UILayoutPriorityDefaultHigh;
    }
    [self.view addConstraints:constraints];
    //点击事件和手势
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTap:)];
//    tapGesture.numberOfTapsRequired = 1;
//    [self.dragableView addGestureRecognizer:tapGesture];
    
    //长按不做处理
//    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_handleLongPress:)];
//    longPressGesture.minimumPressDuration = 0.5;
//    [self.dragableView addGestureRecognizer:longPressGesture];
}

#pragma mark - Handle Event

//- (void)_handleTap:(UITapGestureRecognizer *)tapGesture{
////    NSLog(@"点击收拾暂不处理");
//}

//- (void)_handleLongPress:(UILongPressGestureRecognizer *)longPressGesture {
//    if ([self.delegate respondsToSelector:@selector(dragableViewLongPressed:)]) {
//        [self.delegate dragableViewLongPressed:self];
//    }
//}

#pragma mark - Touch Handling

- (BOOL)shouldReceiveTouchAtWindowPoint:(CGPoint)pointInWindowCoordinates
{
    BOOL shouldReceiveTouch = NO;
    
    CGPoint pointInLocalCoordinates = [self.view convertPoint:pointInWindowCoordinates fromView:nil];
    
    if (CGRectContainsPoint(self.dragableView.frame, pointInLocalCoordinates)) {
        shouldReceiveTouch = YES;
    }
    
    if (!shouldReceiveTouch && self.presentedViewController) {
        shouldReceiveTouch = YES;
    }
    
    return shouldReceiveTouch;
}

#pragma mark - Setter & Getter

- (AMGPSDragableView *)dragableView
{
    if (!_dragableView) {
        _dragableView = [[AMGPSDragableView alloc] init];
        _dragableView.backgroundColor = [UIColor clearColor];
        _dragableView.userInteractionEnabled = YES;
//        _dragableView.translatesAutoresizingMaskIntoConstraints = NO;
        [_dragableView setDragEnable:YES];
        [_dragableView setAdsorbEnable:YES];
    }
    return _dragableView;
}


@end
