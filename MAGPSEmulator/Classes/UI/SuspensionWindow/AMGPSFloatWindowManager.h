//
//  AMGPSFloatWindowManager.h
//  AMGPSEmulator
//
//  Created by lly on 2020/3/25.
//

#import <Foundation/Foundation.h>
#import "AMGPSFloatWindowRootVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface AMGPSFloatWindowManager : NSObject

@property (nonatomic,strong) AMGPSFloatWindowRootVC *rootVC;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

+ (instancetype)sharedManager;

//显示浮窗
- (void)showWithContent:(UIViewController *)contentVC;

//隐藏并销毁
- (void)hideAndDestroy;

@end

NS_ASSUME_NONNULL_END
