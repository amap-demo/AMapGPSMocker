//
//  MAGPSSuspensionManager.m
//  MAGPSEmulator
//
//  Created by lly on 2020/3/25.
//


#import "MAGPSSuspensionManager.h"
#import "MAGPSSuspensionWindow.h"
#import "MAGPSSuspensionVC.h"

@interface MAGPSSuspensionManager () <MAGPSSuspensionWindowDelegate, MAGPSSuspensionVCDelegate>

@property (nonatomic,strong) MAGPSSuspensionWindow  *suspensionWindow;
@property (nonatomic,strong) MAGPSSuspensionVC      *suspensionVC;
@property (nonatomic,weak)   UIViewController *contentVC;


@end

@implementation MAGPSSuspensionManager

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
        _suspensionWindow = nil;
        _suspensionVC = nil;
    }
    return self;
}

#pragma mark - Public Function

+ (instancetype)sharedManager
{
    static MAGPSSuspensionManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[MAGPSSuspensionManager alloc] _init];
    });
    
    return sharedManager;
}

- (void)showWithContent:(UIViewController *)subVC {
    if (!subVC) {
        return;
    }
    
    _suspensionVC = [[MAGPSSuspensionVC alloc] init];
    _suspensionVC.delegate = self;
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= 1;
    _suspensionWindow = [[MAGPSSuspensionWindow alloc] initWithFrame:frame];
    _suspensionWindow.eventDelegate = self;
    _suspensionWindow.rootViewController = _suspensionVC;
    
    self.contentVC = subVC;
    
    UIViewController *floatingVC = self.suspensionVC;
    UIView *placeholdView = (UIView *)self.suspensionVC.dragableView;
    
    [floatingVC addChildViewController:subVC];
    [placeholdView addSubview:subVC.view];
    subVC.view.frame = placeholdView.bounds;
    [subVC didMoveToParentViewController:floatingVC];
    [placeholdView addConstraints:@[[subVC.view.leadingAnchor constraintEqualToAnchor:placeholdView.leadingAnchor],
                                    [subVC.view.trailingAnchor constraintEqualToAnchor:placeholdView.trailingAnchor],
                                    [subVC.view.topAnchor constraintEqualToAnchor:placeholdView.topAnchor],
                                    [subVC.view.bottomAnchor constraintEqualToAnchor:placeholdView.bottomAnchor]]];
    
    self.suspensionWindow.hidden = NO;
}

- (void)hideAndDestroy {
    self.suspensionWindow.hidden = YES;
    
    _suspensionWindow = nil;
    _suspensionVC = nil;
}

#pragma mark - MAGPSSuspensionWindowDelegate

- (BOOL)shouldHandleTouchAtPoint:(CGPoint)pointInWindow
{
    return [self.suspensionVC shouldReceiveTouchAtWindowPoint:pointInWindow];
}

#pragma mark - MAGPSSuspensionVCDelegate

//浮窗长按事件处理
- (void)dragableViewLongPressed:(MAGPSSuspensionVC *)suspensionVC
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideAndDestroy];
    });
}

@end
