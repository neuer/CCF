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

#import "MJRefresh.h"
#import "WCPullRefreshControl.h"
#import "CCFUITextView.h"

@interface CCFThreadDetailTableViewController ()<CCFThreadDetailCellDelegate, UITextViewDelegate, CCFUITextViewDelegate>{
    
    NSMutableDictionary<NSIndexPath *, NSNumber *> *cellHeightDictionary;
    int currentPage;
    int totalPage;
    
    CCFBrowser * browser;
    UIToolbar * inputToolbar;
    CCFUITextView * field;
}


@property (strong,nonatomic)WCPullRefreshControl * pullRefresh;

@end

@implementation CCFThreadDetailTableViewController

@synthesize entry;
@synthesize posts = _posts;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.inputText.delegate = self;
    
    
    
    field = [[CCFUITextView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    field.heightDelegate = self;
    
    UIColor * borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    field.layer.borderColor = borderColor.CGColor;
    field.layer.borderWidth = 0.5;
    field.layer.cornerRadius = 5.0;
    field.delegate = self;

    inputToolbar = [[[NSBundle mainBundle] loadNibNamed:@"QuickReply" owner:self options:nil]firstObject];
    
    
    browser = [[CCFBrowser alloc]init];
    
    cellHeightDictionary = [NSMutableDictionary<NSIndexPath *, NSNumber *> dictionary];
    
    
    NSLog(@"CCFThreadDetailTableViewController viewDidLoad    %@   %@", entry.urlId, entry.page);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        int page = currentPage +1;
        [self browserThreadPosts:page];
        
    }];

//    self.pullRefresh = [[WCPullRefreshControl alloc] initWithScrollview:self.tableView Action:^{
//        [self browserThreadPosts:1];
//    }];
//    
//    [self.pullRefresh startPullRefresh];
    
    [self browserThreadPosts:1];
    
    
    
    
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    NSArray<UIBarButtonItem*> * items  = inputToolbar.items;
    
    for (UIBarButtonItem * item in items) {
        if (item.customView != nil) {
            item.customView = field;
        }
        
        UIEdgeInsets insets = item.imageInsets;
        insets.bottom = - CGRectGetHeight(inputToolbar.frame) + 44;
        item.imageInsets = insets;
        
        
    }
    self.inputText.inputAccessoryView = inputToolbar;
//    self.inputText.inputView = self.floatTextView;

    
    return YES;
}

-(void)heightChanged:(CGFloat)height{
    
    CGRect rect = inputToolbar.frame;
    CGFloat addHeight = height - rect.size.height;
    
    rect.size.height = height + 14;
    rect.origin.y = rect.origin.y - addHeight - 14;
    
    inputToolbar.frame = rect;
    
    NSArray<UIBarButtonItem*> * items  = inputToolbar.items;
    for (UIBarButtonItem * item in items) {
        UIEdgeInsets insets = item.imageInsets;
        insets.bottom = - CGRectGetHeight(inputToolbar.frame) + 44;
        item.imageInsets = insets;
    }
    
}

-(void) browserThreadPosts:(int)page{
    if (totalPage == 0 || currentPage < totalPage) {
    
        NSString * pageStr = [NSString stringWithFormat:@"%d", page];
        
        [browser browseWithUrl:[CCFUrlBuilder buildThreadURL:entry.urlId withPage:pageStr]:^(NSString* result) {
            
            CCFParser *parser = [[CCFParser alloc]init];
            
            NSMutableArray<CCFPost *> * parsedPosts = [parser parsePostFromThreadHtml:result];
            
            if (self.posts == nil) {
                self.posts = [NSMutableArray array];
            }
            
            [self.posts addObjectsFromArray:parsedPosts];
            
            currentPage = page;
            
            if (currentPage < totalPage) {
                [self.tableView.mj_footer endRefreshing];
            } else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                
            }
            
            [self.tableView reloadData];
            
        }];
    }
    
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
    cell.delegate = self;
    
    //CCFThreadDetailCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CCFThreadDetailCellIdentifier" owner:self options:nil] lastObject];
    
    
    CCFPost *post = self.posts[indexPath.row];
    
//    [cell.content loadHTMLString:post.postContent baseURL:[CCFUrlBuilder buildIndexURL]];
//    [cell setPost:post];
    [cell setPost:post with:indexPath];
    
    return cell;
}


-(void)relayoutContentHeigt:(NSIndexPath *)indexPath with:(CGFloat)height{
    if ([cellHeightDictionary objectForKey:indexPath] == nil) {
        CGFloat fixHeight = height < 44.f? 44.f : height + 10.f;
        
        [cellHeightDictionary setObject:[NSNumber numberWithFloat:fixHeight] forKey:indexPath];
        
    }
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber * nsheight = [cellHeightDictionary objectForKey:indexPath];
    if (nsheight == nil) {
        return  44;
    }
    return nsheight.floatValue;
}


- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)floatReplyClick:(id)sender {
    [browser reply:entry.urlId :field.text];
}
@end
