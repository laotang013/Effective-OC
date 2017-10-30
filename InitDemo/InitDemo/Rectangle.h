//
//  Rectangle.h
//  InitDemo
//
//  Created by Start on 2017/10/25.
//  Copyright © 2017年 het. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Rectangle;
@protocol RectangleDelegate <NSObject> //委托协议名 通常是在相关的类名后面加上delegate一词。
@optional //可选的
-(void)doitForRectangle:(Rectangle *)rectangle nameStr:(NSString *)str;
@required

@end
@interface Rectangle : NSObject<NSCopying>
/**宽度*/
@property(nonatomic,assign,readonly)float  width;
/**高度*/
@property(nonatomic,readonly,assign)float height;
-(instancetype)initWithWidth:(float)width andHeight:(float)height;
-(BOOL)dosomething:(NSError **)error;

//有了协议之后类就可以用一个属性来存放其委托对象了
//注意:这里需要用weak来修饰 而非strong 因为两者之间必须为 非拥有关系 不然会导致循环引用

@property(nonatomic,weak)id<RectangleDelegate> delegate;

@end
