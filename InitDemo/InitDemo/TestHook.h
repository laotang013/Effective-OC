//
//  TestHook.h
//  InitDemo
//
//  Created by Start on 2017/11/3.
//  Copyright © 2017年 het. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TestHook : NSObject
-(void)sendEventHooked:(UIEvent *)event;
@end
