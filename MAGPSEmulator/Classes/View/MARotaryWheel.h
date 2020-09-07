//
//  MARotaryWheel.h
//  MAGPSEmulator
//
//  Created by lly on 2020/9/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MARotaryWheelDelegate <NSObject>


/// 选择的角度更新
/// @param currentValue 当前的角度值（单位：弧度）
- (void)wheelDidChangeValue:(CGFloat)currentValue;

@end

//旋转方向盘的视图类
@interface MARotaryWheel : UIControl

@property (nonatomic,weak) id<MARotaryWheelDelegate> delegate;
//当前的圆盘角度,从(-M_PI,M_PI]之间，向右顺时针为正角度，向左逆时针为负角度
@property (nonatomic,assign,readonly) CGFloat currentValue;

- (instancetype)initWithFrame:(CGRect)frame
                  AndDelegate:(id<MARotaryWheelDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
