//
//  HYGCDTimer.h
//  Pods
//
//  Created by fangyuxi on 16/6/13.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYGCDTimer : NSObject


/**
 *  创建 并 执行 允许误差0.1秒
 *
 *  @param interval     timer回调的时间间隔
 *  @param queue        timer运行在哪个queue中 默认main queue
 *  @param repeats      是否重复执行
 *  @param action       执行的block
 *  @param tolerance    宽容度 默认 0.1 如果赋值0 那么取默认值
 *  @param userInfo     userInfo
 */
+ (HYGCDTimer *)scheduledWithTimeInterval:(NSTimeInterval)interval
                                 queue:(dispatch_queue_t __nullable)queue
                               repeats:(BOOL)repeats
                                action:(dispatch_block_t)action
                                tolerance:(NSTimeInterval)tolerance
                              userInfo:(id __nullable)userInfo;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/**
 *  创建 允许误差0.1秒
 *
 *  @param interval     timer回调的时间间隔
 *  @param queue        timer运行在哪个queue中 默认main queue
 *  @param repeats      是否重复执行
 *  @param action       执行的block
 *  @param tolerance    宽容度 默认 0.1 如果赋值0 那么取默认值
 *  @param userInfo     userInfo
 */
- (HYGCDTimer *)initWithTimeInterval:(NSTimeInterval)interval
                                 queue:(dispatch_queue_t __nullable)queue
                               repeats:(BOOL)repeats
                                action:(dispatch_block_t)action
                           tolerance:(NSTimeInterval)tolerance
                              userInfo:(id __nullable)userInfo NS_DESIGNATED_INITIALIZER;

/**
 *  开始
 */
- (void)fire;

/**
 *  取消
 */
- (void)invalidate;

/**
 *  是否有效
 */
@property (readonly, getter=isValid) BOOL valid;

/**
 *  userInfo
 */
@property (nullable, readonly, retain) id userInfo;

@end

NS_ASSUME_NONNULL_END



