//
//  MASGPSEmulator.m

#import "MAGPSEmulator.h"
#import "MAGPSEmulatorUtil.h"

@interface MAGPSEmulator ()
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

@end


@implementation MAGPSEmulator

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
    _timeInverval = 0.2f;

    self.lock = [[NSRecursiveLock alloc] init];
    self.simulateSpeed = 80.0;
}

#pragma mark - Interface

- (void)setSimulateSpeed:(double)simulateSpeed {
    _simulateSpeed = MAX(0, MIN(200, simulateSpeed));

    [self.lock lock];
    self.speed = _simulateSpeed / 3.6f;
    self.distancePerStep = self.timeInverval * self.speed;
    [self.lock unlock];
}

- (void)setCoordinates:(CLLocationCoordinate2D *)coordinates count:(unsigned long)count {
    if (self.isSimulating) {
        return;
    }

    if (coordinates == NULL || count <= 0) {
        return;
    }

    [self deleteCoordinates];

    _count = count;
    _oriCoordinates = (CLLocationCoordinate2D *)malloc(sizeof(CLLocationCoordinate2D) * _count);
    for (int i = 0; i < _count; i++) {
        _oriCoordinates[i].latitude = (*(coordinates + i)).latitude;
        _oriCoordinates[i].longitude = (*(coordinates + i)).longitude;
    }
}

- (void)startEmulator {
    if (self.isSimulating) {
        return;
    }

    if (_locationsThread) {
        [_locationsThread cancel];
        _locationsThread = nil;
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
    double totalDis = 0;
    double stepTotalDistance = self.distancePerStep;
    NSInteger currentIndex = 0;

    CLLocationCoordinate2D firstCoord = *(_oriCoordinates + 0);
    if (CLLocationCoordinate2DIsValid(firstCoord)) {
        double course = emu_angleBetweenCoordinates(*(_oriCoordinates + 1), firstCoord); //角度
        [NSThread sleepForTimeInterval:self.timeInverval];
        [self invokeDelegateWithCoordinate:firstCoord course:course];
    }

    while (currentIndex < _count - 1 && _locationsThread && ![_locationsThread isCancelled]) {
        // 如果当前线程任务已经cancel,则直接退出执行
        if ([[NSThread currentThread] isCancelled]) {
            return;
        }

        double dis = emu_distanceBetweenCoordinates(*(_oriCoordinates + currentIndex), *(_oriCoordinates + currentIndex + 1)); //当前段
        if (currentIndex == 0) {
            totalDis = dis; //init
        }

        CLLocationCoordinate2D resultCoordinate = kCLLocationCoordinate2DInvalid;
        double course = 0;

        if (totalDis >= stepTotalDistance) {
            resultCoordinate = emu_coordinateAtRateOfCoordinates(*(_oriCoordinates + currentIndex), *(_oriCoordinates + currentIndex + 1), ((dis - (totalDis - stepTotalDistance)) / dis));

            stepTotalDistance += self.distancePerStep;

        } else {
            currentIndex++;
            if (currentIndex + 1 < _count) {
                totalDis += emu_distanceBetweenCoordinates(*(_oriCoordinates + currentIndex), *(_oriCoordinates + currentIndex + 1)); //下一段
            } else {
                resultCoordinate = *(_oriCoordinates + currentIndex); //不够，直接取终点
            }
        }

        if (CLLocationCoordinate2DIsValid(resultCoordinate)) {
            course = emu_angleBetweenCoordinates(*(_oriCoordinates + currentIndex), resultCoordinate); //角度
            [NSThread sleepForTimeInterval:self.timeInverval];
            [self invokeDelegateWithCoordinate:resultCoordinate course:course];
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