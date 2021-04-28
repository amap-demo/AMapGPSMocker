//
//  AGMFloatWindowRootVC.h
//  AMapGPSMocker
//
//  Created by lly on 2020/3/25.
//

#import <UIKit/UIKit.h>

@class AGMDragableView;
@protocol AGMFloatWindowRootVCDelegate;

@interface AGMFloatWindowRootVC : UIViewController

@property (nonatomic, weak) id<AGMFloatWindowRootVCDelegate> delegate;

@property (strong, nonatomic) AGMDragableView *dragableView;

//是否处理触摸事件
- (BOOL)shouldReceiveTouchAtWindowPoint:(CGPoint)pointInWindowCoordinates;

@end


@protocol AGMFloatWindowRootVCDelegate <NSObject>

- (void)dragableViewLongPressed:(AGMFloatWindowRootVC *)floatingViewController;

@end

