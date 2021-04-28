//
//  AGMFloatWindow.h
//  AMapGPSMocker
//
//  Created by lly on 2020/3/25.
//

#import <UIKit/UIKit.h>

@protocol AGMFloatWindowDelegate;

@interface AGMFloatWindow : UIWindow

@property (weak, nonatomic) id<AGMFloatWindowDelegate> eventDelegate;

@end


@protocol AGMFloatWindowDelegate <NSObject>

- (BOOL)shouldHandleTouchAtPoint:(CGPoint)pointInWindow;

@end
