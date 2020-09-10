//
//  AMGPSFloatBubbleViewController.m
//  MAGPSEmulator
//
//  Created by lly on 2020/9/8.
//

#import "AMGPSFloatBubbleViewController.h"

@interface AMGPSFloatBubbleViewController ()

@property (nonatomic,strong) UIButton *homeBtn;

@end

@implementation AMGPSFloatBubbleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)initHomeBtn {
    self.homeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.homeBtn.titleLabel.text = @"GPSMock";
    
}

@end
