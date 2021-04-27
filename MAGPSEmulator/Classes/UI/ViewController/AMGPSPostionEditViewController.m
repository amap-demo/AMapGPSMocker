//
//  AMGPSPostionEditViewController.m
//  MAGPSEmulator
//
//  Created by lly on 2021/4/27.
//

#import "AMGPSPostionEditViewController.h"
#import <MAMapKit/MAMapView.h>
#import "DoraemonGPSMocker.h"

@interface AMGPSPostionEditViewController ()<UITextFieldDelegate,MAMapViewDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *mockSwitch;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *inputTextField;
@property (unsafe_unretained, nonatomic) IBOutlet MAMapView *mapView;

@property (nonatomic,assign) CLLocationCoordinate2D mockCoord;

@end

@implementation AMGPSPostionEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inputTextField.delegate = self;
    self.mockSwitch.on = [DoraemonGPSMocker shareInstance].isMocking;
    [self initMapView];
}

- (void)initMapView {
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.mapView.zoomLevel = 16.0;
}

- (void)mockPoint:(CLLocationCoordinate2D)coord {
    if (CLLocationCoordinate2DIsValid(coord)) {
        CLLocation *locaiton = [[CLLocation alloc] initWithLatitude:coord.latitude
                                                          longitude:coord.longitude];
        [[DoraemonGPSMocker shareInstance] mockPoint:locaiton];
    } else {
        NSLog(@"经纬度无效");
    }
}

- (IBAction)switchChanged:(id)sender {
    if (self.mockSwitch.on) {
        [self mockPoint:_mockCoord];
    } else {
        [[DoraemonGPSMocker shareInstance] stopMockPoint];
    }
}

- (IBAction)closeBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//MARK: UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *coordStr = textField.text;
    if (coordStr == nil || coordStr.length == 0) {
        NSLog(@"请输入有效的经纬度");
        return;
    }
    NSArray<NSString *> *array = [coordStr componentsSeparatedByString:@","];
    if (array == nil || array.count != 2) {
        NSLog(@"请输入有效的经纬度");
        return;
    }
    _mockCoord = CLLocationCoordinate2DMake([array[1] doubleValue], [array.firstObject doubleValue]);
    if (self.mockSwitch.on) {//如果打开，则编辑完成，即更新mock的点
        [self mockPoint:_mockCoord];
    }
}

//MARK: MAMapViewDelegate


@end
