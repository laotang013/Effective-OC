##Effective Object-C笔记
Objective-C 消息结构
* 与函数调用的区别是：
* 消息结构的语言，其运行时所执行的代码由运行环境来决定(动态绑定)。而使用函数调用的语言，则由编译器来决定。(虚函数表来查出到底要执行的方法)

-
NSString *someThing  = @“你好”;
someThing变量 其类型是NSString* 变量是指向NSString的指针。
对象所占内存总是分配在“堆空间 head space”而绝不会分配在栈上stack上。不能再栈中分配object-c对象。
分配在堆中的内存必须直接管理，而分配在栈上用于保存变量的内存则会在其栈帧弹出时自动清理。

****
**2. 前向引用 将引入头文件的时机尽量延后，只在需要的时候才引入。减少编译时间**

* @class xx;
* 在.m中需要引入"xx.h";因为如果需要使用后者则需要知道其所有接口的细节。
* 要点:除非的确有必要。否则不要引入头文件。一般来说,应在某个类的头文件中使用前向声明，并在实现文件中引入那些类的头文件。尽量降低耦合。

**3.多使用字面量语法。少使用 new [alloc init]**

* 使用字面量创建数组时若数组元素对象中有nil，则会抛出异常。向数组中插入nil。通常说明程序有错。
* [NSArray arrayWithobjects:objec1,object2,object3,nil] 如果object2为nil。则只会保存到一个对象。arrayWithobjects方法会依次处理各个参数，知道发现nil为止。
* 字典中的对象和键必须都是Objective-C对象。
* 使用字面量语法创建出来的字符串、数组、字典对象都是不可变的若想要变成可变版本对象则需要复制一份。(深复制)
* NSMutableArray *mutable = [@[@1,@2,@3]mutalbeCopy];

**4 .多用类型常量，少用#define预处理命令**

* 若不打算公开某个常量,则应将其定义在使用该常量的实现文件里。
* #import "xx.h"
* static const NSTimeInterval kAnimationDuration = 5
* 变量一定要同时用static与const来声明，如果试图修改由const修饰符所声明的变量，编译器则会报错。
* 而static修饰符则意味着该变量仅在定义此变量的编译单元中可见。如果不加static则编译器为它创建一个外部符号 external 此时如果另一个编译单元也声明了同名变量,那么编译器就会抛出一条错误消息。
* extern关键字告诉编译器无需查看其定义，即允许使用代码使用此常量，

** 6枚举**

6.1 -其中一种情况 定义选项的时候可以彼此组合。
```
enum UIViewAutoresizing
{
UIViewAutoresizingNone  = 0,
UIViewAutoresizingFlexibleLeftMargin = 1 << 0,
UIViewAutoresizingFlexibleLeftWidth  = 1 << 1,
...
}
```

6.2 - Foundation框架中定义了一些辅助的宏，用这些宏来定义枚举类型时也可以指定用于保存枚举值的底层数据类型，这些宏具备向后兼容能力。
typedef NS_ENUM(NSUInteger,EOCConnectState)
{
EOCConnectStateDisConnected,
EOCConnectStateConnecting,
EOCConnectStateConnected,
}

提示: 凡是需要以按位或操作来组合的枚举都应使用NS_OPTIONS定义，若是枚举不需要互相组合。则应使用NS_ENUM来定义。
枚举在switch中的用法:

若是用枚举来定义状态机，则最好不要有default分支。这样的话如果稍后又加了一种状态，那么编译器就会发出警告信息。提示新加的状态并为之switch分支中处理，假如写上了default分支，那么它就会处理这个新状态。


**6.对象消息运行期**

6.1用Object-C等面向对象语言编程时,对象(object)就是基本构造单元，开发者可以通过对象来存储并传递数据在对象之间传递数据并执行任务的过程就叫做消息传递(Messaging)。当应用程序运行起来以后，为其提供相关支持的代码叫做‘Object-C运行期环境’它提供了一些使得对象之间能够传递消息的重要函数，并且包含创建类实例所用的全部逻辑。
6.2 属性是object-c的一项特性用于封装对象中的数据，Object-C对象通常会把所需要的数据保存为各种实例变量。实例变量一般由存取和读写方法。经由属性成为了2.0的一部分。
6.3在对象接口的定义中,可以使用属性这是一种标准写法，能够访问封装在对象里的数据。 属性：编译器会自动写出一套存取方法，用以访问给定类型中具有给定名称的变量。
6.4使用@dynamic关键字 告诉编译器不要自动创建实现属性所用的实例变量。不要为其创建存取方法。
6.5使用@synthesize语法来指定实例变量的名字(加入你想自定义一个)
6.6 nonatomic不使用同步锁。
6.7 属性用于封装数据，而数据则要有具体所有权语义。
6.8 属性特质：
6.8.1 strong 此特质表明该属性定义了一种拥有关系，为这种属性设置新值时，设置方法会先保留新值，并释放旧值，然后在将新值设置上去。
6.8.2 weak 非拥有关系 为这种属性设置新值时，设置方法既不保留新值也不释放旧值，然而在属性所指对象遭到摧毁时，属性值会情况。
6.8.3 copy 不保留新值而是将其拷贝。当属性为NSString*时,经常用此特质来保护其封装性,因为传递给设置方法的新值有可能指向了一个NSMutableString类的实例，这个类是NSString的子类。表示一种可以修改的值。此时若不是拷贝字符串，那么设置完属性之后，字符串的值就可能会在对象不知情的情况下遭人更改。
6.8.4 automic特质获取的方法会通过锁定机制来确保其操作的原子性。这也就是说如果两个线程读写同一个属性那么无论何时总能看到有效的属性值。若是不加锁(或者使用nonatomic语义)那么有可能会把未修好的值读取出来。
6.8.5 开发iOS程序时，应该使用nonatomic属性,因为atomic属性会严重影响性能。

7.**在对象内部尽量直接访问实例变量**

7.1 读取实例变量的时候采用直接访问的形式,而在设置实例变量的时候通过属性来做。
7.2 直接访问实例变量时，不会调用其设置方法这就绕过了相关属性定义的内存管理定义。如copy 则不会拷贝该属性。
7.3 直接访问实例变量则不会触发KVO。
7.4 写入实例变量时,通过其设置方法来做。而在读取实例变量时则直接访问。
7.5 *注意*：在初始化方法中应该直接访问实例变量。因为子类可能会重写设置方法（override）
7.6 懒加载 必须通过获取方法来获取属性。否则实例变量就永远不会初始化了。

8.**对象等同性**

8.1 等同性equality来比较对象是一个非常有用的功能。按照 == 操作符比较的是两个指针本身而不是其所指的对象。而应该使用NSObject协议中声明的isEqual来判断两个对象的等同性。
8.2 NSString类实现了一个自己独有的等同性判断方法 名叫做isEqualToString 传递给该方法的对象必须是NSString。否则结果为undefined.调用该方法比用isEqual方法快。
8.3 NSObject协议中其他的连个判断等同性的关键方法：
* -(BOOL)isEqual:(id)object;
* -(NSUInteger)hash;
* 这两个方法的默认实现是当且仅当其指针值完全相同时，这两个对象才相等。
* 要点:相同的对象必须要有相同的哈希码，但是两个哈希码相同的对象却未必相同。
9.**类族模式，隐藏实现细节**

10.**在既有类中使用关联对象存放自定义数据**

<!--关联对象-->
10.1 可以给某对象关联许多其他对象,这些对象通过键来区分。存储对象值的时候，可以指明存储策略。用以维护相应的内存管理语义。
10.2 我们可以把某对象想象成NSDidctionary,把关联到该对象的值理解为字典中的条目。于是存储关联对象的值就相当于在NSDictionary对象上调用[object setObject:valueForKey:key] [object objectForKey:key];方法。 设置关联对象值时,通常使用静态全局变量做键。
10.3 下列方法可以管理管理对象
<!--此方法以给定的键和策略为某对象设置关联对象值-->
void objc_setAssociatedObject(id object,void *key, id value, objc_AssociationPolicy policy);
<!--此方法根据给定的键从某对象中获取相应的关联对象值-->
id objc_getAssociatedObject(id objct,void*key);
<!--此方法移除指定对象的全部关联对象-->
void objc_removeAssoiatedObjects(id object);
通过"关联对象"机制来吧两个对象连起来。
定义关联对象时可指定内存管理语义，用以模仿定义属性时所采用的拥有关系与非拥有关系。只有在其他做法不可行时才应选用关联对象。
11.**objc_msgSend的作用**

11.1 消息有名称（name）或 “选择子selector” 可以接受参数 而且可能还有返回值。
11.2 动态绑定 调用的函数直到运行期才能确定。 在object-c中如果向某对象传递消息，那么会使用动态绑定机制来决定需要调用的方法。在底层所有的方法都是普通的C语言函数，然而对象收到消息之后，究竟该调用哪个方法则完全取决于运行期决定。
11.3 id returnValue = [someObject messageName:parameter];
someObject叫做接受者(receiver) messageName叫做选择子selecotr.选择子与参数合起来称为消息（message）
void objc_msgSend(id self, SEL cmd,...);
第一个参数代表接收者,第二个参数代表选择子SEL是选择子类型。后续参数就是消息中的那些参数。
id returnValue = objc_msgSend(someObject,@selector(messageName:),parameter);
objc_msgSend函数会依据接受者与选择子的类型来调用适当的方法。为了完成此操作该方法需要在接收者所属的类中搜寻其方法列表（list of methods）。如果能找到与选择子名称相符的方法就跳转至其实现代码。若是找不到，那就沿着继承体系继续向上查找等找到合适的方法再跳转。如果最终还找不到相符的方法那就执行消息转发。
* objc_msgSend会将匹配结果缓存在快速映射表（fast map）里面 每个类都有这样一块缓存。若是稍后还像该类发送与选择子相同的消息。那么执行就很快了


12 **消息转发机制**

若想令类能理解某条信息，我们必须以程序码实现对应的方法才行。但是在编译期向类发送了其无法解读的消息并不会报错。因为在运行期可以继续向类中添加方法。所以编译器在编译时还无法确知类中到底会不会实现某个方法。
在消息转发过程中设置挂钩。用以执行预定的逻辑而不应用程序崩溃。

消息转发分为两大阶段: 第一阶段 先征询接收者 所属的类，看其是否能动态添加方法以处理当前这个未知的选择子。- 这叫做动态方法解析 第二阶段 涉及完成的消息转发机制。
如果运行期系统已经把第一阶段执行完了。那么接收者自己就无法再以动态新增方法的手段来响应包含该选择子的消息。此时运行期系统会请求接受者以其他手段来处理与消息相关的方法调用。细分为两小步:首先请接收者看看有没有其他的对象能处理这条信息。若有则运行期系统会把消息转发给那个对象。于是转发消息过程结束。若没有 备援的接收者则启动完整的消息转发机制。运行期系统会把与消息有关的全部细节都疯转到NSInvocation对象中。再给接收者最后一次机会。令其设法解决当前还未处理的这条消息。
首先调用其所属类的下列类方法。
+（BOOL）resolveInstanceMethod:(SEL)selecotr
如果尚未实现的方法不是实例方法而是类方法那么运行期系统就会调用另外一个方法 resolveClassMethod 类方法。
使用这种方法的前提是相关的实现代码已经写好。只等着运行的时候动态插入在类里面就可以了。

要点:
1.若对象无法响应某个选择子，则进入消息转发流程
2.通过运行期的动态方法解析功能，我们可以在需要用到某个方法时在将其加入类中。
3.对象可以把其无法解读的某些选择子类转交给其他对象来处理。
4.如果上面两步仍然无法处理。则就启动完整的消息转发机制。
13.**用方法调配技术 调试黑盒方法**

13.1 method swizzling 方法调配
类的方法列表会把选择子的名称映射到相关的方法实现上。使得动态消息派发系统能够据此找到应该调用的方法。这些方法均以函数指针的形式表示。这种指针叫做IMP.

IMP 原型  id( *IMP)(id,SEL,...)

OC运行期系统提供的几个方法都能够用来操作这张表。
开发者可以向其新增选择子。改变某选择子所对应的方法实现。 还可以交换两个选择子所映射到的指针。
要点:
1.在运行期，可以向类中新增或替换选择子所对应的方法实现。
2.使用另一份实现来替换原有的方法实现。

14 **类对象**

14.1 消息的接收者为何为？
对象类型并非在编译期就绑定好了。而是要在运行期查找，而且还有个特殊的类型叫做id 它能指代任意的Object-C对象类型。一般情况下应该指明消息接收者的具体类型。
2.每个Object-C对象实例都是指向某块内存数据的指针所以在声明变量时，类型后面要跟一个 * 字符。
若是想把对象所需的内存分配在栈上，编译器则会报错。
id与NSString *来定义相比 其语法意义相同。唯一的区别在于如果声明了指定的具体类型。那么在该实例上调用所没有的方法时，编译器会探知此情况并发出警告。

typdef strcut objc_object
{
Class isa;
}*id;


由此看见每个对象结构体的首个成员是Class类的变量，该变量定义了对象所属的类。通常称为 isa 指针
每个类仅有一个类对象 每个类对象仅有一个与之相关的元类。
super_class 指针确立了继承关系而isa指针描述了实例所属的类。通过这样布局关系图即可执行 类型信息查询 我们可以查出对象是否能响应某个选择子，是否遵从某项协议并能看出此对象位于类继承体系的哪一部分。

在类继承体系中查询类型信息：
可以用类型信息查询方法来检视类继承体系
1. isMemberOfClass 能够判断出对象是否为某个特定类的实例。
2. isKindOfClass 判断对象是否为某类或其派生类的实例。
3. 像这样的类型信息查询方法使用的isa指针获取对象所属的类，然后通过super_class指针在继承体系中游走。
4. 类对象是单例 每个类的class仅有一个实例。

16 **提供全能初始化方法**

为对象提供必要信息以便其能完成工作的初始化方法叫做全能初始化方法
全能初始化方法调用链一定要维系。
如果子类的全能初始化方法和超类的方法的名称不同，那么总应覆写超类的全能初始化方法。
每个子类的全能初始化方法都应该调用其超类的对应方法，并逐层向上实现

17**实现description方法**

* 重写 description方法把待打印的信息放到字典里面然后将字典对象的description方法所输出的内容包含在字符串里并返回。
18 **尽量使用不可变对象**
其实设置了readOnly的代码利用KVC一样可以修改。。
19 **命名方式**
命名方式应该协调一致。如果要从其他框架中继承子类。那么务必遵循其命名惯例，比方说要从UIView类中继承自定义的子类，那么类名末尾的词必须是View同理若要创建自定义的委托协议则其名称中应该包含委托发起方的名称，后面跟上Delegate一次。

20 **为私有方法名加前缀**

为私有方法添加前缀。这样更容易明白哪些方法是可以很容易的修改。p_private
私有方法一般只在实现的时候声明。

21**理解Object-C错误模型**

@throw [NSException exceptionWithName:
NSInternalInconsistencyExceptionreason:
reason userInfo:nil];

2. 如果初初始化方法无法根据传入的参数来初始化当前实例。那么可以令其返回nil/0；
3. NSError 可以把导致错误的原因回报给调用者。
4. Error domain(错误范围,其类型为字符串)
错误发生的范围也就是产生错误的根源，通常用一个特有的全局变量来定义。
5. Error code(错误码，其类型为整数)
5.1 独有的错误代码,用以指明某个范围内具体发生了何种错误。错误码通常用enum来定义。
6. User info(用户信息，其类型为字典)
6.1 有关此错误的额外信息，其中或许包含一段本地化的描述。。
7. NSError另一种常见用法就是 输出参数 返回给调用者。
7.1 (NSError**)error 传递给方法的参数是个指针,而该指针本身又指向另外一个指针。那个

22 **理解NSCopying协议**

1.拷贝对象使用copy方法来完成，如果想令自己的类支持拷贝操作，那就要实现NSCopying协议。
方法为: -(id)copyWithZone:(NSZone*)zone;
若想某个类支持copy功能，只需声明该类遵守NSCopying协议 覆写copy方法真正需要实现的是copyWithZone方法。

2.mutableCopy此方法来自一个叫做NSMutableCopying的协议。该协议与NSCopying类似，也是只定义了一个方法然后方法名不同。
-(id)mutableCopyWithZone:(NSZone *)zone
无论当前实例是否可变,若需获取其可变版本的拷贝均应调用mutableCopy方法同理若需要不可变的拷贝，则总应通过copy方法来获取。
[NSMutableArray copy] -- NSArray
[NSArray mutableCopy] -- NSMutableArray

3.在可变的对象上调用copy方法会返回一个不可变的类的实例。
深拷贝:在拷贝对象自身时,将其底层数据也一并复制过去，Foundataion框架中所有的collection类在默认情况下都执行浅拷贝。也就是说只拷贝容器对象本身,而不复制其中数据。这样做的原因:容器内对象未必都能拷贝，而且调用者也未必想在拷贝容器时一并拷贝其中的每个对象。
因为没有专门定义深拷贝的协议，所以其具体执行的方式由每个类来决定。你只需要决定自己所写的类是否要提供深拷贝方法即可。另外不要嘉定遵从NSCopying协议对象都会进行深拷贝。在绝大多数情况下执行的都是浅拷贝。如果需要执行深拷贝，那么除非该类的文档说他是用深拷贝来实现NSCopying协议的。否则要么寻找能够执行深拷贝的相关方法要么自己编写方法来做。

23  **通过委托与数据源协议进行对象间通信**

Object-C不支持多重继承,因而我们要把某个类应该实现的一系列方法定义在协议里面，协议最为常见的用途是实现委托模式。
对象之间经常需要需要相互通信。而通信的方式有很多种。
委托模式:
主旨：定义一套接口，某对象若想接受另一个对象的委托，则需要遵从此接口,以便成为其委托对象(delegate)。而这另一个对象 则可以给其委托对象回传一些信息。也可以在发生相关事件时通知委托对象。

24 **将类的实现代码分散到便于管理的数个分类之中**

1.通过Object-C的分类机制，把类代码按逻辑划入几个分区中。这对开发与调试都有好处。
2.可以把类代码分成多个易于管理的小块,以便单独检视。使用分类机制之后，如果想用分类中的方法，那么要记得引入.h时一并引入分类的头文件。
3.使用分类机制将其切割成几块，把相应代码归入不同的功能区。

25 **总为第三方类的分类方法加前缀**

1. 分类机制通常是向无源码的既有类中新增功能。分类中的方法是直接添加在类里面的，他们就好比这个类中的固有方法。
将分类方法加入类中这一操作是在运行期系统加载分类时完成的。运行期系统会把分类中所实现的每个方法都加入类的方法列表中,
如果类中本来就有此方法而分类又实现了一次,那么分类中的方法就会覆盖原来的那一份代码。实际上可能会发生多次覆盖。
比如某个分类中的方法覆盖了主实现的相关方法。而另外一个分类中的方法又覆盖了这个分类中的方法。多次覆盖的结果以最后一个分类为准。
要点:  1.向第三方类中添加分类时，总应给其名称加上你专用的前缀。
2.向第三类中添加分类时，总应给其中的方法名加上你专用的前缀。

26 **勿在分类中声明属性**

要点: 1.把封装数据所用的全部属性都定义在主接口里。
2.在分类之后的其他分类中可以定义存取方法但尽量不要定义属性。
27 **使用 分类 隐藏实现细节**

1.通过内联分类 向类中新增实例变量。
2.如果某属性在主接口声明为只读,而类的内部又要设置方法修改此属性那么就在内联分类中将其扩展为可读写。
3.把私有方法的原型声明在内联分类里面。。记住带前缀。
4.若想使类所遵循的协议不为人所知，则可与内联分类中声明。

28 **通过协议提供匿名对象**

NSDictionary 字典中 键的标准内存管理语义是:设置时拷贝,而值的语义则是 设置时保留。
-(void)setObject:(id)object forKey:(id<NSCopying>)key
表示键的那个参数其类型为id(NSCopying) 作为参数值的对象 它可以是任何类型。只要遵从NSCopying协议就好。这样的话就能向该对象发送拷贝消息了。
这个key参数可以视为匿名对象。与delegate属性一样，字典也不关心key对象所属的具体类,而且它也觉不应该依赖于此。字典对象只要能确定它可以给此实例发送拷贝消息就行。
要点：
1.协议可在某种程度上提供匿名类型。具体的对象类型可以淡化成遵从某协议的id类型。协议里规定了对象所应实现的方法。
2.使用匿名对象来隐藏类型名称(或类名)
3.如果具体类型不重要，重要的是对象能够响应(定义在协议里的)特定方法那么使用匿名对象来表示。

29 . **理解引用计数**

1.每个对象都有个可以递增或递减的计数器。如果想使用某个对象继续存活。那就递增其引用计数，用完了之后就递减其引用计数。计数变为0就表示没有人关注此对象。于是就把他销毁了。
2.在引用计数的架构下。对象有个计数器。用以表示当前有多少个事物想令此对象继续存活下去。在Object-C 叫做保留计数。不过也可以叫做引用计数。NSObject协议声明了下面三个方法用于操作计数器。以递增或递减其值。
2.1 Retain 递增保留计数
2.2 release 递减保留计数
2.3 autorelease 待稍后清理"自动释放池"
3.相互关联的对象就构成了一张对象图，对象如果继续指向其他对象的强引用，那么前者就拥有后者。也就说说如果对象想令其所引用的那些对象继续存活就可将其保留。等用完了之后在释放。
4.如果按引用树回溯，那么最终会发现一个根对象 root object 在Mac OS X 应用程序中此对象就是NSApplication对象；而在iOS应用程序中则是UIApplication对象两者都是启动时创建的单例。
5.一般调用完之后都会清空指针，这样能保证不会出现可能指向无效对象的指针。这种指针通常称为悬挂指针。

** 属性存取方法中的内存管理**

若属性为Strong关系 设置的属性值会保留。如：
-(void)setFoo:(id)foo
{
[foo retain];
[_foo release];
_foo = foo;
}

点评: 先保留新值在释放旧值，然后更新实例变量令其指向新值。 顺序很重要。假如还未保留新值就先把旧值给释放了。那么两个值又指向了同一个对象，那么 先执行的release操作就可能导致系统将此对象永久回收。而后续的retain操作则无法令彻底回收的对象复生，于是实例变量就成了悬挂指针。

**自动释放池**

在Object-C的引用计数架构中，自动释放池是一个重要特性。调用release会立刻递减对象的保留计数(而且还有可能令系统回收此对象)然后有时候可以不调用它。改为调用autorelease,此方法会在稍后递减计数。通常是在下一次 事件循环(event loop)时递减。不过也可能执行的更早些。
由此可见autorelease能延长对象生命周期，使其在跨越方法调用边界后依然可以存活一段时间。

**相互引用：**
1.采用weak
2.从外界命令循环的某个对象不在保留另外一个对象。从而避免内存泄漏。

要点:
1. 引用计算机制通过可以递增递减计数器来管理内存。对象创建好之后。其保留计数至少为1.若保留计数为正则对象继续存活，当保留计数为0时对象销毁。

30 以ARC简化引用计数

1.内存泄漏: 没有正确释放已经不再使用的内存。
* alloc
* new
* copy
* mutableCopy
* 若方法名以下列词语开头,则其返回的对象归调用者所有。
* 归调用者所有的意思是：调用上述四种方法的那段代码要负责释放方法所返回的对象。若方法不是由上述四个词语开头，则其表示所返回的对象并不归调用者所有。

变量的内存管理语义:

ARC也会处理局部变量与实例变量的内存管理。默认情况下，每个变量都是指向其对象的强引用
ARC set方法： 先保留新值 在释放旧值。最后设置实例变量。
__strong 默认语义,保留此值。
__weak 不保留此值,但是变量可以安全使用,因为如果系统把这个对象回收了，那么变量也会自动清空。
__autoreleasing:把对象按引用传递给方法时，使用这个特殊的修饰符，此值会在方法返回时自动释放。
经常会给局部变量加上修饰符,用以打破由“块 block”所引入的保留环。
**块会自动保留其所捕获的全部对象而如果这其中有某个对象又保留了块本身，那么就可能导致保留环。可以用__weak局部变量来打破这种保留环。**
ARC如何清理实例变量

ARC也负责对实例变量进行内存管理，要管理其内存,ARC就必须在回收分配给对象的内存时生成必要的清理代码。凡是具备强引用的变量都必须释放。
如果有非Object-C的对象，比如CoreFoundation中的对象或是由malloc()分配在堆中的内存,那么仍然需要亲清理。然后不需要像原来那样调用超类的dealloc方法。
-(void)dealloc
{
free(xxx);
}
ARC只负责管理OC对象内存，尤其要注意CoreFoundataion对象不归ARC管理，开发者必须适时调用CFRetain/CFRelease.


31. **在deallc方法中只释放引用并解除监听**

1. 对象在经历其生命周期后，最终会为系统所回收,这时就要执行dealloc方法了。在每个对象的生命周期内。此方法仅执行一次。
2. 在编写dealloc 方法时需要注意 不要在里面随便调用其他的方法，原因：如果在这里调用的方法又要执行异步执行某些任务，或是又要继续调用他们自己的某些方法，那么等到那些任务执行完毕时，系统已经在当前那个待回收的对象彻底摧毁了。这会导致很多问题，且经常导致应用程序崩溃。因为那些应用程序执行完毕后，要回调此对象，告诉此对象任务已经完成了。而此时对象后已摧毁。那么回调操作就会出错。
要点：
1.在dealloc方法里，应该做的事情就是释放指向其他对象的引用，并取消原来订阅的键值观测KVO 或NSNotificationCenter等通知，不要做其他事情。
2.如果对象持有文件描述符等系统资源,那么应该专门编写一个方法来释放此种资源，这样的类和其使用者约定：用完资源后必须调用close方法。
3.执行异步任务的方法不应该在dealloc里调用，只能在正常状态下执行的那些方法也应该在dealloc里调用。因为此时对象已经处在正在回收的状态了。

32 **编写异常安全代码时留意内存管理问题**

1. -fobjc-arc-exceptions 这个编译器标志用来开启此功能，其默认不开启的原因是在Objective-C代码中，只有当应用程序必须因异常状态而终止时才应抛出异常，因此如果应用程序即将终止，那么是否还会发生内存泄漏就已经无关紧要了。
2.在捕获异常时，一定要注意将try块内所创建的对象清理干净。
3.在模型情况下，ARC不生成安全处理异常所需的清理代码。开启编译器标志后，可生成这种代码，不过会导致应用程序变大。而且降低运行效率。

33 以弱引用避免保留环(循环引用)

unsafe_unretained一词表明，属性值可能不安全，而且不归此实例所拥有，如果系统已经把属性所指的那个对象回收了，那么在其上调用方法可能会使应用程序崩溃。由于本对象并不保留属性对象。因此其有可能为系统回收。
weak 系统回收对象之后会置为nil.
要点：1.将某些引用设为weak。可避免出现保留环(循环引用)
2.weak 引用可以自动清空，也可以不自动清空。自动清空是随着ARC而引入的新特性。由运行期系统来实现。

34 **以自动释放池块 降低内存峰值**

1. 将自动释放池嵌套的好处是，可以借此控制应用程序的内存峰值，使其不至过高。
2. 自动释放池要等线程下一次事件循环时才会清空。

NSArray *databaseRecords = xx;
NSMutableArray *people = [NSMutableArray array];
for(NSDictionary *record  in databaseRecords)
{
@autoreleasepool
{
EocPerson *person = [[ EocPerson alloc]initWithRecord:record];
[people addobject:person];
}
}
要点:
1.自动释放池排布在栈中，对象收到autorelease消息后，系统将其放入最顶端的池里。
2.合理运用自动释放池，可降低应用程序的内存峰值。
3.@autoreleasepool 这种新式写法能创建出更为轻便的自动释放池。
35.**用僵尸对象调试内存管理问题**

1. 向已回收的对象发送消息是不安全的,这么做又是可以，有时不行。
2. 原因:取决于对象所占内存有没有为其他内容所覆写。
3. 解决:通过启动僵尸对象这个调试功能。 运行期系统会把所有已经回收的实例转化为特殊的僵尸对象。而不会真正的回收它们。这种现象所在的核心内存无法重用。因此不可能遭到覆写。僵尸对象收到消息后，会抛出异常，其中准确的说明了发送过来的消息。并描述了回收之前那个对象。僵尸对象是调试内存管理问题的最佳方式。
4. 打开方法：Xcode-->编辑应用程序Scheme 在对话框中选择Run 然后切换至Diagnostics分页 最后勾选 Enable Zombie Objects选项。
5. 来源：僵尸类是从名为_NSZombie_的模板类里复制出来。
6. 系统为何要给每个变为僵尸的类都创建一个对应的新类呢？这是因为给僵尸对象发消息后，系统可由此知道该对象原来所属的类。假如把所有的僵尸对象都归到_NSZombie_类里，那么原来的类名就丢了。
7. 要点: 系统在回收对象时，可以不将其真的回收。而是把它转化为僵尸对象，通过环境变量NSZombieEnabled可开启此功能。
8. 系统会修改对象的isa指针，令其指向特殊的僵尸类。而从该对象变为僵尸对象，僵尸类能够相应所有的选择子。相应方式为:打印一条包含消息内容及其接受者的消息，然后终止应用程序。

36  **不要使用retainCount**

1.每个对象都有一个计数器表明还有多少个其他对象令此对象继续存活。
2.NSObject协议中定义了下列方法：用于查询对象当前的保留计数。
-(NSUInteger)retainCount;
3.这个方法不应该调用原因：保留计数的绝对值一般都与开发者所应留意的事情完全无关。它返回的保留计数只是某个给定时间点上的值。该方法并未考虑到系统会稍后把自动释放池清空。因此不会将后续的释放操作从返回值里减去。这样的话，此值就未必能真实反应实际的保留计数了。
要点: 对象的保留计数看似有用，实则不然，因为任何给定时间点的 绝对保留计数都无法反映对象生命期的全貌。
引入ARC之后，retainCount方法就正式废止了。在ARC调用该方法会导致编译器报错。

**块与大中枢派发(Grand Central Dispatch)**

1.块：是一种可在C/C++/OC代码中使用的词法闭包。开发者可将代码像对象一样传递，令其在不同的环境下运行。还有个关键的地方是。定义块的范围内，他可以访问其中的全部变量。
2.GCD:是一种与块有关的技术，它提供了对线程的抽象，而这种抽象则基于派发队列(dispatch queue)。开发者可将块排入队列中，由GCD负责处理所有调度事宜。

37 **理解块这一概念**

1.块与函数类似，只不过是直接定义在另一个函数里的。和它定义的那个函数共享同一个范围内的东西。块用 ^ 符号表示,后面跟着一对花括号,括号里面是块的实现代码。
^{
//Block;
}
2. 块其实就是一个值,而且自有相关类型。与int float或Object-C对象一样。也可以把块赋给变量。然后像其他变量那样使用它。块函数的语法与函数指针近似。
void(^someBlock) = ^{
//Block;
};

格式: return_type (^block_name)(parameters)

3.块强大之处在于:在声明他的范围里,所有变量都可以为其捕获，这就是说那个范围里的全部变量，在块里依然可用。
默认情况 为块所捕获的变量，是不可以在块里面修改的。加上__block修饰符，这样就可以在块内修改了。
4.如果块所捕获的变量是对象类型，那么就会自动保留它，系统在释放那个块的时候也会将其一并释放。块本身可视为对象,实际上在其他Object-C对象所能响应选择子中，有很多是块也能响应的。而最重要的是块本身也和其他对象一样，有引用计数。当最后一个指向块的引用移走之后，块就被回收了。回收时也会释放块所捕获的变量。
self 也是对象 因而块在捕获的它时也会将其保留。如果self所指代的那个对象同时也保留了块，那么这种情况通常就会导致“保留环"
块的内部结构
每个Object-C对象都占据着某个内存区域。因为实例变量的个数及对象所包含的关联数据互不相同。所以每个对象所占用的内存区域也有大有小。
块本身也是对象,在存放块对象的内存区域里，首个变量是指向Class对象的指针，该指针叫做isa.其余内存里含有块对象正常运转所需的各种信息。
在块对象中最重要的是invoke变量。这是个函数指针。指向块的实现的代码。函数原型至少接受一个void*型的参数。
定义块的时候其所占的内存区域是分配在栈中的。
为了解决此问题 可以给块对象发送copy消息以拷贝之。这样的话把块从栈复制到堆了。
38 **为常用的块类型创建typedef**

1.每个块都具备其固有类型，因而可将其赋给适当类型的变量，这个类型由块所接受的参数及其返回值组成。
2.在定义块变量时 要把变量名放在类型之中，而不要放在右侧，
3.为了隐藏复杂的块类型，需要用到C语言中名为类型定义 typedef 的特性。typedef关键字用于给类型起个易读的别名。
4.声明变量时 要把名称放在类型中间 并在前面加上^符号。而定义新类型时也得这么做。
typedef int (^someBlock)(BOOL flag,int value);

39 **用handler块降低代码分散程度**

要点:
1.在创建对象时，可以使用内联的handler块将相关业务逻辑一并声明。
2.在有多个实例需要监控时，如果采用委托模式，那么经常需要根据传入的对象来切换，若改用handler块来实现，则可直接将块与相关对象放在一起。
3.设计API时如果用到了handler块，那么可以增加一个参数，使调用者可通过此参数来绝对应该把块安排在哪个队列上执行。

40 **用块引用其所属对象时不会要出现保留环(循环引用)**

要点： 如果块所捕获的对象直接或间接的保留了块本身,那么就得当心保留环问题。
一定要找个适当的时机解除保留环而不能把责任推给API的调用者。
41 **多用派发队列，少用同步锁**

1.  @synchronized(self)
2.  NSLock *lockMethod = [[NSLock alloc] init];
[lockMethod lock];
//Safe
[lockMethod unlock];
3.串行同步队列

同步函数：   并发队列：不会开线程
串行队列:不会开线程

异步函数：   并发队列:能开启N条线程
串行队列:开启1条线程

栅栏块： void dispatch_barrier_async(dispatch_queue_t queue,dispatch_block_t block);
void   dispatch_barrier_sync(dispatch_queue_t queue,dispatch_block_t block);
在队列中，栅栏块必须单独执行。不能与其他块并行。这只对并发队列有意义，因为串行队列的块总是按顺序逐个执行。并发队列如果发现接下来要处理的块是栅栏块。那么就一直等当所有并发队列执行完毕之后才会单独执行这个栅栏块。

42 **多用GCD 少用performSelector系列方法**

1. performSelector:(SEL)selector
该方法的签名如下,它接受一个参数就是要执行那个选择子。
2.容易导致内存泄漏。 返回值只能是void或对象类型。 id类型。其他类型需要转换。
3.要点：
performSelector系统方法在内存方法里面容易有疏失。他无法确定将要执行的选择子具体什么。因而ARC编译器也就无法插入适当的内存管理方法。
43 **掌握GCD及操作队列的使用时机**

1.把操作以NSOperationQueue子类的形式放在队列中。而这些操作也能够并发执行。
2.GCD是纯C的API,而操作队列则是Object-C的对象。在GCD中任务用块来表示，而块是一个轻量级数据结构。与之相反，操作则是一个更为重量级的Object-C对象。
3.使用NSOperation及NSOperationQueue的
44 **通过Dispatch Group机制,根据系统资源状况来执行任务**

1. dispatch group 是一GCD的一项特性。能够把任务分组。调用者可以等待这组任务执行完毕,也可以在提供回调函数之后继续向下执行。这组任务完成时，调用者会得到通知。
2. 用途: 将并发执行的多个任务合为一个组，于是调用者就可以知道这些任务合何时才能全部执行完毕。
3. void dispatch_group_enter(dispatch_group_t group);
4. void dispatch_group_leave(dispatch_group_t group);
5.前者能够使分组里正要执行的任务数递增,而后者则使之递减。由此可见调用了  dispatch_group_enter以后必须要与之对应的dispatch_group_leave才行。这与引用计数相似。
在使用dispatch group时,如果调用了enter之后,没有相应的leave操作，那么这一组任务就永远执行不完。
6. 下面这个函数可用于等待 dispatch group执行完毕。
7. dispatch_group_wait(dispatch_group_t group dispatch_time_t timeout);
8. 此函数要接受两个参数，一个是要等待的group。另一个代表等待时间的timeout值。timeout参数表示函数在等待dispatch group执行完毕之时,应该阻塞多久。
9. 为了执行队列中的块，GCD会在适当的时机自动创建新线程和复用旧线程。如果使用并发队列
45 **使用dispatch_once来执行只需执行一次的线程安全代码**

1.void dispatch_once(dispatch_once_t *token,dispatch_block_t block);
此函数接受类型为dispatch_once_t的特殊参数，笔者称其为 标记token,此外还接受块参数。对于给定的标记来说,该函数保证相关的块必定会执行，且执行一次。
2.注意: 对于只需执行一次的块来说,每次调用函数时传入的标记都必须完全相同。因此通常将标记量声明为static或global作用域里。
3.由于每次执行调用都必须使用完全相同的标记，所以要标记声明为static.把该变量声明为static作用域中，可以保证编译器在每次执行shareInstace方法时都复用这个变量，而不会去重新创建新变量。
要点: 经常需要编写 只需要执行一次的线程安全代码 通过GCD所提供的dispatch_once函数,很容易就能实现此功能。
标记应该声明为static或global作用域中。这样的话，在把只需要执行一次的块传给dispatch_once函数时，传进去的标记也是相同的。

46 **不要使用dispatch_get_current_queue**

1.dispatch_queue_t dispatch_get_current_queue();
文档中,此函数返回当前正在执行代码的队列。试图以此来避免同步派发时可能遭遇的死锁问题。
队列之间会形成一套层级体系。这意味着排在某条队列中的块，会在其上级队列里执行。层级里地位最高的那个队列叫做全局并发队列
47 **熟悉系统框架**
1.将一系列代码封装为动态库,并在其中放入描述其接口的头文件，这样做出来的东西就叫做框架。
2.Foundation框架中的类使用NS这个前缀。
3.无缝桥接:可以将C语言数据结构平滑转换为Foundataion中的Object-C对象。也可以反向转换。
框架: Foundataion --> CoreFoundation
CFNetwork 提供了C语言级别的网络通信能力，它将BSD套接字抽象成易与使用的网络接口。
CoreAudio 该框架所提供的C语言API可用来操作设备上的音频硬件。
AVFoundation 此框架所提供的OC对象可用来录制音频和视频。
CoreData:可将对象存入数据库便于持久保存。
CoreText:此框架提供C语言接口可以高效执行文字排版及渲染操作。
UIKit：他们都提供了构建在Foundation和CoreFoundtion之上的Object-C类。
CoreAnimation与CoreGraphics框架
CoreAnimation是Object-C语言写成的。它提供了一些工具，而UI框架则用这些工具来渲染图形并播放动画。CoreAnimation本省并不是框架它是QuartzCore框架的一部分。
CoreAnimation框架以C语言写成的。其中提供了2D渲染所具备的数据结构与函数。

48 **多用块枚举,少用for循环**

1. for循环
2. NSEnumerator对象
3. for in
4. 反序遍历
for(id obj in [array reverseObjectEnumerator])
{

}
5. 基于块的遍历方式
6. 每次迭代都要执行由block参数所传入的块这个块有三个参数,分别是当前迭代所针对的对象 所针对的下标以及指向布尔值的指针。遍历时既能获取对象,也能知道其下标。此方法还提供了一中优雅的的机制来终止遍历操作。开发者可以通过设定stop变量值来实现。另外一个好处是可以修改块的方法签名，以免进行类型转换操作，从效果上讲相当于本来需要执行的类型转换操作块方法签名来做。

49 **对自定义其内存管理语义的collection使用无缝桥接**

50 **构建缓存时选用NSCache而非NSDictionary**

51 **精简initialize与load的实现代码**

1.初始化操作 NSObject 有两个方法 load 和 initialize
+(void)load();
对于加入运行期系统的每个类class及分类,必定会调用此方法。 且只调用一次。
如果分类和其所属的类都定义了load方法,则先调用类里面的,在调用分类里的。
load方法的问题在于,执行该方法时，运行期系统处于脆弱状态。在执行子类的load方法之前,必定会先执行超类的load方法。
在load方法里使用其他类是不安全的。因为如果关联的程序库的load方法必定会先执行。然后根据给定的程序库无法判断出各个类的载入顺序。
load 方法并不像其他普通的方法那样,它并不遵从那套继承规则。如果某各类本身并没有实现load方法,那么不管其各级超类是否实现此方法。系统都不会调用。

+(void)initialize

该方法会在程序首次用该类之前调用,且只调用一次。它是由运行期系统来调用的。绝不应该通过代码来直接调用。
1. 它是惰性调用的。也就是说只有程序用到了相关类的时候才会调用。因此如果某个类一直没有使用。那么其initialize方法就不会一直运行。 应用程序不需要先把每个类的initialize都执行一遍。这与load方法不同。对于load来说应用程序必须阻塞并等着所有类的load都执行完,才能继续。
2.该方法在。运行期系统在执行该方法时是处于正常状态的。此时可以安全的使用并调用任意类中的方法。而且运行期系统也能确保initialize方法一定会在线程安全的环境中执行。
3.initialize方法与其他消息一样。如果某个类为实现它，而其超类实现了。那么就会运行剿劣的实现代码。
4. initialize方法只应该用来设置内部数据。不应该在其中调用其他方法。即便是本类自己的方法也最好别调用。因为稍后可能嗨哟啊给那些方法添加更多功能。
5. 某些初始化工作可以放在initialize里 然而可变数组不行。因为他是Object-C对象。所创建实例之前必须先激活运行期系统。





52 **NSTimer 会保留其目标对象**

1.NSTiemr 计时器要和运行循环(run loop)相关联。运行循环到时候会触发任务。创建NSTimer时,可以将其预先安排在当前运行循环中,也可以先创建好。然后由开发者自己来调度。
2.只有把计时器放在运行循环里,它才能正常触发任务。
3.计时器会保留其目标对象,等到自身失效时再释放此对象。
4.调用invalidate方法可以令计时器失效。执行完相关任务之后,一次性的计时器也会失效。
开发者若将计时器设置为重复执行模式,那么必须自己调用invalidate方法才能令其停止。
5.


