//
//  TestHook.m
//  InitDemo
//
//  Created by Start on 2017/11/3.
//  Copyright © 2017年 het. All rights reserved.
//

#import "TestHook.h"
#import <objc/objc.h>
#import <objc/runtime.h>
@implementation TestHook
+(void)initialize
{
   
    // 获取到UIWindow中sendEvent对应的method
     Method sendEvent = class_getInstanceMethod([UIWindow class], @selector(sendEvent:));
    //获取到自定义类中的sendEventMethod
    Method sendEventMyself = class_getInstanceMethod([self class], @selector(sendEventHooked:));
    //将目标函数的原实现绑定到sendEventOriginalImplemention方法上
    IMP sendEventIMP = method_getImplementation(sendEvent);
    //给UIVindow添加一个方法sendEventOrigianl的方法该方法使用该方法使用UIwindow原生的sendEvent实现
    class_addMethod([UIWindow class], @selector(sendEventOriginal:), sendEventIMP, method_getTypeEncoding(sendEvent));
    //获取到我们自己的函数实现替换目标函数对应的实现
    IMP sendEventMySelfIMP = method_getImplementation(sendEventMyself);
    class_replaceMethod([UIWindow class], @selector(sendEvent:), sendEventMySelfIMP, method_getTypeEncoding(sendEvent));
}



/**截获到window的sendEvent 我们可以先处理完以后再调用正常处理流程*/
-(void)sendEventHooked:(UIEvent *)event
{
    NSLog(@"this is my self sendEventMethod");
    //[UIWindow performSelector:@selector(sendEventOriginal:) withObject:event];
    //这块儿你可能有个困惑 “我们自定义类中明明是没有sendEventOriginal方法的啊？”
}


-(void)test
{
    //简介
    //通过SEL获取一个方法
    //class_getInstanceMethod(<#Class  _Nullable __unsafe_unretained cls#>, <#SEL  _Nonnull name#>)
    //获取一个方法的实现
    //method_getImplementation(<#Method  _Nonnull m#>)
    //获取一个OC实现的编码类型
    //method_getTypeEncoding
    //給方法添加实现
    //class_addMethod
    //用一个方法的实现替换另一个方法的实现
    //class_replaceMethod
    //交换两个方法的实现
    //method_exchangeImplementations
}
@end
