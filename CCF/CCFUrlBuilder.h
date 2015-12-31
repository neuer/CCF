//
//  CCFUrlBuilder.h
//  CCF
//
//  Created by 迪远 王 on 15/12/30.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CCFUrlBuilder : NSObject

+ (NSURL *) buildMemberURL:(NSString*)userId;

+ (NSURL *) buildFormURL:(NSString *)formId;

+ (NSURL *) buildThreadURL: (NSString *) threadId withPage:(NSString *) page;

+ (NSURL *) buildIndexURL;

+ (NSURL *) buildLoginURL;

+ (NSURL *) buildVCodeURL;

@end