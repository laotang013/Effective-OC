//
//  Rectangle+Customer.m
//  InitDemo
//
//  Created by Start on 2017/10/26.
//  Copyright © 2017年 het. All rights reserved.
//
#import <objc/runtime.h>
#import "Rectangle+Customer.h"
static const char *kFriendsPropertyKey = "kFriendsPropertyKey";
@implementation Rectangle (Customer)
//使用关联对象能够解决分类中不能合成实例变量的问题
/*
 问题:
     这样做可行，但是不太理想要想把相似代码写很多遍而且在内存管理问题上容易出错。
     因为我们在为属性实现存取方法时，经常会忘记遵从其内存管理语义。比方说，你可能通过属性特质修改了某个属性的内存管理语义。而此时还要记得在设置方法中也得修改设置关联对象时所用的内存管理语义才行。
     -- 把属性定义在主接口中要比定义在分类中清晰得多。
 
 要点: 1.把封装数据所用的全部属性都定义在主接口里。
      2.在分类之后的其他分类中可以定义存取方法但尽量不要定义属性。
 */
-(NSArray *)friends
{
    return objc_getAssociatedObject(self, kFriendsPropertyKey);
}
-(void)setFriends:(NSArray *)friends
{
    objc_setAssociatedObject(self, kFriendsPropertyKey,friends, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
