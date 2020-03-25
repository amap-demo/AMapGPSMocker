//
//  MAGPSSuspensionVC.m
//  MAGPSEmulator
//
//  Created by lly on 2020/3/25.
//

#import "MAGPSSuspensionVC.h"
#import "MAGPSSuspensionView.h"

@interface MAGPSSuspensionVC ()

@end

@implementation MAGPSSuspensionVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self _setupDragableView];
}

- (void)_setupDragableView
{
    [self.view addSubview:self.dragableView];
    
    
    //设置默认位置
    [self.view addSubview:self.dragableView];

//    CGFloat heightOfScreen = [UIScreen mainScreen].bounds.size.height;
//    CGFloat widthOfScreen = [UIScreen mainScreen].bounds.size.width;
//    CGFloat widthOfVideo = MIN(heightOfScreen, widthOfScreen) * 0.4;
//    self.dragableView.frame = CGRectMake(widthOfScreen - (widthOfVideo + 10), 150.0f, widthOfVideo, widthOfVideo*9/16);
    
//    [self.dragableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
//    [self.dragableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:150.0f];
//    [self.dragableView autoSetDimension:ALDimensionWidth toSize:widthOfVideo];
//    [self.dragableView autoSetDimension:ALDimensionHeight toSize:widthOfVideo * 9 / 16];
    
    //点击事件和手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTap:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.dragableView addGestureRecognizer:tapGesture];
    
    //长按不做处理
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_handleLongPress:)];
    longPressGesture.minimumPressDuration = 0.5;
    [self.dragableView addGestureRecognizer:longPressGesture];
}

#pragma mark - Handle Event

- (void)_handleTap:(UITapGestureRecognizer *)tapGesture
{
    if ([self.delegate respondsToSelector:@selector(dragableViewDidClicked:)]) {
        [self.delegate dragableViewDidClicked:self];
    }
}

- (void)_handleLongPress:(UILongPressGestureRecognizer *)longPressGesture
{
//    NSLog(@"长按不跳转");
}

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

- (MAGPSSuspensionView *)dragableView
{
    if (!_dragableView) {
        _dragableView = [[MAGPSSuspensionView alloc] init];
        _dragableView.backgroundColor = [UIColor clearColor];
        _dragableView.userInteractionEnabled = YES;
        [_dragableView setDragEnable:YES];
        [_dragableView setAdsorbEnable:YES];
    }
    return _dragableView;
}


@end
