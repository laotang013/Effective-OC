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
