//
//  AMGPSRotaryWheel.m
//  AMGPSEmulator
//
//  Created by lly on 2020/9/7.
//

#import "AMGPSRotaryWheel.h"

@interface AMGPSRotaryWheel ()

@property (nonatomic,assign,readwrite) CGFloat currentValue;
@property (nonatomic,strong) UIView *container;
@property (nonatomic,assign) CGAffineTransform startTransform;

@property (nonatomic,assign) CGFloat centerImageWidth;
@property (nonatomic,assign) CGFloat minTouchDistance;
@property (nonatomic,assign) CGFloat maxTouchDistance;

@end

static float deltaAngle;

@implementation AMGPSRotaryWheel

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInitWithFrame:self.frame];
}

- (instancetype)initWithFrame:(CGRect)frame
                  AndDelegate:(id<MARotaryWheelDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        [self commonInitWithFrame:frame];
    }
    return self;
}

- (void)commonInitWithFrame:(CGRect)frame {
    self.currentValue = 0;
    self.centerImageWidth = frame.size.width * 0.30;//总宽度的30%
    self.minTouchDistance = self.centerImageWidth / sqrt(2);
    self.maxTouchDistance = frame.size.width / 2.0;
    [self drawWheel];
}

- (void)drawWheel {
    self.container = [[UIView alloc] initWithFrame:self.bounds];
    self.container.userInteractionEnabled = NO;
    [self addSubview:self.container];
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.container.bounds];
    bg.image = [UIImage imageNamed:@"wheel.png"];
    [self.container addSubview:bg];
    
    UIImageView *centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.centerImageWidth, self.centerImageWidth)];
    centerImageView.image =[UIImage imageNamed:@"center_btn.png"] ;
    centerImageView.center = self.center;
    centerImageView.center = CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y);
    [self addSubview:centerImageView];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(wheelDidChangeValue:)]) {
        [self.delegate wheelDidChangeValue:self.currentValue];
    }
}

- (float)calculateDistanceFromCenter:(CGPoint)point {
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    float dx = point.x - center.x;
    float dy = point.y - center.y;
    return sqrt(dx*dx + dy*dy);
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    float dist = [self calculateDistanceFromCenter:touchPoint];
    if (dist < self.minTouchDistance || dist > self.maxTouchDistance) {//圆盘的中心和外边沿界限
        // forcing a tap to be on the ferrule
        NSLog(@"ignoring tap (%f,%f)", touchPoint.x, touchPoint.y);
        return NO;
    }
    
    float dx = touchPoint.x - self.container.center.x;
    float dy = touchPoint.y - self.container.center.y;
    deltaAngle = atan2(dy,dx);

    self.startTransform = self.container.transform;
    
    return YES;
    
}

- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event {
        
    CGPoint pt = [touch locationInView:self];
    float dist = [self calculateDistanceFromCenter:pt];
    if (dist < self.minTouchDistance || dist > self.maxTouchDistance) {//圆盘的中心和外边沿界限
        // a drag path too close to the center
        NSLog(@"drag path too close to the center (%f,%f)", pt.x, pt.y);
        // here you might want to implement your solution when the drag
        // is too close to the center
        // You might go back to the clove previously selected
        // or you might calculate the clove corresponding to
        // the "exit point" of the drag.
    }
    
    float dx = pt.x  - self.container.center.x;
    float dy = pt.y  - self.container.center.y;
    float ang = atan2(dy,dx);
    
    float angleDifference = deltaAngle - ang;
    self.container.transform = CGAffineTransformRotate(self.startTransform, -angleDifference);
    self.currentValue = atan2f(self.container.transform.b, self.container.transform.a);
    if (self.delegate && [self.delegate respondsToSelector:@selector(wheelDidChangeValue:)]) {
        [self.delegate wheelDidChangeValue:self.currentValue];
    }
    return YES;
}

- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event {
    self.currentValue = atan2f(self.container.transform.b, self.container.transform.a);
    if (self.delegate && [self.delegate respondsToSelector:@selector(wheelDidChangeValue:)]) {
        [self.delegate wheelDidChangeValue:self.currentValue];
    }
}

@end
