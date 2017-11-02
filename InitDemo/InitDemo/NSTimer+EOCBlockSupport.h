//
//  NSTimer+EOCBlockSupport.h
//  InitDemo
//
//  Created by Start on 2017/11/2.
//  Copyright © 2017年 het. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^TimeBlock)();
@interface NSTimer (EOCBlockSupport)
//通过块来解决循环引用问题。。。
//_pollTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(p_doPoll) userInfo:nil repeats:YES];
+(NSTimer *)eoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(TimeBlock)timeBlock
                                       repeats:(BOOL)repeat;
@end
