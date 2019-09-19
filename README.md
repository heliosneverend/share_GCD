# share_GCD
总结以及分享
## GCD 

 ### 是什么是GCD
 Grand Central Dispatch (GCD)是Apple开发的一个多核编程的较新的解决方法。它主要用于优化应用程序以支持多核处理器以及其他对称多处理系统。它是一个在线程池模式的基础上执行的并行任务。在Mac OS X 10.6雪豹中首次推出，也可在IOS 4及以上版本使用。
 ### 使用GCD的优势
 GCD 可用于多核的并行运算；
 GCD 会自动利用更多的 CPU 内核（比如双核、四核）；
 GCD 会自动管理线程的生命周期（创建线程、调度任务、销毁线程）；
 程序员只需要告诉 GCD 想要执行什么任务，不需要编写任何线程管理代码。
 ### GCD的任务和队列
 #### 任务 
 任务 是执行操作的意思 也就是在线程中执行的那段代码, 执行任务有两种方式`同步执行`以及`异步执行`,两者主要的区别就是是否等待队列任务执行结束,以及是否有开辟新线程的能力
 ##### 同步执行 sync
 同步添加任务到执行的队列中 在添加的任务执行完成之前一直等待下去 直到队列中的任务执行完成再继续执行下面的任务
 只能在当前的线程内执行队列 不能开辟新的线程
 ##### 异步执行 async
 异步添加任务到队列中 不会做任何等待 可以继续执行下面的任务
 可以在新的线程中执行任务 具备开辟新线程的能力 
 异步执行虽然有开辟新线程的能力 但是不一定会开启新的线程 这个和任务指定的队列有关
`同步执行 A给B打电话的时候不能同时打电话给C 得等待和B的通话结束后才能打给C(等待任务执行结束) 且只能使用当前的电话(不具备开启线程的能力)`
`异步执行 A打电话给B的时候 不用等B通话结束就可以给C打电话(不用等待任务结束),而且可以使用其他的手机(具备开启线程的能力)`
### 队列
执行任务的等待队列 即是指存放任务的队列 队列是一种特殊的线程表 采用FIFO原则 即新任务总是插入到队列的末尾 而读取任务的时候从队列的头部开始读取 每读取一个任务就从队列中释放一个任务 队列结构如图所示
![队列结构](/assets/1.png)
在GCD中有两种队列`串行队列`和`并发队列`两者都是符合FIFO原则的 两者的主要的区别是 执行顺序不同 以及开启的线程数不同
#### 串行队列
每次只有1个任务被执行 让任务1个1个的执行(只会开启1个线程 1个任务1个任务的执行完毕 再开始执行下一个任务)
#### 并发队列
可以让多个任务并发执行 (可以开启多个线程 并且同时执行任务)
`并发队列`的并发功能只在异步任务的时候才会有效
两者的区别如下
![并打队列和串行队列的区别](/assets/2.png)

## GCD的使用步骤
1 创建一个队列(串行队列或者并行队列)
2 将任务追加到任务的等待队列中,然后系统通过任务类型执行任务(同步执行或者异步执行)
### 队列的创建方法/获取方法
```
    //串行队列
    dispatch_queue_t sentinelQueue = dispatch_queue_create("BundleIdentifier", DISPATCH_QUEUE_SERIAL);
    //并行队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("BundleIdentifier", DISPATCH_QUEUE_CONCURRENT);
}
```
第一个参数标识队列的唯一标识符 用于DEBUG 可以为空 队列的名字推荐使用app的BundleIdentifier
第二个参数来识别是串行队列还是并发队列 `DISPATCH_QUEUE_SERIAL`标识串行队列 `DISPATCH_QUEUE_CONCURRENT`表示的是并行队列
对于串行队列 GCD提供了一种特殊的串行队列 `主队列` Main Dispatch Queue
所有放在主队列的任务都会放在主线程里面执行
可以使用`dispatch_get_main_queue()`来获取主队列
```
    dispatch_queue_t mainQueue = dispatch_get_main_queue();  
```
对于并发队列 GCD提供了全局并发队列(Global Dispatch Queue)
可以使用`dispatch_get_global_queue`方法获取全局并发队列 需要传入两个参数 第一个是队列的优先级 一般使用`DISPATCH_QUEUE_PRIORITY_DEFAULT` 第二个参数暂时没有用 用0即可
```
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
```

### 任务的创建方法
GCD提供同步执行任务的方法`dispatch_sync`和异步执行任务创建方法`dispatch_async`
```
    //同步执行
    dispatch_sync(sentinelQueue, ^{
        
    });
    //异步执行
    dispatch_async(concurrentQueue, ^{
        
    });
```
目前CGD就创建完成了 但是两种队列(串行队列/并发队列) 两种执行方式(同步执行/异步执行)加上全局并发和主队列 全局并发类似于并普通队列这样两两组合就产生下面6种组合
`同步执行+并发队列` 现Demo `[self concurrentQueueAndDispatchSync]`
`同步执行+串行队列` 现Demo `[self sentinelQueueAndSyncLocked]`
`同步执行+主队列`   现Demo `[self mainThreadLocked]`
`异步执行+串行队列` 现Demo `[sentinelQueueAndAsync]`
`异步执行+并发队列` 现Demo `[self concurrentlQueueAndAsync]`
`异步执行+主队列` 现Demo   `[self mainQueueAndAsync]`主队列 + 异步不会出现新的线程

### 任务和不同队列组合方式的区别
如下
![任务+队列的却别](/assets/3.png)
从上边可看出： 主线程中调用主队列+同步执行会导致死锁问题。这是因为 主队列中追加的同步任务和主线程本身的任务 两者之间相互等待，阻塞了主队列，最终造成了主队列所在的线程（主线程）死锁问题。而如果我们在其他线程调用主队列+同步执行，则不会阻塞主队列，自然也不会造成死锁问题。最终的结果是：不会开启新线程，串行执行任务 (主队列等同步任务执行完释放主线程 同步任务在等主线程释放在再执行)))
```
- (void)mainThreadLocked {
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    NSLog(@"1");
    dispatch_sync(mainQueue, ^{
        NSLog(@"2");
    });
    NSLog(@"3");
}
```
### 队列嵌套情况下不同组合方式的区别
除了上面的主线程中调用主队列+同步执行会造成相互等待造成的死锁外 在串行队列中也可能出现阻塞串行队列所在线程的情况 从而造成死锁 这种常见于同一个串行队列嵌套使用
```
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
```
print 1  2 死锁
async任务等sync任务执行完释放 而sync在等async执行完释放 相互等待造成的死锁
`执行上面的代码会导致 串行队列中追加的任务 和 串行队列中原有的任务 两者之间相互等待，阻塞了『串行队列』，最终造成了串行队列所在的线程（子线程）死锁问题。`
不同队列+不同任务组合，以及队列中嵌套队列使用的区别：
![任务+队列嵌套队列的区别](/assets/4.png)

### 关于不同的队列和不同的任务的理解
假设现在有 5 个人要穿过一道门禁，这道门禁总共有 10 个入口，管理员可以决定同一时间打开几个入口，可以决定同一时间让一个人单独通过还是多个人一起通过。不过默认情况下，管理员只开启一个入口，且一个通道一次只能通过一个人。
这个故事里，人好比是 任务，管理员好比是 系统，入口则代表 线程。
5 个人表示有 5 个任务，10 个入口代表 10 条线程。
串行队列 好比是 5 个人排成一支长队。
并发队列 好比是 5 个人排成多支队伍，比如 2 队，或者 3 队。
同步任务 好比是管理员只开启了一个入口（当前线程）。
异步任务 好比是管理员同时开启了多个入口（当前线程 + 新开的线程）。

异步执行 + 并发队列 可以理解为：现在管理员开启了多个入口（比如 3 个入口），5 个人排成了多支队伍（比如 3 支队伍），这样这 5 个人就可以 3 个人同时一起穿过门禁了。
同步执行 + 并发队列  可以理解为：现在管理员只开启了 1 个入口，5  个人排成了多支队伍。虽然这 5 个人排成了多支队伍，但是只开了 1 个入口啊，这 5 个人虽然都想快点过去，但是 1 个入口一次只能过 1 个人，所以大家就只好一个接一个走过去了，表现的结果就是：顺次通过入口

#### 换成 GCD 里的语言就是说：
1 异步执行 + 并发队列 就是：系统开启了多个线程（主线程+其他子线程），任务可以多个同时运行。
2 同步执行 + 并发队列 就是：系统只默认开启了一个主线程，没有开启子线程，虽然任务处于并发队列中，但也只能一个接一个执行了。