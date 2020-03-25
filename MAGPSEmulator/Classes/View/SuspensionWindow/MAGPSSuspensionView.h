//
//  MAGPSSuspensionView.h
//  MAGPSEmulator
//
//  Created by lly on 2020/3/25.
//

#import <UIKit/UIKit.h>

extern CGFloat const kDefaultWidth;

@interface MAGPSSuspensionView : UIView

//是否可以拖动
@property (nonatomic, assign, getter = isDragEnable)    BOOL dragEnable;

//是否自动吸附到屏幕边缘
@property (nonatomic, assign, getter = isAdsorbEnable)  BOOL adsorbEnable;

//view吸附到边缘后与屏幕边缘的距离，如果没有设置者取默认值5.0
@property (nonatomic, assign)                           CGFloat padding;

@end
