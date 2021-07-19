//
//  AGMMockFileListViewController.h
//  AMapGPSMocker
//
//  Created by lly on 2021/7/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AGMMockFileListViewControllerDelegate <NSObject>

- (void)selectFileWithPath:(NSString *)filePath;

@end


@interface AGMMockFileListViewController : UIViewController

@property (nonatomic,copy) NSArray<NSString *> *filePath;
@property (nonatomic,weak) id<AGMMockFileListViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
