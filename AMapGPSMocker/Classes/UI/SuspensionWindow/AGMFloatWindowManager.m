//
//  AGMFloatWindowManager.m
//  AMapGPSMocker
//
//  Created by lly on 2020/3/25.
//


#import "AGMFloatWindowManager.h"
#import "AGMFloatWindow.h"
#import "AGMFloatWindowRootVC.h"
#import "AGMHomeBtnViewController.h"

@interface AGMFloatWindowManager () <AGMFloatWindowDelegate, AGMFloatWindowRootVCDelegate>

@property (nonatomic,strong) AGMFloatWindow *floatWindow;
@property (nonatomic,weak)   UIViewController *contentVC;


@end

@implementation AGMFloatWindowManager

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

+ (instancetype)sharedManager {
    static AGMFloatWindowManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[AGMFloatWindowManager alloc] _init];
    });
    
    return sharedManager;
}

/// 展示默认浮框
- (void)showFloatWindow {
    AGMHomeBtnViewController *homeVC = [[AGMHomeBtnViewController alloc] init];
    [self showWithContent:homeVC];
}

- (void)showWithContent:(UIViewController *)contentVC {
    if (!contentVC) {
        return;
    }
    
    _rootVC = [[AGMFloatWindowRootVC alloc] init];
    _rootVC.delegate = self;
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    screenBounds.size.height -= 1;
    _floatWindow = [[AGMFloatWindow alloc] initWithFrame:screenBounds];
    _floatWindow.eventDelegate = self;
    _floatWindow.rootViewController = _rootVC;
    
    self.contentVC = contentVC;
    [self.contentVC.view layoutIfNeeded];
    CGRect contentFrame = self.contentVC.view.frame;
    
    UIViewController *floatingVC = self.rootVC;
    UIView *dragableView = (UIView *)self.rootVC.dragableView;
    
    [floatingVC addChildViewController:contentVC];
    [dragableView addSubview:contentVC.view];
    [contentVC didMoveToParentViewController:floatingVC];
    
    CGRect dragableViewFrame = dragableView.frame;
    dragableViewFrame = CGRectMake(dragableViewFrame.origin.x, dragableViewFrame.origin.y, contentFrame.size.width, contentFrame.size.height);
    
    CGRect curFrame = dragableViewFrame;
    CGPoint curRightCenterPoint = CGPointMake(curFrame.origin.x + curFrame.size.width, curFrame.origin.y + curFrame.size.height/2.0);
    CGPoint screenRightCenterPoint = CGPointMake(screenBounds.size.width, screenBounds.size.height/2.0);
    CGPoint diffPoint = CGPointMake(screenRightCenterPoint.x - curRightCenterPoint.x, screenRightCenterPoint.y - curRightCenterPoint.y);
    CGRect updateFrame = CGRectMake(curFrame.origin.x + diffPoint.x, curFrame.origin.y + diffPoint.y, curFrame.size.width, curFrame.size.height);
    dragableView.frame = updateFrame;
    
    self.floatWindow.hidden = NO;
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
- (void)dragableViewLongPressed:(AGMFloatWindowRootVC *)suspensionVC
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideAndDestroy];
    });
}

@end
