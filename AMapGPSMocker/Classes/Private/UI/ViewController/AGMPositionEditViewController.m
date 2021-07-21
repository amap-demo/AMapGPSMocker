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

///大头针annotation
@property (nonatomic, strong) AGMShowCoordPinAnnotation *pinAnnotation;

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
    [self.mapView setRegion:MKCoordinateRegionMake(self.mockCoord, MKCoordinateSpanMake(10, 10)) animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.pinAnnotation == nil) {
        self.pinAnnotation = [[AGMShowCoordPinAnnotation alloc] init];
        self.pinAnnotation.coordinate = self.mockCoord;
        [self.view layoutIfNeeded];
        [self.mapView addAnnotation:_pinAnnotation];
        [self.mapView selectAnnotation:_pinAnnotation animated:NO];
    }
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
    self.pinAnnotation.coordinate = _mockCoord;
}

//MARK: MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if(annotation == self.pinAnnotation) {
        static NSString *identifier = @"lockScreenPointAnnotation";
        MKPinAnnotationView *view = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if(!view) {
            view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        view.canShowCallout = YES;
        view.pinTintColor = [MKPinAnnotationView redPinColor];
        view.draggable = YES;
        return view;
    } else {
        return nil;
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    //这里确保，pinAnnotation始终被选中，其title始终可以显示
    if (view.annotation == self.pinAnnotation) {
        [mapView selectAnnotation:self.pinAnnotation animated:NO];
    }
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState {
    if (view.annotation == self.pinAnnotation) {
        if (newState == MKAnnotationViewDragStateEnding) {
            CLLocationCoordinate2D coord = [mapView convertPoint:view.center toCoordinateFromView:mapView];
            self.pinAnnotation.coordinate = coord;
            self.inputTextField.text = [AGMCoordConvertUtil stringFromCoord:coord];
            self.mockCoord = coord;
            if (self.mockSwitch.on) {
                [self mockCoordGCJ02:coord];
            }
        }
    }
}

@end
