//
//  AGMRouteEditViewController.m
//  AMapGPSMocker
//
//  Created by lly on 2021/4/29.
//

#import "AGMRouteEditViewController.h"
#import "AGMCaclUtil.h"
#import "AGMMultiPointMocker.h"
#import "AGMCoordConvertUtil.h"
#import "AGMMockFileListViewController.h"

#if __has_include(<AMapNaviKit/MAMapKit.h>)
#import <AMapNaviKit/MAMapKit.h>
#elif __has_include(<MAMapKit/MAMapKit.h>)
#import <MAMapKit/MAMapKit.h>
#elif __has_include("MAMapKit.h")
#import "MAMapKit.h"
#endif

NSString * const GPSFileDiectionary = @"/AGMMockGPS";

@interface AGMRouteEditViewController ()<MAMapViewDelegate,UITextViewDelegate,AGMMockFileListViewControllerDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *mockSwitch;
@property (nonatomic,copy) NSString *defaultTextStr;
@property (unsafe_unretained, nonatomic) IBOutlet UITextView *routePointsTextView;
@property (unsafe_unretained, nonatomic) IBOutlet MAMapView *mapView;

@property (nonatomic,copy) NSArray<NSString *> *routePointsStr;

@property (nonatomic,assign) CLLocationCoordinate2D *routeCoords;
@property (nonatomic,assign) NSUInteger coordCount;

//当前编辑的点
@property (nonatomic,assign) CLLocationCoordinate2D currentPointCoord;
@property (nonatomic,strong) MAPointAnnotation *currentPointAnnotation;

@property (nonatomic,strong) MAPolyline *routePolyline;

@end

@implementation AGMRouteEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.defaultTextStr = @"请输入经纬度(示例:116.473,39;116.451,39.970)";
    self.routePointsTextView.delegate = self;
    [self resetRouteCoordsCache];
    [self initMapView];
}

- (void)initMapView {
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.mapView.zoomLevel = 16.0;
}

- (void)resetRouteCoordsCache {
    if (_routeCoords != NULL && _coordCount > 0) {
        free(_routeCoords);
    }
    _routeCoords = (CLLocationCoordinate2D *)malloc(100 * sizeof(CLLocationCoordinate2D));
    _coordCount = 0;
}

- (void)addRouteCoord:(CLLocationCoordinate2D)coord {
    if (CLLocationCoordinate2DIsValid(coord) == NO) {
        return;
    }
    if (_coordCount < 100) {
        _routeCoords[_coordCount++] = coord;
    } else {
        NSAssert(false, @"手动编辑，最多支持100个点");
    }
}

- (void)writePointsToTextView {
    NSMutableString *pointsStr = [[NSMutableString alloc] init];
    for (NSUInteger index = 0 ; index < _coordCount; index ++) {
        CLLocationCoordinate2D point = _routeCoords[index];
        NSString *pointStr = [AGMCaclUtil stringFromCoord:point];
        [pointsStr appendFormat:@"%@;",pointStr];
    }
    if (pointsStr.length > 2) {//有点，则把最后一个；去掉
        [pointsStr deleteCharactersInRange:NSMakeRange(pointsStr.length-1, 1)];
    }
    self.routePointsTextView.text = [pointsStr copy];
}

- (void)updateRoutePolyline {
    if (self.routePolyline == nil) {
        self.routePolyline = [MAPolyline polylineWithCoordinates:_routeCoords count:_coordCount];
        [self.mapView addOverlay:_routePolyline];
    } else {
        [self.mapView removeOverlay:_routePolyline];
        self.routePolyline = [MAPolyline polylineWithCoordinates:_routeCoords count:_coordCount];
        [self.mapView addOverlay:_routePolyline];
    }
}

/// 从文件导入
/// @param sender sender
- (IBAction)importFromFile:(id)sender {
    NSMutableArray<NSString *> *fileNames = [NSMutableArray array];
    //从bundle中加载文件
    NSArray<NSString *> *txtPaths = [NSBundle pathsForResourcesOfType:@"txt" inDirectory:[NSBundle mainBundle].bundlePath];
    [fileNames addObjectsFromArray:txtPaths];
    NSArray<NSString *> *gpxPaths = [NSBundle pathsForResourcesOfType:@"gpx" inDirectory:[NSBundle mainBundle].bundlePath];
    [fileNames addObjectsFromArray:gpxPaths];
    //从文件目录中加载
    NSArray<NSString *> *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *document = pathArray.firstObject;
    NSString *directory = [document stringByAppendingString:GPSFileDiectionary];
    txtPaths = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:directory error:nil];
    if (txtPaths.count > 0) {
        for (NSString *fileName in txtPaths) {
            if ([fileName.pathExtension isEqualToString:@"txt"]
                || [fileName.pathExtension isEqualToString:@"gpx"]) {
                NSString *fullPath = [NSString stringWithFormat:@"%@/%@",directory,fileName];
                [fileNames addObject:fullPath];
            }
        }
    }
    AGMMockFileListViewController *fileListVC = [[AGMMockFileListViewController alloc] initWithNibName:NSStringFromClass([AGMMockFileListViewController class])
                                                                                                bundle:nil];
    fileListVC.delegate = self;
    fileListVC.filePath = fileNames;
    [self presentViewController:fileListVC animated:YES completion:nil];
}

//MARK:AGMMockFileListViewControllerDelegate

- (void)selectFileWithPath:(NSString *)filePath {
//    txt文件读取
    if ([filePath.pathExtension isEqualToString:@"txt"]) {
        NSString *coordStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"coordStr:%@",coordStr);
        NSArray<NSString *> *coordStrArray = [coordStr componentsSeparatedByString:@";"];
        if (_routeCoords != NULL && _coordCount > 0) {
            free(_routeCoords);
        }
        _routeCoords = malloc(sizeof(CLLocationCoordinate2D) * coordStrArray.count);
        _coordCount = coordStrArray.count;
        for (NSUInteger index = 0; index < coordStrArray.count; index ++) {
            _routeCoords[index] = [AGMCaclUtil coordinateFromString:coordStrArray[index]];
        }
        //UI展示
        [self updateRoutePolyline];
        [self.mapView showOverlays:@[self.routePolyline] animated:YES];
        [self writePointsToTextView];
    } else if ([filePath.pathExtension isEqualToString:@"gpx"]) {
//        TODO: gpx文件读写
    }
}

/// 保存到文件
/// @param sender sender
- (IBAction)saveToFile:(id)sender {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        NSMutableString *mStr = [NSMutableString new];
        for (NSUInteger index = 0; index < weakSelf.coordCount; index++) {
            NSString *coordStr = [AGMCaclUtil stringFromCoord:weakSelf.routeCoords[index]];
            if (coordStr.length > 0) {
                [mStr appendString:[NSString stringWithFormat:@"%@;",coordStr]];
            }
        }
        if (mStr.length > 2) {//有点，则把最后一个；去掉
            [mStr deleteCharactersInRange:NSMakeRange(mStr.length-1, 1)];
        }
        NSArray<NSString *> *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *document = pathArray.firstObject;
        NSString *directory = [document stringByAppendingString:GPSFileDiectionary];
        if ([[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:nil] == NO) {//不存在目录，则创建
            [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd-HHmmss";
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
        NSString *fileName = [dateFormatter stringFromDate:[NSDate new]];
        NSData *data = [mStr dataUsingEncoding:NSUTF8StringEncoding];
        BOOL result = [[NSFileManager defaultManager] createFileAtPath:[NSString stringWithFormat:@"%@/%@.txt",directory,fileName]
                                                              contents:data
                                                            attributes:nil];
        if (result) {
            NSLog(@"写入GPS点成功！");
        } else {
            NSLog(@"写入GPS点失败！");
        }
    });
}

- (IBAction)closeBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)switchChanged:(id)sender {
    if (self.mockSwitch.on) {
        [self mockPoints:_routeCoords count:_coordCount];
    } else {
        [[AGMMultiPointMocker sharedInstance] stopMockPoint];
    }
}

- (void)mockPoints:(CLLocationCoordinate2D *)coords count:(NSUInteger)count {
    if (coords == NULL || count <= 0) {
        return;
    }
    CLLocationCoordinate2D *keyCoords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
    for (NSUInteger index = 0; index < count; index++) {
        if (CLLocationCoordinate2DIsValid(coords[index])) {
            keyCoords[index] = [AGMCoordConvertUtil wgs84FromGcj02:coords[index]];
        } else {
            NSLog(@"经纬度无效");
            return;
        }
    }
    [[AGMMultiPointMocker sharedInstance] setKeyCoordinates:keyCoords count:count];
    [[AGMMultiPointMocker sharedInstance] startMockPoint];
}

- (void)resetCurrentPointWithCoord:(CLLocationCoordinate2D)coord {
    if (self.currentPointAnnotation != nil) {
        [self.mapView removeAnnotation:self.currentPointAnnotation];
    }
    self.currentPointAnnotation = [[MAPointAnnotation alloc] init];
    _currentPointAnnotation.title = [AGMCaclUtil stringFromCoord:coord];
    self.currentPointCoord = coord;
    _currentPointAnnotation.lockedToScreen = YES;
    //将经纬度转换为指定view坐标系的坐标
    _currentPointAnnotation.lockedScreenPoint = [self.mapView convertCoordinate:coord toPointToView:self.mapView];
    [self.mapView addAnnotation:_currentPointAnnotation];
    [self.mapView selectAnnotation:_currentPointAnnotation animated:YES];
}

//MARK: UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length > 0 && [textView.text isEqualToString:self.defaultTextStr] == NO) {
        NSString *pointsStr = textView.text;
        NSArray<NSString *> *points = [pointsStr componentsSeparatedByString:@";"];
        if (points.count > 0) {
            [self resetRouteCoordsCache];
        }
        for (NSString *point in points) {
            CLLocationCoordinate2D coord = [AGMCaclUtil coordinateFromString:point];
            [self addRouteCoord:coord];
        }
        [self updateRoutePolyline];
    }
}

//MARK: MAMapViewDelegate
/**
 * @brief 长按地图，返回经纬度
 * @param mapView 地图View
 * @param coordinate 经纬度
 */
- (void)mapView:(MAMapView *)mapView didLongPressedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    if (self.currentPointAnnotation) {
        if ([AGMCaclUtil isEqualWith:self.currentPointCoord to:coordinate] == NO) {//长按点击了当前经纬度之外的点
            [self addRouteCoord:self.currentPointCoord];
            [self updateRoutePolyline];
            [self writePointsToTextView];
            [self resetCurrentPointWithCoord:coordinate];
        }
    } else {
        [self resetCurrentPointWithCoord:coordinate];
    }
}

/**
 * @brief 地图区域改变完成后会调用此接口，如实现此接口则不会触发回掉mapView:regionDidChangeAnimated:
 * @param mapView 地图View
 * @param animated 是否动画
 * @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated wasUserAction:(BOOL)wasUserAction {
    if (self.currentPointAnnotation && animated) {
        CGPoint lockedScreenPoint = self.currentPointAnnotation.lockedScreenPoint;
        CLLocationCoordinate2D currentCoord = [mapView convertPoint:lockedScreenPoint toCoordinateFromView:mapView];
        self.currentPointCoord = currentCoord;
        NSString *str = [AGMCaclUtil stringFromCoord:currentCoord];
        self.currentPointAnnotation.title = str;
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if(annotation == self.currentPointAnnotation) {
        static NSString *identifier = @"lockScreenPointAnnotation";
        MAPinAnnotationView *view = (MAPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if(!view) {
            view = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        view.animatesDrop = YES;
        view.canShowCallout = YES;
        view.pinColor = MAPinAnnotationColorRed;
        view.draggable = NO;
        view.zIndex = 100;
        return view;
    } else {
        return nil;
    }
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if (self.routePolyline == overlay) {
        MAPolylineRenderer *render = [[MAPolylineRenderer alloc] initWithOverlay:overlay];
        render.fillColor = [UIColor redColor];
        render.lineWidth = 10;
        render.lineCapType = kMALineCapRound;
        render.lineJoinType = kMALineJoinRound;
        return render;
    }
    return nil;
}


@end
