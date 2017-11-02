//
//  Square.m
//  InitDemo
//
//  Created by Start on 2017/10/25.
//  Copyright © 2017年 het. All rights reserved.
//

#import "Square.h"

@implementation Square
+(void)load
{
    NSLog(@"Square");
}


//即使子类没有实现initialize方法,它也会收到这条消息。由各级超类所实现的initialize也会先调用。遵从继承规则。
+(void)initialize
{
    if (self == [Square class]) {
        NSLog(@"Square initialize");
    }
}
@end
