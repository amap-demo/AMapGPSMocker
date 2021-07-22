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
#import <MapKit/MapKit.h>
#import "AGMShowCoordPinAnnotation.h"

NSString * const GPSFileDiectionary = @"/AGMMockGPS";

@interface AGMRouteEditViewController ()<MKMapViewDelegate,UITextViewDelegate,AGMMockFileListViewControllerDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *mockSwitch;
@property (nonatomic,copy) NSString *defaultTextStr;
@property (unsafe_unretained, nonatomic) IBOutlet UITextView *routePointsTextView;
@property (unsafe_unretained, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic,copy) NSArray<NSString *> *routePointsStr;

@property (nonatomic,assign) CLLocationCoordinate2D *routeCoords;
@property (nonatomic,assign) NSUInteger coordCount;

//当前编辑的点
@property (nonatomic,assign) CLLocationCoordinate2D currentCoord;
@property (nonatomic,strong) MKPolyline *routePolyline;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *currentCoordLabel;

@end

@implementation AGMRouteEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.defaultTextStr = @"请输入经纬度(示例:116.473,39;116.451,39.970)";
    self.routePointsTextView.delegate = self;
    //首开广场GCJ02坐标
    self.currentCoord = CLLocationCoordinate2DMake(39.993306,116.473004);
    [self resetRouteCoordsCache];
    self.mapView.delegate = self;
    [self.mapView setRegion:MKCoordinateRegionMake(self.currentCoord, MKCoordinateSpanMake(2, 2)) animated:YES];
    
}

- (void)resetRouteCoordsCache {
    if (_routeCoords != NULL && _coordCount > 0) {
        free(_routeCoords);
    }
    _routeCoords = (CLLocationCoordinate2D *)malloc(100 * sizeof(CLLocationCoordinate2D));
    _coordCount = 0;
}

- (void)setCurrentCoord:(CLLocationCoordinate2D)currentCoord {
    if (CLLocationCoordinate2DIsValid(currentCoord)) {
        _currentCoord = currentCoord;
        self.currentCoordLabel.text = [AGMCoordConvertUtil stringFromCoord:currentCoord];
    } else {
        NSLog(@"设置当前的经纬度无效");
    }
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
        NSString *pointStr = [AGMCoordConvertUtil stringFromCoord:point];
        [pointsStr appendFormat:@"%@;",pointStr];
    }
    if (pointsStr.length > 2) {//有点，则把最后一个；去掉
        [pointsStr deleteCharactersInRange:NSMakeRange(pointsStr.length-1, 1)];
    }
    self.routePointsTextView.text = [pointsStr copy];
}

- (void)updateRoutePolyline {
    if (_coordCount <= 1 || _routeCoords == NULL) {
        return;
    }
    if (self.routePolyline == nil) {
        self.routePolyline = [MKPolyline polylineWithCoordinates:_routeCoords count:_coordCount];
        [self.mapView addOverlay:_routePolyline level:MKOverlayLevelAboveRoads];
    } else {
        [self.mapView removeOverlay:_routePolyline];
        self.routePolyline = [MKPolyline polylineWithCoordinates:_routeCoords count:_coordCount];
        [self.mapView addOverlay:_routePolyline level:MKOverlayLevelAboveRoads];
    }
}

//确认写入按钮
- (IBAction)ensureBtnClicked:(id)sender {
    if (CLLocationCoordinate2DIsValid(self.currentCoord) == NO) {
        NSLog(@"当前经纬度无效");
        return;
    }
    [self addRouteCoord:self.currentCoord];
    [self updateRoutePolyline];
    NSString *coordStr = [AGMCoordConvertUtil stringFromCoord:self.currentCoord];
    if ([self.routePointsTextView.text isEqualToString:self.defaultTextStr]) {
        self.routePointsTextView.text = coordStr;
    } else {
        if (self.routePointsTextView.text.length > 0) {
            self.routePointsTextView.text = [self.routePointsTextView.text stringByAppendingFormat:@";%@",coordStr];
        } else {
            self.routePointsTextView.text = coordStr;
        }
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
            _routeCoords[index] = [AGMCoordConvertUtil coordinateFromString:coordStrArray[index]];
        }
        //UI展示
        [self updateRoutePolyline];
        [self.mapView setVisibleMapRect:self.routePolyline.boundingMapRect
                            edgePadding:UIEdgeInsetsMake(10, 15, 15, 10)
                               animated:YES];
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
            NSString *coordStr = [AGMCoordConvertUtil stringFromCoord:weakSelf.routeCoords[index]];
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

//MARK: UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length > 0 && [textView.text isEqualToString:self.defaultTextStr] == NO) {
        NSString *pointsStr = textView.text;
        NSArray<NSString *> *points = [pointsStr componentsSeparatedByString:@";"];
        if (points.count > 0) {
            [self resetRouteCoordsCache];
        }
        for (NSString *point in points) {
            CLLocationCoordinate2D coord = [AGMCoordConvertUtil coordinateFromString:point];
            [self addRouteCoord:coord];
        }
        [self updateRoutePolyline];
    }
}

//MARK: MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if (self.routePolyline == overlay) {
        MKPolylineRenderer *render = [[MKPolylineRenderer alloc] initWithPolyline:self.routePolyline];
        render.fillColor = [UIColor redColor];
        render.strokeColor = [UIColor redColor];
        render.lineWidth = 10;
        render.lineCap = kCGLineCapRound;
        render.lineJoin = kCGLineJoinRound;
        return render;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    CLLocationCoordinate2D centerCoord = mapView.centerCoordinate;
    self.currentCoord = centerCoord;
}


@end
