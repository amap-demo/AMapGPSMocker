//
//  AMGPSFloatWindowManager.m
//  AMGPSEmulator
//
//  Created by lly on 2020/3/25.
//


#import "AMGPSFloatWindowManager.h"
#import "AMGPSFloatWindow.h"
#import "AMGPSFloatWindowRootVC.h"

@interface AMGPSFloatWindowManager () <MAGPSSuspensionWindowDelegate, MAGPSSuspensionVCDelegate>

@property (nonatomic,strong) AMGPSFloatWindow *floatWindow;
@property (nonatomic,strong) AMGPSFloatWindowRootVC *rootVC;
@property (nonatomic,weak)   UIViewController *contentVC;


@end

@implementation AMGPSFloatWindowManager

#pragma mark - Publick Function

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"MAGPSSuspensionManager init error" reason:@"Use 'sharedManager' to get instance." userInfo:nil];
    return [super init];
}

- (instancetype)_init
{
    self = [super init];
    if (self) {
        _floatWindow = nil;
        _rootVC = nil;
    }
    return self;
}

#pragma mark - Public Function

+ (instancetype)sharedManager
{
    static AMGPSFloatWindowManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[AMGPSFloatWindowManager alloc] _init];
    });
    
    return sharedManager;
}

- (void)showWithContent:(UIViewController *)contentVC {
    if (!contentVC) {
        return;
    }
    
    _rootVC = [[AMGPSFloatWindowRootVC alloc] init];
    _rootVC.delegate = self;
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    screenBounds.size.height -= 1;
    _floatWindow = [[AMGPSFloatWindow alloc] initWithFrame:screenBounds];
    _floatWindow.eventDelegate = self;
    _floatWindow.rootViewController = _rootVC;
    
    self.contentVC = contentVC;
    
    UIViewController *floatingVC = self.rootVC;
    UIView *dragableView = (UIView *)self.rootVC.dragableView;
    
    [floatingVC addChildViewController:contentVC];
    [dragableView addSubview:contentVC.view];
    [contentVC didMoveToParentViewController:floatingVC];
    [dragableView addConstraints:@[[contentVC.view.leadingAnchor constraintEqualToAnchor:dragableView.leadingAnchor],
                                    [contentVC.view.trailingAnchor constraintEqualToAnchor:dragableView.trailingAnchor],
                                    [contentVC.view.topAnchor constraintEqualToAnchor:dragableView.topAnchor],
                                    [contentVC.view.bottomAnchor constraintEqualToAnchor:dragableView.bottomAnchor]]];
    self.floatWindow.hidden = NO;
    [self.floatWindow layoutIfNeeded];
    [self setDragableViewDefaultPostion];
}


/// 设置可拖拽视图的默认位置(屏幕右侧，中间位置)
- (void)setDragableViewDefaultPostion {
    UIView *dragableView = (UIView *)self.rootVC.dragableView;
    CGRect curFrame = dragableView.frame;
    CGPoint curRightCenterPoint = CGPointMake(curFrame.origin.x + curFrame.size.width, curFrame.origin.y + curFrame.size.height/2.0);
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGPoint screenRightCenterPoint = CGPointMake(screenBounds.size.width, screenBounds.size.height/2.0);
    CGPoint diffPoint = CGPointMake(screenRightCenterPoint.x - curRightCenterPoint.x, screenRightCenterPoint.y - curRightCenterPoint.y);
    CGRect updateFrame = CGRectMake(curFrame.origin.x + diffPoint.x, curFrame.origin.y + diffPoint.y, curFrame.size.width, curFrame.size.height);
    dragableView.frame = updateFrame;
}

- (void)hideAndDestroy {
    self.floatWindow.hidden = YES;
    
    _floatWindow = nil;
    _rootVC = nil;
}

#pragma mark - MAGPSSuspensionWindowDelegate

- (BOOL)shouldHandleTouchAtPoint:(CGPoint)pointInWindow {
    return [self.rootVC shouldReceiveTouchAtWindowPoint:pointInWindow];
}

#pragma mark - MAGPSSuspensionVCDelegate

//浮窗长按事件处理
- (void)dragableViewLongPressed:(AMGPSFloatWindowRootVC *)suspensionVC
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideAndDestroy];
    });
}

@end
