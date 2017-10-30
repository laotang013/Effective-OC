//
//  Rectangle.m
//  InitDemo
//
//  Created by Start on 2017/10/25.
//  Copyright © 2017年 het. All rights reserved.
//

#import "Rectangle.h"
@interface Rectangle()
{
    struct{
        unsigned int didSend : 1;
    }_delegateFalgs;
}

//既能令外界无法修改对象，又能在其内部按照需要管理其数据。这样封装在类中的数据就由实例
//本身来控制。而外部代码无法修改其值.（外部为readOnly 内部为readwrite）
//问题: 若观察者正读取属性值而内部代码又在写入该属性时。则可能引发竞争条件。合理使用同步机制。能缓解此问题。

@property(nonatomic,assign,readwrite)float width;
-(void)p_privateTest;//增加一个前缀 表示其为私有方法
//ps:先把方法原型写出来。然后在逐个实现。要想使类的代码更容易读懂。
@end
@implementation Rectangle
{
    NSMutableSet *_friends;
}
-(instancetype)initWithWidth:(float)width andHeight:(float)height
{
    if (self = [super init]) {
        _width = width;
        _height = height;
        
    }
    return self;
}
-(instancetype)init
{
    return [self initWithWidth:5.0 andHeight:10.0f];
}

-(void)test1
{
    self.width = 1.0f;
}

#pragma mark - 代理方法
-(void)test
{
    //设置标志位
    _delegateFalgs.didSend = 1;
    //判断这个委托多想能否响应相关选择子 检查flag
    if (_delegateFalgs.didSend) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(doitForRectangle:nameStr:)]) {
            
            //将委托的实例也一并传入方法中。
            [self.delegate doitForRectangle:self nameStr:@"代理方法"];
        }
    }
}

-(void)setDelegate:(id<RectangleDelegate>)delegate
{
    _delegate = delegate;
    //这样的话每次调用delegate的相关方法 就不用检测委托对象是否能响应给定的选择子而是直接查询结构体里的标志。
    _delegateFalgs.didSend = [self.delegate respondsToSelector:@selector(doitForRectangle:nameStr:)];
}

#pragma mark - **************** description
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@,%p,width: %.2f,height:%.2f",[self class],self,_width,_height];
}
#pragma mark - **************** 方法的回调的第二种方法
-(BOOL)dosomething:(NSError **)error
{
    
    [self test];
    
    NSError *error1 = [NSError errorWithDomain:NSURLErrorDomain code:@"100010" userInfo:@{@"status":@"错误信息"}];
    if (error) {
        *error = error1;
        return NO;
    }else
    {
        return YES;
    }
  
}

#pragma mark - copy方法
- (id)copyWithZone:(nullable NSZone *)zone
{
    Rectangle *copy = [[[self class]allocWithZone:zone]initWithWidth:_width andHeight:_height];
    //使用->语法 因为_friends并非属性，只是个在内部使用的实例变量。
    copy->_friends = [_friends mutableCopy]; //浅拷贝
    copy->_friends = [[NSMutableSet alloc]initWithSet:_friends copyItems:YES];//深拷贝
    return copy;
    
       //深拷贝
       /*
        创建新的对象空间 为每个属性创建新的空间并将内容复制。
        -(id)copyWithZone:(NSZone *)zone
        {
        //创建新的对象空间
        Student *stu = [[self class] allocWithZone:zone];
        
        //为每个属性创建新的空间，并将内容复制
        stu.name = [[NSString alloc] initWithString:self.name];
        stu.sex = [[NSString alloc] initWithString:self.sex];
        stu.age = self.age;
        
        return stu;
        }
        
        作者：tanyufeng
        链接：http://www.jianshu.com/p/f01d490401f9
   
      因为没有专门定义深拷贝的协议，所以其具体执行的方式由每个类来决定。你只需要决定自己所写的类是否要提供深拷贝方法即可。另外不要嘉定遵从NSCopying协议对象都会进行深拷贝。在绝大多数情况下执行的都是浅拷贝。如果需要执行深拷贝，那么除非该类的文档说他是用深拷贝来实现NSCopying协议的。否则要么寻找能够执行深拷贝的相关方法要么自己编写方法来做。
     */
    
}
@end
