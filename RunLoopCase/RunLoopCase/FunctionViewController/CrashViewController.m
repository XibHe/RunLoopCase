//
//  CrashViewController.m
//  RunLoopCase
//
//  Created by Peng he on 2018/4/7.
//  Copyright © 2018年 Peng he. All rights reserved.
//

#import "CrashViewController.h"

@interface CrashViewController ()

@end

typedef struct Test
{
    int a;
    int b;
}Test;

@implementation CrashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self subViews];

}

- (void)subViews
{
    UIButton *crashSignalBRTButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x - 120 / 2, self.view.center.y - 100 / 2, 120, 100)];
    crashSignalBRTButton.backgroundColor = [UIColor redColor];
    [crashSignalBRTButton setTitle:@"Signal(ABRT)" forState:UIControlStateNormal];
    [crashSignalBRTButton addTarget:self action:@selector(crashSignalBRTClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:crashSignalBRTButton];
}

- (void)crashSignalBRTClick:(UIButton *)sender
{
    Test *pTest = {1,2};
    free(pTest);//导致SIGABRT的错误，因为内存中根本就没有这个空间，哪来的free，就在栈中的对象而已
    pTest->a = 5;
    
    

}

@end
