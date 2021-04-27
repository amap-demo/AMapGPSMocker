//
//  AMGPSFloatWindow.h
//  AMGPSEmulator
//
//  Created by lly on 2020/3/25.
//

#import <UIKit/UIKit.h>

@protocol MAGPSSuspensionWindowDelegate;

@interface AMGPSFloatWindow : UIWindow

@property (weak, nonatomic) id<MAGPSSuspensionWindowDelegate> eventDelegate;

@end


@protocol MAGPSSuspensionWindowDelegate <NSObject>

- (BOOL)shouldHandleTouchAtPoint:(CGPoint)pointInWindow;

@end
