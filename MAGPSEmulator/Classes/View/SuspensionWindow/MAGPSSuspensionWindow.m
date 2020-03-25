//
//  MAGPSSuspensionWindow.m
//  MAGPSEmulator
//
//  Created by lly on 2020/3/25.
//

#import "MAGPSSuspensionWindow.h"

@implementation MAGPSSuspensionWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //windowLevel设置UIWindowLevelNormal + 1是防止视频浮窗盖住UIAlertView。
        self.windowLevel = UIWindowLevelNormal + 1;
    }
    return self;
}

//判断用户点击的区域是否在window的rootViewController的目标区域之中，只有在目标区域之中该window才接收触摸事件。
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL pointInside = NO;
    if ([self.eventDelegate shouldHandleTouchAtPoint:point]) {
        pointInside = [super pointInside:point withEvent:event];
    }
    
    return pointInside;
}

@end
