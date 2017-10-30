//
//  ViewController.m
//  InitDemo
//
//  Created by Start on 2017/10/25.
//  Copyright © 2017年 het. All rights reserved.
//

#import "ViewController.h"
#import "Rectangle.h"
@interface ViewController ()<RectangleDelegate>

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
    
    
    
    
}

#pragma mark - **************** 同步锁
-(void)synchronizedMethod
{
    @synchronized(self)
    {
        //Safe...
    }
}


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
