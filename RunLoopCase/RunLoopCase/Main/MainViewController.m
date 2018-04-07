//
//  MainViewController.m
//  RunLoopCase
//
//  Created by Peng he on 2018/4/7.
//  Copyright © 2018年 Peng he. All rights reserved.
//

#import "MainViewController.h"
#import "LoadImageViewController.h"
#import "CrashViewController.h"

static NSString *cellIndentify = @"cell";

@interface MainViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *sourceArray;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"RunLoop Case";
    [self loadSubViews];
}

- (void)loadSubViews
{
    _sourceArray = @[@"RunLoop 渲染UI --- 减少滑动卡顿",@"通过 RunLoop 让Crash的App回光返照"];
    UITableView *listTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    listTableView.dataSource = self;
    listTableView.delegate = self;
    [self.view addSubview:listTableView];
    listTableView.rowHeight = 60;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_sourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
    }
    cell.textLabel.text = _sourceArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        LoadImageViewController *loadImageVC = [[LoadImageViewController alloc] init];
        [self.navigationController pushViewController:loadImageVC animated:YES];
    } else if (indexPath.row == 1) {
        CrashViewController *crashVC = [[CrashViewController alloc] init];
        [self.navigationController pushViewController:crashVC animated:YES];
    }
}

@end
