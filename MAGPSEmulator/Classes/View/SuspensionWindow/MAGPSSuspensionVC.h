//
//  MAGPSSuspensionVC.h
//  MAGPSEmulator
//
//  Created by lly on 2020/3/25.
//

#import <UIKit/UIKit.h>

@class MAGPSSuspensionView;
@protocol MAGPSSuspensionVCDelegate;


@interface MAGPSSuspensionVC : UIViewController

@property (nonatomic, weak) id<MAGPSSuspensionVCDelegate> delegate;

@property (strong, nonatomic) MAGPSSuspensionView *dragableView;

//是否处理触摸事件
- (BOOL)shouldReceiveTouchAtWindowPoint:(CGPoint)pointInWindowCoordinates;

@end


@protocol MAGPSSuspensionVCDelegate <NSObject>

- (void)dragableViewLongPressed:(MAGPSSuspensionVC *)floatingViewController;

@end

