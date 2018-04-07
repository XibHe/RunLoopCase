//
//  LoadImageViewController.h
//  RunLoopTest
//
//  Created by Peng he on 2018/4/6.
//  Copyright © 2018年 Peng he. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadImageViewController : UIViewController

+ (void)label:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
+ (void)addImage1With:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
+ (void)addImage2With:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
+ (void)addImage3With:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

@end
