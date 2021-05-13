//
//  AGMMultiPointMocker.m

#import "AGMMultiPointMocker.h"
#import "AGMCaclUtil.h"
#import "AGMSinglePointMocker.h"

@interface AGMMultiPointMocker ()
{
    CLLocationCoordinate2D *_oriCoordinates;
    unsigned long _count;
}

@property (nonatomic, strong) NSThread *locationsThread;
@property (atomic, assign) BOOL isMocking;
@property (nonatomic, assign) double timeInverval;

@property (nonatomic, strong) NSRecursiveLock *lock;
@property (nonatomic, assign) double speed;
@property (nonatomic, assign) double distancePerStep;

//@property (nonatomic, weak) id<AGMMultiPointMockerDelegate> delegate;

@end


@implementation AGMMultiPointMocker

#pragma mark - Life Cycle

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static AGMMultiPointMocker *instance;
    dispatch_once(&once, ^{
        instance = [[AGMMultiPointMocker alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initProperties];
    }
    return self;
}

- (void)dealloc {
    [self stopMockPoint];

    [self deleteCoordinates];
}

- (void)initProperties {
    _isMocking = NO;
    _timeInverval = 0.2f;

    self.lock = [[NSRecursiveLock alloc] init];
    self.simulateSpeed = 60.0;
}

#pragma mark - Interface

- (void)setSimulateSpeed:(double)simulateSpeed {
    _simulateSpeed = MAX(0, MIN(200, simulateSpeed));

    [self.lock lock];
    self.speed = _simulateSpeed / 3.6f;
    self.distancePerStep = self.timeInverval * self.speed;
    [self.lock unlock];
}

- (void)setKeyCoordinates:(CLLocationCoordinate2D *)coordinates count:(unsigned long)count {
    if (self.isMocking) {
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

- (void)startMockPoint {
    if (self.isMocking) {
        return;
    }

    if (_locationsThread) {
        [_locationsThread cancel];
        _locationsThread = nil;
    }

    self.isMocking = YES;

    _locationsThread = [[NSThread alloc] initWithTarget:self selector:@selector(locationThreadEntryMethod) object:nil];
    [_locationsThread setName:@"com.amap.AGMMultiPointMockThread.coordinate"];
    [_locationsThread start];
}

- (void)stopMockPoint {
    if (_locationsThread) {
        [_locationsThread cancel];
        _locationsThread = nil;
    }

    self.isMocking = NO;
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
        double course = [AGMCaclUtil angleBetweenCoord:*(_oriCoordinates + 1) andCoord:firstCoord];
        [NSThread sleepForTimeInterval:self.timeInverval];
        [self invokeDelegateWithCoordinate:firstCoord course:course];
    }

    while (currentIndex < _count - 1 && _locationsThread && ![_locationsThread isCancelled]) {
        // 如果当前线程任务已经cancel,则直接退出执行
        if ([[NSThread currentThread] isCancelled]) {
            return;
        }

        double dis = [AGMCaclUtil distanceBetweenCoord:*(_oriCoordinates + currentIndex)
                                            andCoord:*(_oriCoordinates + currentIndex + 1)];
        if (currentIndex == 0) {
            totalDis = dis; //init
        }

        CLLocationCoordinate2D resultCoordinate = kCLLocationCoordinate2DInvalid;
        double course = 0;

        if (totalDis >= stepTotalDistance) {
            resultCoordinate = [AGMCaclUtil coordFromCoord:*(_oriCoordinates + currentIndex)
                                                 toCoord:*(_oriCoordinates + currentIndex + 1)
                                                withRate:((dis - (totalDis - stepTotalDistance)) / dis)];
            stepTotalDistance += self.distancePerStep;

        } else {
            currentIndex++;
            if (currentIndex + 1 < _count) {
                totalDis += [AGMCaclUtil distanceBetweenCoord:*(_oriCoordinates + currentIndex)
                                                   andCoord:*(_oriCoordinates + currentIndex + 1)]; //下一段
            } else {
                resultCoordinate = *(_oriCoordinates + currentIndex); //不够，直接取终点
            }
        }

        if (CLLocationCoordinate2DIsValid(resultCoordinate)) {
            course = [AGMCaclUtil angleBetweenCoord:*(_oriCoordinates + currentIndex) andCoord:resultCoordinate];//角度
            [NSThread sleepForTimeInterval:self.timeInverval];
            [self invokeDelegateWithCoordinate:resultCoordinate course:course];
        }
    }
    self.isMocking = NO; //到达终点，循环结束后走到这里
}

- (void)invokeDelegateWithCoordinate:(CLLocationCoordinate2D)coordinate course:(CLLocationDirection)course {
    CLLocation *newLocation = [[CLLocation alloc] initWithCoordinate:coordinate
                                                            altitude:30.f
                                                  horizontalAccuracy:5
                                                    verticalAccuracy:10.f
                                                              course:course
                                                               speed:self.speed
                                                           timestamp:[NSDate date]];
    //默认定位回调，派发到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        [[AGMSinglePointMocker sharedInstance] startMockPoint:newLocation];
//        if (self.delegate) {
//            [self.delegate gpsEmulatorUpdateLocation:newLocation];
//        }
    });
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
        double dis = [AGMCaclUtil distanceBetweenCoord:*(_oriCoordinates + i) andCoord:*(_oriCoordinates + i + 1)];
        if (totalDistance <= dis) {
            resultDistance = totalDistance;
            resultCoordiante = [AGMCaclUtil coordFromCoord:*(_oriCoordinates + i) toCoord:*(_oriCoordinates + i + 1) withRate:totalDistance / dis];
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
