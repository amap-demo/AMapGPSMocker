//
//  MARotaryWheel.m
//  MAGPSEmulator
//
//  Created by lly on 2020/9/7.
//

#import "MARotaryWheel.h"

@interface MARotaryWheel ()

@property (nonatomic,assign,readwrite) NSInteger numberOfSections;
@property (nonatomic,assign,readwrite) CGFloat currentValue;
@property (nonatomic, strong) UIView *container;
@property (nonatomic,assign) CGAffineTransform startTransform;

@end

static float deltaAngle;

@implementation MARotaryWheel

- (instancetype)initWithFrame:(CGRect)frame
                     sections:(NSInteger)sections
                  AndDelegate:(id<MARotaryWheelDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        self.currentValue = 0;
        self.numberOfSections = sections;
        self.delegate = delegate;
        [self drawWheel];
    }
    return self;
}

- (void)drawWheel {
    self.container = [[UIView alloc] initWithFrame:self.frame];
    self.container.userInteractionEnabled = NO;
    [self addSubview:self.container];
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.container.frame];
    bg.image = [UIImage imageNamed:@"wheel.png"];
    [self.container addSubview:bg];
    
    UIImageView *mask = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 58, 58)];
    mask.image =[UIImage imageNamed:@"centerButton.png"] ;
    mask.center = self.center;
    mask.center = CGPointMake(mask.center.x, mask.center.y+3);
    [self addSubview:mask];
    
    [self.delegate wheelDidChangeValue:self.currentValue];
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
    if (dist < 40 || dist > 100) {//圆盘的中心和外边沿界限
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
    if (dist < 40 || dist > 100) {//圆盘的中心和外边沿界限
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
    return YES;
}

- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event {
    CGFloat radians = atan2f(self.container.transform.b, self.container.transform.a);
    [self.delegate wheelDidChangeValue:radians];
}




@end
