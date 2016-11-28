//
//  ViewController.m
//  自定义上下拉刷新
//
//  Created by VID on 16/11/28.
//  Copyright © 2016年 VID. All rights reserved.
//

#import "ViewController.h"
#import "XDRefresh.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 头部*/
@property(nonatomic,strong)XDRefreshHeader *header;
/** 脚步*/
@property(nonatomic,strong)XDRefreshFooter *footer;
/** 数据源*/
@property (nonatomic,assign) int dataCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"ZSPRefreshDemo";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _dataCount = 0;
    
    UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64) style:UITableViewStylePlain];
    
    [self.view addSubview:tableView];
    
    tableView.dataSource=self;
    tableView.delegate = self;
    
    _header =  [XDRefreshHeader headerOfScrollView:tableView refreshingBlock:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"hello");
                [_footer resetNoMoreData];
                _dataCount = 20;
                [tableView reloadData];
                [_header endRefreshing];
            });
        });
    }];
    
    [_header beginRefreshing];
    
    _footer = [XDRefreshFooter footerOfScrollView:tableView refreshingBlock:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"hello2");
                _dataCount += 10;
                
                if (_dataCount >= 40) {
                    [_footer endRefreshingWithNoMoreDataWithTitle:@"无数据了"];
                }else {
                    [tableView reloadData];
                    [_footer endRefreshing];
                }
            });
        });
    }];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text=[NSString stringWithFormat:@"第  %@  行数据",@(indexPath.row).description];
    return cell;
}


@end
