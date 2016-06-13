//
//  HYGCDTimer.m
//  Pods
//
//  Created by fangyuxi on 16/6/13.
//
//

#import "HYGCDTimer.h"
#import <libkern/OSAtomic.h>

static OSSpinLock mutexLock;

#pragma mark lock

static inline void lock()
{
    OSSpinLockLock(&mutexLock);
}

static inline void unLock()
{
    OSSpinLockUnlock(&mutexLock);
}


@interface HYGCDTimer ()

@property (readwrite, getter=isValid) BOOL valid;

@end

@implementation HYGCDTimer{
    
    dispatch_queue_t _timerQueue;
    BOOL _repeats;
    dispatch_block_t _block;
    id _userInfo;
    
    dispatch_source_t _timer;
}

@synthesize valid = _valid;

+ (HYGCDTimer *)scheduledWithTimeInterval:(NSTimeInterval)interval
                                    queue:(dispatch_queue_t)queue
                                  repeats:(BOOL)repeats
                                   action:(dispatch_block_t)action
                                tolerance:(NSTimeInterval)tolerance
                                 userInfo:(id)userInfo
{
    HYGCDTimer *timer = [[HYGCDTimer alloc] initWithTimeInterval:interval
                                                           queue:queue
                                                         repeats:repeats
                                                          action:action
                                                       tolerance:tolerance
                                                        userInfo:userInfo];
    [timer fire];
    return timer;
}

- (instancetype)init
{
    return [self initWithTimeInterval:0
                                queue:nil
                              repeats:YES
                               action:^(){}
                            tolerance:0
                             userInfo:nil];
}

- (HYGCDTimer *)initWithTimeInterval:(NSTimeInterval)interval
                               queue:(dispatch_queue_t __nullable)queue
                             repeats:(BOOL)repeats
                              action:(dispatch_block_t)action
                           tolerance:(NSTimeInterval)tolerance
                            userInfo:(id __nullable)userInfo
{
    self = [super init];
    if (self)
    {
        mutexLock = OS_SPINLOCK_INIT;
        
        lock();
        
        _timerQueue = queue == nil ? dispatch_get_main_queue():queue;
        _repeats = repeats;
        _block = [action copy];
        _userInfo = userInfo;

        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, (tolerance == 0 ? 0.1:tolerance) * NSEC_PER_SEC);
        
        __weak typeof(self) weakSelf = self;
        dispatch_source_set_event_handler(_timer, ^{
            _block();
            
            if (!_repeats) {
                [weakSelf invalidate];
            }
        });
        
        _valid = YES;
        
        unLock();
        
        return self;
    }
    return nil;
}


- (void)fire
{
    lock();
    
    if (_timer)
    {
        dispatch_resume(_timer);
    }
    
    unLock();
}

- (void)invalidate
{
    lock();
    
    if (_timer)
    {
        if (_valid)
        {
            _valid = NO;
            dispatch_source_cancel(_timer);
            _timer = NULL;
            _block = nil;
            _userInfo = nil;
            _timerQueue = nil;
        }
    }
    
    unLock();
}

- (void)setValid:(BOOL)valid
{
    lock();
    _valid = valid;
    unLock();
}

- (BOOL)isValid
{
    lock();
    return _valid;
    unLock();
}

@end
