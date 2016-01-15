//
//  NSUserDefaults+CCF.m
//  CCF
//
//  Created by WDY on 16/1/13.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "NSUserDefaults+CCF.h"

@implementation NSUserDefaults(CCF)

-(void)loadCookie{
    NSData *cookiesdata = [self objectForKey:kCCFCookie];
    
    
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
}


-(void)saveCookie{
    NSArray<NSHTTPCookie *> *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCCFCookie];
}

-(void)saveFavFormIds:(NSArray *)ids{
    [self setObject:ids forKey:kCCFFavFormIds];
}

-(NSArray *)favFormIds{
    return [self objectForKey:kCCFFavFormIds];
}

@end