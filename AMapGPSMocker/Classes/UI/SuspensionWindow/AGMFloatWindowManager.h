//
//  AGMFloatWindowManager.h
//  AMapGPSMocker
//
//  Created by lly on 2020/3/25.
//

#import <Foundation/Foundation.h>
#import "AGMFloatWindowRootVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGMFloatWindowManager : NSObject

@property (nonatomic,strong) AGMFloatWindowRootVC *rootVC;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

+ (instancetype)sharedManager;

/// 展示默认浮框
- (void)showFloatWindow;

//显示浮窗
- (void)showWithContent:(UIViewController *)contentVC;

//隐藏并销毁
- (void)hideAndDestroy;

@end

NS_ASSUME_NONNULL_END
