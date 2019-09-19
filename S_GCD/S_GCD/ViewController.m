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
    
    //串行队列
    dispatch_queue_t sentinelQueue = dispatch_queue_create("BundleIdentifier", DISPATCH_QUEUE_SERIAL);
    //并行队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("BundleIdentifier", DISPATCH_QUEUE_CONCURRENT);
    //主线程队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //全局并发队列
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //同步执行
    dispatch_sync(sentinelQueue, ^{
        
    });
    //异步执行
    dispatch_async(concurrentQueue, ^{
        
    });
}


@end
