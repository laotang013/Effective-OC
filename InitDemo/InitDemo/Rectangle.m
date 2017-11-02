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


/**队列*/
@property(nonatomic,strong)dispatch_queue_t syncQueue;
@end

@implementation Rectangle
{
    NSMutableSet *_friends;
    
}
@synthesize someThing = _someThing;
-(instancetype)initWithWidth:(float)width andHeight:(float)height
{
    if (self = [super init]) {
        _width = width;
        _height = height;
        _syncQueue = dispatch_get_global_queue(0, 0);
        
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

#pragma mark - **************** GCD
-(NSString *)someThing
{
    dispatch_queue_t queue = dispatch_queue_create("ddd", NULL);
    __block NSString *localSomeString;
    dispatch_sync(_syncQueue, ^{
        localSomeString = _someThing;
        NSLog(@"localSomeString:%@",_someThing);
    });
    return localSomeString;
}


-(void)setSomeThing:(NSString *)someThing
{
    dispatch_barrier_async(_syncQueue, ^{
        _someThing = someThing;
        NSLog(@"写入:%@",someThing);
        NSLog(@"----%@",[NSThread currentThread]);
    });
}
#pragma mark - **************** 单例
+(id)shareInstance
{
    static Rectangle *shareInstance = nil;
    @synchronized(self)
    {
        if (!shareInstance) { //这里将创建单例的代码包裹在同步块中。
            //线程安全是大家争论的主要问题。 保证线程安全。
            shareInstance = [[self alloc]init];
        }
    }
    return shareInstance;
}

+(instancetype)shareInstanceOnce
{
    //把该变量定义在static作用域中,可以保证编译器在每次执行shareInstace方法时都会复用这个变量,而不会创建新变量。
    static Rectangle *shareInstanceOnce = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstanceOnce = [[self alloc]init];
    });
    return shareInstanceOnce;
}

#pragma mark - **************** 循环遍历
-(void)testFor
{
    //遍历数组 第一种方法:
    //for循环
    NSArray *array = @[@(1),@(2),@(3),@(4)];
    for (int i=0; i<array.count; i++) {
        id obj = array[i];
        //doSomeThing
    }
    
    NSDictionary *dic = @{@"one":@"oneValue",@"two":@"twoValue"};
    NSArray *keys = [dic allKeys];
    for (int i=0; i<keys.count; i++) {
        id key = keys[i];
        id value = dic[key];
        //doSomething;
    }
    
    NSSet *aSet = @{@"setOne":@"one"};
    NSArray *arr = [aSet allObjects];
    for (int i=0; i<arr.count; i++) {
        id object = arr[i];
        //doSomething;
    }
    
    //字典与set都是无序的。所以无法根据特定的整数下标来直接访问其值。于是就需要先获取字典里的所有键或是set里的所有对象。
    //NSEnumerator是个抽象基类 其中只定义了两个方法 供其具体子类来实现。
    //-(NSArray *)allObjects
    //-(id)nextObject 它返回没枚举里的下个对象每次调用该方法时,其内部数据结构都会更新。使得下次调用方法时能返回下个对象。等到枚举中的全部对象都已返回的时候之后,再调用就将返回nil.这表示达到枚举末端了。
    NSEnumerator *enumerator = [array objectEnumerator];
    id object;
    while ((object = [enumerator nextObject]) != nil) {
        //do SomeThing;
    }
    
    NSEnumerator *dicEnum = [dic keyEnumerator];
    id key;
    while ((key = [enumerator nextObject] )!= nil) {
        //do something.z
    }
    
    //反序遍历
    for (id obj in [array reverseObjectEnumerator]) {
        NSLog(@"%@",obj);
    }
    //反向遍历
   [ array enumerateObjectsWithOptions:(NSEnumerationReverse) usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
    }];
    
}


@end
