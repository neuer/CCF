//
//  CommonUtils.h
//  iOSMaps
//
//  Created by 迪远 王 on 15/12/12.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constances.h"

@interface CommonUtils : NSObject

+(UIImage *)createImageWithColor:(UIColor *)color;

+(NSInteger) readUserData:(NSString *)key;

+(void) writeUserData:(NSString *)key withValue:(NSInteger) value;


@end
