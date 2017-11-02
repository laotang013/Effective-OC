//
//  ViewController.m
//  InitDemo
//
//  Created by Start on 2017/10/25.
//  Copyright © 2017年 het. All rights reserved.
//

#import "ViewController.h"
#import "Rectangle.h"
#import "EOCClass.h"
#import "Square.h"
@interface ViewController ()<RectangleDelegate>
@property (nonatomic,strong) EOCClass *eocClass;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Rectangle *rectangle = [[Rectangle alloc]init];
    [rectangle setValue:@(20.0f) forKey:@"width"];
    NSLog(@"width: %f  height: %f,",rectangle.width,rectangle.height);
    NSLog(@"rectangle.width: %.2f",rectangle.width);
    NSLog(@"%@",rectangle);
    #pragma mark - 代理方法
    rectangle.delegate = self;
    //错误回调
    NSError *error = nil;
    if (![rectangle dosomething:&error]) {
        NSLog(@"error: %@",error);
    }

    rectangle.someThing = @"你好";
    rectangle.someThing = @"大家好";
    NSLog(@"rectangle.someThing%@",rectangle.someThing);
    NSLog(@"rectangle.someThing%@",rectangle.someThing);
    
    
    /*
     块强大之处在于:在声明他的范围里,所有变量都可以为其捕获，这就是说那个范围里的全部变量，在块里依然可用。
     默认情况 为块所捕获的变量，是不可以在块里面修改的。加上__block修饰符，这样就可以在块内修改了。
     */
    
    int additaional = 5;
    int (^addBlock)(int a,int b) = ^(int a,int b)
    {
        return a+b+additaional;
    };
    NSLog(@"block值为:%d",addBlock(2,5));
    
    
    #pragma mark - **************** 定时器
    self.eocClass = [[EOCClass alloc]init];
    [self.eocClass startPolling];
    //说明: 由于目标对象是self 所以保留了此实例 2.因为计时器是实例变量存放的。所以实例变量也保留了计时器。 这样就形成了保留环。
    //打破保留环 1.改变实例变量或令计时器无效 调用stopPolling 要么令系统将此实例回收。只有这样才能打破保留环。
    
    
    Square *square = [[Square alloc]init];
    
}

#pragma mark - **************** 同步锁
//同步块
-(void)synchronizedMethod
{
    @synchronized(self)//同步行为所针对的是self. 共用同一锁的那些同步块都必须按顺序执行，若是self对象上的频繁加锁。那么程序可能另一段与此无关的代码执行完毕。
    {
        //Safe...
        //这种写法根据给定的对象，自动创建一个锁，并等待块中的代码执行完毕。执行到这段代码结尾处，锁就释放了。
        
    }
}


//NSLock对象
-(void)lockMethod
{
    NSLock *lockMethod = [[NSLock alloc]init];
    [lockMethod lock];
    //Safe
    [lockMethod unlock];
}

//极端情况下 同步块会导致死锁。

#pragma mark - RectangleDelegate
-(void)doitForRectangle:(Rectangle *)rectangle nameStr:(NSString *)str
{
     NSLog(@"代理:%@ --%@",rectangle,str);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
