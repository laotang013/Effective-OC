//
//  EOCClass.h
//  InitDemo
//
//  Created by Start on 2017/11/2.
//  Copyright © 2017年 het. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^TimeBlock)();
@interface EOCClass : NSObject
-(void)startPolling;
-(void)stopPolling;


@end
