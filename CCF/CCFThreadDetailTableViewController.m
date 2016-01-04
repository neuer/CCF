//
//  CCFThreadDetailTableViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/1/1.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFThreadDetailTableViewController.h"
#import "CCFThreadDetailCell.h"
#import "CCFBrowser.h"
#import "CCFUrlBuilder.h"
#import "CCFParser.h"

@interface CCFThreadDetailTableViewController ()

@end

@implementation CCFThreadDetailTableViewController

@synthesize entry;
@synthesize posts = _posts;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"CCFThreadDetailTableViewController viewDidLoad    %@   %@", entry.urlId, entry.page);
    
    CCFBrowser * browser = [[CCFBrowser alloc]init];
    [browser browseWithUrl:[CCFUrlBuilder buildThreadURL:entry.urlId withPage:entry.page]:^(NSString* result) {
        
        CCFParser *parser = [[CCFParser alloc]init];
        
        NSMutableArray<CCFPost *> * parsedPosts = [parser parsePostFromThreadHtml:result];
        
        if (self.posts == nil) {
            self.posts = [NSMutableArray array];
        }
        
        [self.posts addObjectsFromArray:parsedPosts];
        
        for (CCFPost * post in self.posts) {
            NSLog(@"=========>>>>>    %@", post.postContent);
        }
        [self.tableView reloadData];
        
    }];

    
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *QuoteCellIdentifier = @"CCFThreadDetailCellIdentifier";
    
    CCFThreadDetailCell *cell = (CCFThreadDetailCell*)[tableView dequeueReusableCellWithIdentifier:QuoteCellIdentifier];
    
    //CCFThreadDetailCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CCFThreadDetailCellIdentifier" owner:self options:nil] lastObject];
    
    
    CCFPost *post = self.posts[indexPath.row];
    
//    [cell.content loadHTMLString:post.postContent baseURL:[CCFUrlBuilder buildIndexURL]];
    [cell setPost:post];
    
    return cell;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [tableView fd_heightForCellWithIdentifier:@"CCFThreadDetailCellIdentifier" configuration:^(id cell) {
//        // Configure this cell with data, same as what you've done in "-tableView:cellForRowAtIndexPath:"
//        // Like:
//        //    cell.entity = self.feedEntities[indexPath.row];
//        [cell setPost:self.posts[indexPath.row]];
//    }];
//}


- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
