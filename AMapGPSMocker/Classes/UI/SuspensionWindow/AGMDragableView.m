//
//  AGMDragableView.m
//  AMapGPSMocker
//
//  Created by lly on 2020/3/25.
//

#import "AGMDragableView.h"
#import <objc/runtime.h>

static CGFloat const kDefaultMargin = 60.0f;
static CGFloat const kDefaultPadding = 5.0f;

@interface AGMDragableView ()

@property (assign, nonatomic) CGPoint       beginPoint;

@end

@implementation AGMDragableView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.dragEnable = NO;
        self.adsorbEnable = NO;
    }
    
    return self;
}

#pragma mark - Touch Event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isDragEnable) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    self.beginPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isDragEnable) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    CGFloat offsetX = currentPoint.x - self.beginPoint.x;
    CGFloat offsetY = currentPoint.y - self.beginPoint.y;
    int positionX = self.center.x + offsetX;
    int positionY = self.center.y + offsetY;
    
    self.center = CGPointMake(positionX, positionY);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isDragEnable) {
        return;
    }
    [self _adjustDragableViewPosition];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isDragEnable) {
        return;
    }
    [self _adjustDragableViewPosition];
}

#pragma mark - Private Function

//吸边
- (void)_adjustDragableViewPosition
{
    if (self.superview && self.isAdsorbEnable) {
        float marginLeft = self.frame.origin.x;
        float marginRight = self.superview.frame.size.width - self.frame.origin.x - self.frame.size.width;
        float marginTop = self.frame.origin.y;
        float marginBottom = self.superview.frame.size.height - self.frame.origin.y - self.frame.size.height;
        
        if (!self.padding || self.padding <= 0) {
            self.padding = kDefaultPadding;
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            if (marginTop < kDefaultMargin) {
                CGFloat x = marginLeft < marginRight ? marginLeft < self.padding ? self.padding : self.frame.origin.x : marginRight < self.padding ? self.superview.frame.size.width - self.frame.size.width - self.padding : self.frame.origin.x;
                self.frame = CGRectMake(x, self.padding, self.frame.size.width, self.frame.size.height);
            }
            else if (marginBottom < kDefaultMargin) {
                CGFloat x = marginLeft < marginRight ? marginLeft < self.padding ? self.padding : self.frame.origin.x : marginRight < self.padding ? self.superview.frame.size.width - self.frame.size.width - self.padding : self.frame.origin.x;
                self.frame = CGRectMake(x, self.superview.frame.size.height - self.frame.size.height - self.padding, self.frame.size.width, self.frame.size.height);
            }
            else {
                CGFloat x = marginLeft < marginRight ? self.padding : self.superview.frame.size.width - self.frame.size.width - self.padding;
                self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
            }
        }];
    }
}

@end
