//
//  ViewController.m
//  S_GCD
//
//  Created by helios on 2019/9/19.
//  Copyright © 2019 helios. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //create GCD
    
    /*
    [self mainThreadLocked];
    [self sentinelQueueLocked];
    [self concurrentQueueAndSync];
    [self sentinelQueueAndSyncLocked];
    [self sentinelQueueAndAsync];
    [self concurrentlQueueAndAsync];
    [self mainQueueAndAsync];
    */
    
    
    
}
// 异步执行 + 串行队列
- (void)sentinelQueueAndAsync {
    //并发队列
    dispatch_queue_t sentinelQueue = dispatch_queue_create("BundleIdentifier", DISPATCH_QUEUE_SERIAL);
    NSLog(@"1--%@", [NSThread currentThread]);
    //异步执行
    dispatch_async(sentinelQueue, ^{
        NSLog(@"2--%@", [NSThread currentThread]);
    });
    NSLog(@"3--%@", [NSThread currentThread]);
}
// 异步执行 + 并发
- (void)concurrentlQueueAndAsync {
    //并发队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("BundleIdentifier", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"1--%@", [NSThread currentThread]);
    //异步执行
    dispatch_async(concurrentQueue, ^{
        NSLog(@"2--%@", [NSThread currentThread]);
    });
    NSLog(@"3--%@", [NSThread currentThread]);
}
// 异步执行+ 主队列
- (void)mainQueueAndAsync {
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    NSLog(@"1--%@", [NSThread currentThread]);
    //异步执行
    dispatch_async(mainQueue, ^{
        NSLog(@"2--%@", [NSThread currentThread]);
    });
    NSLog(@"3--%@", [NSThread currentThread]);
}


//并发队列 + 同步执行
- (void)concurrentQueueAndSync {
    //并发队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("BundleIdentifier", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"1--%@", [NSThread currentThread]);
    //同步执行
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"2--%@", [NSThread currentThread]);
    });
    NSLog(@"3--%@", [NSThread currentThread]);
}

//串行队列 + 同步执行
- (void)sentinelQueueAndSyncLocked {
    //串行队列
    dispatch_queue_t sentinelQueue = dispatch_queue_create("BundleIdentifier", DISPATCH_QUEUE_SERIAL);
    NSLog(@"1--%@", [NSThread currentThread]);
    //同步执行
    dispatch_sync(sentinelQueue, ^{
        NSLog(@"2--%@", [NSThread currentThread]);
    });
    NSLog(@"3--%@", [NSThread currentThread]);
}

- (void)sentinelQueueLocked {
    dispatch_queue_t sentinelQueue = dispatch_queue_create("BundleIdentifier", DISPATCH_QUEUE_SERIAL);
    NSLog(@"1");
    dispatch_async(sentinelQueue, ^{ //串行队列+异步任务
        NSLog(@"2");
        dispatch_sync(sentinelQueue, ^{ //同步执行 +当前串行队列
            //追加任务
            NSLog(@"3");
            [NSThread sleepForTimeInterval:1];
            NSLog(@"%@", [NSThread currentThread]);
        });
    });
}
// 主线程中调用主队列+同步任务发生死锁
- (void)mainThreadLocked {
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    NSLog(@"1");
    dispatch_sync(mainQueue, ^{
        NSLog(@"2");
    });
    NSLog(@"3");
}


@end
