//
//  MARotaryWheel.h
//  MAGPSEmulator
//
//  Created by lly on 2020/9/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MARotaryWheelDelegate <NSObject>

- (void)wheelDidChangeValue:(CGFloat)value;

@end

//旋转方向盘的视图类
@interface MARotaryWheel : UIControl

@property (nonatomic,weak) id<MARotaryWheelDelegate> delegate;
//当前的圆盘角度
@property (nonatomic,assign,readonly) CGFloat currentValue;

- (instancetype)initWithFrame:(CGRect)frame
                  AndDelegate:(id<MARotaryWheelDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
