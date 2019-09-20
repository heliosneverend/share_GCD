//
//  ViewController.m
//  Share_pthread_NSThread
//
//  Created by helios on 2019/9/20.
//  Copyright © 2019 helios. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>
@interface ViewController ()
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, assign)NSUInteger num;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:self.imageView];
    // Do any additional setup after loading the view.
//    [self createThread];
//    [self createNSThread];
  //  [self downloadImageOnSubThread];
    [self initTicketStatusNotSave];
}

- (void)initTicketStatusNotSave {
    self.num = 50;
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(saleTicket) object:nil];
    thread.name = @"北京窗口";
    [thread start];
    
    NSThread *thread_s= [[NSThread alloc]initWithTarget:self selector:@selector(saleTicket) object:nil];
    thread_s.name = @"上海窗口";
    [thread_s start];
}
- (void)unSaleTicket {
    while (1) {
        if (self.num > 0) {
            self.num --;
            NSLog(@"---当前窗口%@--剩余票数%ld", [NSThread currentThread].name, self.num);
            [NSThread sleepForTimeInterval:0.1];
        } else {
            NSLog(@"---售罄----");
            return;
        }
    }
}
- (void)saleTicket {
    while (1) {
        @synchronized (self) {
            if (self.num > 0) {
                self.num --;
                NSLog(@"---当前窗口%@--剩余票数%ld", [NSThread currentThread].name, self.num);
                [NSThread sleepForTimeInterval:0.1];
            } else {
                NSLog(@"---售罄----");
                return;
            }
        }
    }
}
- (void)autoStartThread {
    [NSThread detachNewThreadSelector:@selector(runMethod) toTarget:self withObject:nil];
}
- (void)createNSThread {
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(runMethod) object:nil];
    [thread start];
}
- (void)runMethod {
    NSLog(@"%@", [NSThread currentThread]);
}
- (void)createThread{
    //创建线程
    pthread_t thread;
    // 2. 开启线程: 执行任务
    pthread_create(&thread, NULL, run, NULL);
    //3. 设置子线程的状态设置为 detached，该线程运行结束后会自动释放所有资源;
    pthread_detach(thread);
    
}
void *run(void *param) {
    NSLog(@"%@",[NSThread currentThread]);
    return NULL;
}

/**
 * 创建一个线程下载图片
 */
- (void)downloadImageOnSubThread {
    // 在创建的子线程中调用downloadImage下载图片
    [NSThread detachNewThreadSelector:@selector(downloadImage) toTarget:self withObject:nil];
}

/**
 * 下载图片，下载完之后回到主线程进行 UI 刷新
 */
- (void)downloadImage {
    NSLog(@"current thread -- %@", [NSThread currentThread]);
    // 1. 获取图片 imageUrl
    NSURL *imageUrl = [NSURL URLWithString:@"http://image.baidu.com/search/detail?z=0&word=%E8%82%96%E5%85%A8&hs=0&pn=2&spn=0&di=0&pi=44224719004&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cs=1569301697%2C174686899&os=&simid=&adpicid=0&lpn=0&fm=&sme=&cg=&bdtype=-1&oriquery=&objurl=http%3A%2F%2Fe.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fdc54564e9258d1092f7663c9db58ccbf6c814d30.jpg&fromurl=&gsm=&catename=pcindexhot&islist=&querylist="];
    
    // 2. 从 imageUrl 中读取数据(下载图片) -- 耗时操作
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    // 通过二进制 data 创建 image
    UIImage *image = [UIImage imageWithData:imageData];
    // 3. 回到主线程进行图片赋值和界面刷新
    [self performSelectorOnMainThread:@selector(refreshOnMainThread:) withObject:image waitUntilDone:YES];
}

/**
 * 回到主线程进行图片赋值和界面刷新
 */
- (void)refreshOnMainThread:(UIImage *)image {
    NSLog(@"current thread -- %@", [NSThread currentThread]);
    // 赋值图片到imageview
    self.imageView.image = image;
}


@end
