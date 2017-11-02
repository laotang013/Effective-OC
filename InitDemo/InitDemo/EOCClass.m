


//
//  EOCClass.m
//  InitDemo
//
//  Created by Start on 2017/11/2.
//  Copyright © 2017年 het. All rights reserved.
//

#import "EOCClass.h"
#import "NSTimer+EOCBlockSupport.h"
@implementation EOCClass
{
    NSTimer *_pollTimer;
}
-(instancetype)init
{
    return [super init];
}
-(void)dealloc
{
    [_pollTimer invalidate];
    _pollTimer = nil;
}
-(void)startPolling
{
    //这段代码采用了一个很有效的方法 它先定义了一个弱引用,令其指向self 然后使块捕获这个引用。而不直接去捕获普通的self变量 也就是说self不会为计时器保留当块要开始执行时，立刻生成strong引用。以保证实例变量在执行期间持续存活。
    
   
    __weak EOCClass *weakSelf = self;
    //_pollTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(p_doPoll) userInfo:nil repeats:YES];
    _pollTimer = [NSTimer eoc_scheduledTimerWithTimeInterval:3
                                                       block:^{
        //EOCClass *strongSelf = weakSelf;
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf p_doPoll];
    }
                                                     repeats:YES];
}
-(void)stopPolling
{
    [_pollTimer invalidate];
    _pollTimer = nil;
}
-(void)p_doPoll
{
    NSLog(@"打印。。。");
}


@end
