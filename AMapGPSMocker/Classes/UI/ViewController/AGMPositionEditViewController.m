//
//  AGMPositionEditViewController.m
//  AMapGPSMocker
//
//  Created by lly on 2021/4/27.
//

#import "AGMPositionEditViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "AGMSinglePointMocker.h"
#import "AGMCoordConvertUtil.h"
#import "AGMCaclUtil.h"

@interface AGMPositionEditViewController ()<UITextFieldDelegate,MAMapViewDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *mockSwitch;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *inputTextField;
@property (unsafe_unretained, nonatomic) IBOutlet MAMapView *mapView;

@property (nonatomic,assign) CLLocationCoordinate2D mockCoord;

///大头针annotation
@property (nonatomic, strong) MAPointAnnotation *pinAnnotation;

@end

@implementation AGMPositionEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inputTextField.delegate = self;
    self.mockSwitch.on = [AGMSinglePointMocker shareInstance].isMocking;
    [self initMapView];
}

- (void)initMapView {
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.mapView.zoomLevel = 16.0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.pinAnnotation == nil) {
        self.pinAnnotation = [[MAPointAnnotation alloc] init];
        _pinAnnotation.title = [AGMCaclUtil stringFromCoord:self.mapView.centerCoordinate];
        _pinAnnotation.lockedToScreen = YES;
        [self.view layoutIfNeeded];
        _pinAnnotation.lockedScreenPoint = CGPointMake(CGRectGetWidth(_mapView.bounds)*self.mapView.screenAnchor.x, CGRectGetHeight(_mapView.bounds)*self.mapView.screenAnchor.y);
        [self.mapView addAnnotation:_pinAnnotation];
        [self.mapView selectAnnotation:_pinAnnotation animated:NO];
    }
}

- (void)mockPoint:(CLLocationCoordinate2D)coord {
    if (CLLocationCoordinate2DIsValid(coord)) {
        CLLocationCoordinate2D coord84 = [AGMCoordConvertUtil wgs84FromGcj02:coord];
        CLLocation *locaiton = [[CLLocation alloc] initWithLatitude:coord84.latitude
                                                          longitude:coord84.longitude];
        [[AGMSinglePointMocker shareInstance] startMockPoint:locaiton];
    } else {
        NSLog(@"经纬度无效");
    }
}

- (IBAction)switchChanged:(id)sender {
    if (self.mockSwitch.on) {
        [self mockPoint:_mockCoord];
    } else {
        [[AGMSinglePointMocker shareInstance] stopMockPoint];
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
    _mockCoord = [AGMCaclUtil coordinateFromString:coordStr];
    if (self.mockSwitch.on) {//如果打开，则编辑完成，即更新mock的点
        [self mockPoint:_mockCoord];
    }
    self.mapView.centerCoordinate = _mockCoord;
}

//MARK: MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if(annotation == self.pinAnnotation) {
        static NSString *identifier = @"lockScreenPointAnnotation";
        MAPinAnnotationView *view = (MAPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if(!view) {
            view = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        view.canShowCallout = YES;
        view.pinColor = MAPinAnnotationColorRed;
        view.draggable = NO;
        view.zIndex = 100;
        return view;
    } else {
        return nil;
    }
}

/**
 * @brief 当取消选中一个annotation view时，调用此接口
 * @param mapView 地图View
 * @param view 取消选中的annotation view
 */
- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view {
    if (view.annotation == self.pinAnnotation) {//这里确保，pinAnnotation始终被选中，其title始终可以显示
        [mapView selectAnnotation:self.pinAnnotation animated:NO];
    }
}
/**
 * @brief 地图区域改变完成后会调用此接口，如实现此接口则不会触发回掉mapView:regionDidChangeAnimated:
 * @param mapView 地图View
 * @param animated 是否动画
 * @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated wasUserAction:(BOOL)wasUserAction {
    if ([AGMCaclUtil isEqualWith:_mockCoord to:mapView.centerCoordinate]) {
        return;
    }
    NSString *str = [AGMCaclUtil stringFromCoord:mapView.centerCoordinate];
    self.pinAnnotation.title = str;
    self.inputTextField.text = str;
    self.mockCoord = mapView.centerCoordinate;
    if (self.mockSwitch.on) {
        [self mockPoint:mapView.centerCoordinate];
    }
}

@end
