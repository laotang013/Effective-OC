
//
//  NSTimer+EOCBlockSupport.m
//  InitDemo
//
//  Created by Start on 2017/11/2.
//  Copyright © 2017年 het. All rights reserved.
//

#import "NSTimer+EOCBlockSupport.h"

@implementation NSTimer (EOCBlockSupport)
//这段代码将计时器所应执行的任务封装成块,在调用计时器函数时，把它作为userInfo参数传进去。该参数可用来存放不透明值。只要计时器还有效，就会一直保留它。
//传入参数时要通过copy方法将block拷贝到堆上。否则等到稍后要执行它的时候,该块可能已经无效了。
+(NSTimer *)eoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(TimeBlock)timeBlock
                                       repeats:(BOOL)repeat
{
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(eoc_blockInvoke:) userInfo:[timeBlock copy] repeats:repeat];
}
+(void)eoc_blockInvoke:(NSTimer *)timer
{
    //通过userInfo传入
    TimeBlock block = timer.userInfo;
    if (block) {
        block();
    }
}
@end
