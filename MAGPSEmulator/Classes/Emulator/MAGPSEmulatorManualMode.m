//
//  MAGPSEmulatorManualMode.m
//  MAGPSEmulator
//
//  Created by lly on 2020/3/23.
//

#import "MAGPSEmulatorManualMode.h"
#import "MAGPSEmulatorUtil.h"

const double kEarthRadius = 6371393.0;
const double kMinDegree = 0.000001;

@interface MAGPSEmulatorManualMode()
{
    CLLocationCoordinate2D *_oriCoordinates;
    unsigned long _count;
}

@property (nonatomic, strong) NSThread *locationsThread;
@property (atomic, assign) BOOL isSimulating;
@property (nonatomic, assign) double timeInverval;

@property (nonatomic, strong) NSRecursiveLock *lock;
@property (nonatomic, assign) double speed;
@property (nonatomic, assign) double distancePerStep;
@property (nonatomic, assign, readwrite) CLLocationCoordinate2D currentPosition;
@property (nonatomic, assign) NSUInteger generatePointCount;//生成点的数量

@end

@implementation MAGPSEmulatorManualMode

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        [self initProperties];
    }
    return self;
}

- (void)dealloc {
    [self stopEmulator];

    [self deleteCoordinates];
}

- (void)initProperties {
    _isSimulating = NO;
    _timeInverval = 1.0f;

    self.lock = [[NSRecursiveLock alloc] init];
    self.simulateSpeed = 80.0;
    self.currentPosition = kCLLocationCoordinate2DInvalid;
}

#pragma mark - Interface

- (void)setSimulateSpeed:(double)simulateSpeed {
    _simulateSpeed = MAX(0, MIN(200, simulateSpeed));

    [self.lock lock];
    self.speed = _simulateSpeed / 3.6f;
    self.distancePerStep = self.timeInverval * self.speed;
    [self.lock unlock];
}

- (void)startEmulator {
    if (self.isSimulating) {
        return;
    }

    if (_locationsThread) {
        [_locationsThread cancel];
        _locationsThread = nil;
    }
    
    if (!CLLocationCoordinate2DIsValid(self.startPosition)) {
        NSLog(@"起点无效");
        return;
    }

    self.isSimulating = YES;

    _locationsThread = [[NSThread alloc] initWithTarget:self selector:@selector(locationThreadEntryMethod) object:nil];
    [_locationsThread setName:@"com.amap.MAGPSEmulatorThread.coordinate"];
    [_locationsThread start];
}

- (void)stopEmulator {
    if (_locationsThread) {
        [_locationsThread cancel];
        _locationsThread = nil;
    }

    self.isSimulating = NO;
}

#pragma mark - Mehtods

- (void)deleteCoordinates {
    if (_oriCoordinates != NULL) {
        free(_oriCoordinates);
        _oriCoordinates = NULL;
        _count = 0;
    }
}

#pragma mark - Thread Entry Method

- (void)locationThreadEntryMethod {
    
    if (!CLLocationCoordinate2DIsValid(self.currentPosition)) {//起点作为第一个点吐出去
        self.currentPosition = self.startPosition;
        self.generatePointCount ++;
        [NSThread sleepForTimeInterval:self.timeInverval];
        [self invokeDelegateWithCoordinate:self.startPosition course:self.direction];
    }
    while (_locationsThread && ![_locationsThread isCancelled]) {
        // 如果当前线程任务已经cancel,则直接退出执行
        if ([[NSThread currentThread] isCancelled]) {
            return;
        }
        //生成一个新的点
        CLLocationCoordinate2D resultCoordinate = [self gengerateNextPointWithCurrentPosition:self.currentPosition
                                                                                     distance:self.distancePerStep andDirection:self.direction];
        if (CLLocationCoordinate2DIsValid(resultCoordinate)) {
            self.generatePointCount ++;
            self.currentPosition = resultCoordinate;
            [NSThread sleepForTimeInterval:self.timeInverval];
            [self invokeDelegateWithCoordinate:resultCoordinate course:self.direction];
        }
    }
    self.isSimulating = NO; //到达终点，循环结束后走到这里
}

- (void)invokeDelegateWithCoordinate:(CLLocationCoordinate2D)coordinate course:(CLLocationDirection)course {
    if (self.delegate) {
        CLLocation *newLocation = [[CLLocation alloc] initWithCoordinate:coordinate
                                                                altitude:30.f
                                                      horizontalAccuracy:5
                                                        verticalAccuracy:10.f
                                                                  course:course
                                                                   speed:self.speed
                                                               timestamp:[NSDate date]];

        [self.delegate gpsEmulatorUpdateLocation:newLocation];
    }
}

/// 计算下一个坐标点·
/// @param currentPosition 当前的位置
/// @param distance 到下一个点的距离，单位：米
/// @param direction 到下一个点的方向，单位：度数
- (CLLocationCoordinate2D)gengerateNextPointWithCurrentPosition:(CLLocationCoordinate2D)currentPosition
                                                       distance:(CLLocationDistance)distance
                                                   andDirection:(CLLocationDirection)direction {
    if (!CLLocationCoordinate2DIsValid(currentPosition)) {
        return kCLLocationCoordinate2DInvalid;
    }
    if (distance < 0) {
        return kCLLocationCoordinate2DInvalid;
    }
    //角度标准化为0-359.9之间
    direction = emu_normalizeDegree(direction);
    //角度变换成弧度
    double radian = [self radianFromDegress:direction];
    double moveX = distance * sin(radian);
    double moveY = distance * cos(radian);
    //直接按照平面坐标计算
    //纬度计算
    double moveYRadian = moveY / kEarthRadius;
    CLLocationDegrees moveLatitude = [self degressFromRadian:moveYRadian];
    //经度计算
    //计算当前纬度所在的圆切面半径
    double latitudeRadius = kEarthRadius * cos([self radianFromDegress:currentPosition.latitude]);
    double moveXRadian = moveX / latitudeRadius;
    CLLocationDegrees moveLontitude = [self degressFromRadian:moveXRadian];
    //如果变化范围太小，则至少给个最小值
    if (fabs(moveLatitude) < kMinDegree && fabs(moveLontitude) < kMinDegree) {
        if (fabs(moveLatitude) > fabs(moveLontitude)) {//修改绝对值较大者
            if (moveLatitude > 0) {
                moveLatitude = kMinDegree;
            } else {
                moveLatitude = -kMinDegree;
            }
        } else {
            if (moveLontitude > 0) {
                moveLontitude = kMinDegree;
            } else {
                moveLontitude = -kMinDegree;
            }
        }
    }
    CLLocationCoordinate2D newPoint = CLLocationCoordinate2DMake(currentPosition.latitude + moveLatitude, currentPosition.longitude + moveLontitude);
    return newPoint;
}

- (double)radianFromDegress:(double)degree {
    return degree * M_PI / 180 ;
}

- (double)degressFromRadian:(double)radian {
    return radian * 180 / M_PI;
}

- (int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}

- (CLLocationCoordinate2D)findCoordinateFromIndex:(unsigned long)startIndex
                                    afterDistance:(double)distance
                                resultLocateIndex:(unsigned long *)locateIndex
                          resultRedundantDistance:(double *)redundantDistance {
    unsigned long realStartIndex = MAX(0, startIndex);
    double totalDistance = distance;

    // if 'totalDistance <= 0', return coordinate at 'startIndex' directly
    if (totalDistance <= 0) {
        *locateIndex = realStartIndex;
        *redundantDistance = 0.f;

        CLLocationCoordinate2D reVal = *(_oriCoordinates + realStartIndex);
        return CLLocationCoordinate2DMake(reVal.latitude, reVal.longitude);
    }

    CLLocationCoordinate2D resultCoordiante = *(_oriCoordinates + realStartIndex);
    double resultDistance = 0;

    unsigned long i = realStartIndex;
    for (; i < _count - 1; i++) {
        double dis = emu_distanceBetweenCoordinates(*(_oriCoordinates + i), *(_oriCoordinates + i + 1));
        if (totalDistance <= dis) {
            resultDistance = totalDistance;
            resultCoordiante = emu_coordinateAtRateOfCoordinates(*(_oriCoordinates + i), *(_oriCoordinates + i + 1), (totalDistance / dis));
            break;
        } else {
            totalDistance -= dis;
        }
    }

    // reach the end of coordiante list, return the last coordiante
    *locateIndex = _count - 1;
    *redundantDistance = 0.f;

    CLLocationCoordinate2D reVal = *(_oriCoordinates + _count - 1);
    return CLLocationCoordinate2DMake(reVal.latitude, reVal.longitude);
}

@end
