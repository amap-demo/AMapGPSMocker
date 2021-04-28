//
//  AGMDragableView.h
//  AMapGPSMocker
//
//  Created by lly on 2020/3/25.
//

#import <UIKit/UIKit.h>

extern CGFloat const kDefaultWidth;

@interface AGMDragableView : UIView

//是否可以拖动,默认为NO
@property (nonatomic, assign, getter = isDragEnable)    BOOL dragEnable;

//是否自动吸附到屏幕边缘,默认为NO
@property (nonatomic, assign, getter = isAdsorbEnable)  BOOL adsorbEnable;

//view吸附到边缘后与屏幕边缘的距离，如果没有设置者取默认值5.0
@property (nonatomic, assign)                           CGFloat padding;

@end
