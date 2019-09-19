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
     [self syncConcurrent];
     [self asyncConcurrent];
     [self syncSerial];
     [self asyncSerial];
     // 使用 NSThread 的 detachNewThreadSelector 方法会创建线程，并自动启动线程执行 selector 任务
     [NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];
     [self asyncMain];
    */
    [self communication];
    
}
/**
 * 线程间通信
 */
- (void)communication {
    // 获取全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 获取主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    NSLog(@"begin");
    dispatch_async(queue, ^{
        // 异步追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        
        // 回到主线程
        dispatch_async(mainQueue, ^{
            // 追加在主线程中执行的任务
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        });
    });
    NSLog(@"end");
}

/**
 * 异步执行 + 主队列
 * 特点：只在主线程中执行任务，执行完一个任务，再执行下一个任务
 */
- (void)asyncMain {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_async(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_async(queue, ^{
        // 追加任务 3
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    NSLog(@"asyncMain---end");
}
/**
 * 同步执行 + 主队列
 * 特点(主线程调用)：互等卡主不执行。
 * 特点(其他线程调用)：不会开启新线程，执行完一个任务，再执行下一个任务。
 */
- (void)syncMain {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_sync(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_sync(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_sync(queue, ^{
        // 追加任务 3
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    NSLog(@"syncMain---end");
}
/**
 * 异步执行 + 串行队列
 * 特点：会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)asyncSerial {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    dispatch_async(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    dispatch_async(queue, ^{
        // 追加任务 3
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    NSLog(@"asyncSerial---end");
}

/**
 * 同步执行 + 并发队列
 * 特点：在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。
 */
- (void)syncConcurrent {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncConcurrent---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_sync(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_sync(queue, ^{
        // 追加任务 3
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    NSLog(@"syncConcurrent---end");
}

/**
 * 异步执行 + 并发队列
 * 特点：可以开启多个线程，任务交替（同时）执行。
 */
- (void)asyncConcurrent {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncConcurrent---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_async(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_async(queue, ^{
        // 追加任务 3
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    NSLog(@"asyncConcurrent---end");
}
/**
 * 同步执行 + 串行队列
 * 特点：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)syncSerial {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    dispatch_sync(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    dispatch_sync(queue, ^{
        // 追加任务 3
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    NSLog(@"syncSerial---end");
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
