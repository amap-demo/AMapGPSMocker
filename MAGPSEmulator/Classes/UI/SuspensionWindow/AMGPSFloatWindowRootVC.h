//
//  AMGPSFloatWindowRootVC.h
//  AMGPSEmulator
//
//  Created by lly on 2020/3/25.
//

#import <UIKit/UIKit.h>

@class AMGPSDragableView;
@protocol MAGPSSuspensionVCDelegate;

@interface AMGPSFloatWindowRootVC : UIViewController

@property (nonatomic, weak) id<MAGPSSuspensionVCDelegate> delegate;

@property (strong, nonatomic) AMGPSDragableView *dragableView;

//是否处理触摸事件
- (BOOL)shouldReceiveTouchAtWindowPoint:(CGPoint)pointInWindowCoordinates;

@end


@protocol MAGPSSuspensionVCDelegate <NSObject>

- (void)dragableViewLongPressed:(AMGPSFloatWindowRootVC *)floatingViewController;

@end

