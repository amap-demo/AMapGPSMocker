//
//  AGMPositionEditViewController.m
//  AMapGPSMocker
//
//  Created by lly on 2021/4/27.
//

#import "AGMPositionEditViewController.h"
#import "AGMSinglePointMocker.h"
#import "AGMCoordConvertUtil.h"
#import "AGMCaclUtil.h"
#import <MapKit/MapKit.h>
#import "AGMShowCoordPinAnnotation.h"

@interface AGMPositionEditViewController ()<UITextFieldDelegate,MKMapViewDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *mockSwitch;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *inputTextField;
@property (unsafe_unretained, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,assign) CLLocationCoordinate2D mockCoord;

@end

@implementation AGMPositionEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //首开广场GCJ02坐标
    self.mockCoord = CLLocationCoordinate2DMake(39.993306,116.473004);
    self.inputTextField.delegate = self;
    BOOL isMocking = [AGMSinglePointMocker sharedInstance].isMocking;
    if (isMocking) {
        self.inputTextField.text = [AGMCoordConvertUtil stringFromCoord:self.mockCoord];
        [self mockCoordGCJ02:self.mockCoord];
    }
    self.mockSwitch.on = isMocking;
    
    self.mapView.delegate = self;
    [self.mapView setRegion:MKCoordinateRegionMake(self.mockCoord, MKCoordinateSpanMake(2, 2)) animated:YES];
}

/// mock点的GCJ02坐标，这里MKMapView使用坐标系和高德相同，即GCJ02坐标系，但其CLLocationManager回调的位置都是WGS84坐标系，所以需要转换
/// @param coord 经纬度(GCJ02坐标系)
- (void)mockCoordGCJ02:(CLLocationCoordinate2D)coord {
    if (CLLocationCoordinate2DIsValid(coord)) {
        CLLocationCoordinate2D coord84 = [AGMCoordConvertUtil wgs84FromGcj02:coord];
        [[AGMSinglePointMocker sharedInstance] startMockCoord:coord84];
    } else {
        NSLog(@"经纬度无效");
    }
}

- (IBAction)switchChanged:(id)sender {
    if (self.mockSwitch.on) {
        [self mockCoordGCJ02:_mockCoord];
    } else {
        [[AGMSinglePointMocker sharedInstance] stopMockPoint];
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
    _mockCoord = [AGMCoordConvertUtil coordinateFromString:coordStr];
    if (self.mockSwitch.on) {//如果打开，则编辑完成，即更新mock的点
        [self mockCoordGCJ02:_mockCoord];
    }
}

//MARK: MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    CLLocationCoordinate2D centerCoord = mapView.centerCoordinate;
    self.inputTextField.text = [AGMCoordConvertUtil stringFromCoord:centerCoord];
    self.mockCoord = centerCoord;
    if (self.mockSwitch.on) {
        [self mockCoordGCJ02:centerCoord];
    }
}


@end
