//
//  ViewController.m
//  CCF
//
//  Created by WDY on 15/12/28.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <IGHTMLQuery.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    

    [manager GET:@"https://bbs.et8.net/bbs/showthread.php?t=1331214" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        html = [self replaceUnicode:html];
        
        [self parseUserInfo:html];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        NSLog(@"%@", error);
    }];
    
    
}


-(void) parseUserInfo:(NSString*) html{
    NSLog(@"================= start");
    IGHTMLDocument *document = [[IGHTMLDocument alloc]initWithHTMLString:html error:nil];
    IGXMLNodeSet* contents = [document queryWithXPath:@"//*[@id='posts']/div[*]/div/div/div/table/tr[1]"];
    
    for (int i = 0; i < contents.count; i++) {
        IGXMLNode * postNode = contents[i];
        IGXMLNode * userInfoNode = postNode.firstChild;
        IGXMLNode *nameNode = userInfoNode.firstChild.firstChild;
        
        NSString *name = nameNode.innerHtml;
        NSString *nameLink = [nameNode attribute:@"href"];
        NSLog(@"%d ->> %@    %@  \n", i, name , nameLink );
    }
    
    NSLog(@"================= end");
}

- (NSString *)replaceUnicode:(NSString *)unicodeStr{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
