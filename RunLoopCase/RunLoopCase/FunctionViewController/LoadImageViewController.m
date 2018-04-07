//
//  LoadImageViewController.m
//  RunLoopTest
//
//  Created by Peng he on 2018/4/6.
//  Copyright © 2018年 Peng he. All rights reserved.
//

#import "LoadImageViewController.h"

typedef void(^runloopBlock)(void);  //
static NSString *cellIndentify = @"cellId";
static CGFloat cellHeight = 135.f;

@interface LoadImageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *exampleTableView;
@property (nonatomic, strong) NSMutableArray *tasks;
@end

@implementation LoadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tasks = [NSMutableArray array];
    [self loadSubViews];
    [self addRunloopObserver];
    
    // 为了确保循环每次调用(将timer扔到了Runloop中)
    [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
}

- (void)timerMethod
{
    NSLog(@"不做任何操作!");
}

// 加载tableView
- (void)loadSubViews
{
    self.view = [UIView new];
    self.exampleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    [self.exampleTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIndentify];
    self.exampleTableView.delegate = self;
    self.exampleTableView.dataSource = self;
    [self.view addSubview:self.exampleTableView];
}

+ (void)remove:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    for (NSInteger i = 1; i <= 5; i++) {
        [[cell.contentView viewWithTag:i] removeFromSuperview];
    }
}

// label
+ (void)label:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 300, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor redColor];
    label.text = [NSString stringWithFormat:@"%zd - Drawing index is top priority", indexPath.row];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.tag = 5;
    [cell.contentView addSubview:label];
}

// 加载第一张图片
+ (void)addImage1With:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(105, 20, 85, 85)];
    imageView.tag = 1;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"space" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    [UIView transitionWithView:cell.contentView duration:0.3 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [cell.contentView addSubview:imageView];
    } completion:^(BOOL finished) {
    }];
}

// 加载第二张图片
+ (void)addImage2With:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 20, 85, 85)];
    imageView.tag = 2;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"space" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    [UIView transitionWithView:cell.contentView duration:0.3 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [cell.contentView addSubview:imageView];
    } completion:^(BOOL finished) {
    }];
}

// 加载第三张图片
+ (void)addImage3With:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 99, 300, 35)];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:0 green:100.f/255.f blue:0 alpha:1];
    label.text = [NSString stringWithFormat:@"%zd - Drawing large image is low priority. Should be distributed into different run loop passes.", indexPath.row];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.tag = 4;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 20, 85, 85)];
    imageView.tag = 3;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"space" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    [UIView transitionWithView:cell.contentView duration:0.3 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:imageView];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    // 干掉contentView上的子控件
//    for (NSInteger i = 1; i <= 5; i++) {
//        [[cell.contentView viewWithTag:i] removeFromSuperview];
//    }
    
    // 添加图片
//    [LoadImageViewController addImage1With:cell indexPath:indexPath];
//    [LoadImageViewController addImage2With:cell indexPath:indexPath];
//    [LoadImageViewController addImage3With:cell indexPath:indexPath];
    
    [LoadImageViewController remove:cell indexPath:indexPath];
    [LoadImageViewController label:cell indexPath:indexPath];
    
    [self addTask:^{
        [LoadImageViewController addImage1With:cell indexPath:indexPath];
    }];
    
    [self addTask:^{
        [LoadImageViewController addImage2With:cell indexPath:indexPath];
    }];
    
    [self addTask:^{
        [LoadImageViewController addImage3With:cell indexPath:indexPath];
    }];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

#pragma mark - 关于Runlopp的方法
- (void)addTask:(runloopBlock)task
{
    [self.tasks addObject:task];
    if (self.tasks.count > 18) {
        [self.tasks removeObjectAtIndex:0];
    }
}

- (void)addRunloopObserver
{
    // 1. 得到runloop
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    // 2. 获取上下文
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)self,
        &CFRetain,
        &CFRelease,
        NULL
    };
    
    // 3. 创建观察者
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &callback, &context);
    // 4. 添加观察者
    CFRunLoopAddObserver(runloop, observer, kCFRunLoopCommonModes);
    // 5. 释放
    CFRelease(observer);
}


#pragma mark - 在回调里面加载图片（Runloop循环一次加载一次）
void callback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    
    NSLog(@"%@",info);
    LoadImageViewController *vc = (__bridge LoadImageViewController *)info;
    if (vc.tasks.count == 0) {
        return;
    }
    
    runloopBlock taskBlock = vc.tasks.firstObject;
    taskBlock();
    [vc.tasks removeObjectAtIndex:0];
}

@end
