//
//  ViewController.m
//  XCStarViewExample
//
//  Created by 樊小聪 on 2017/3/14.
//  Copyright © 2017年 樊小聪. All rights reserved.
//


#import "ViewController.h"

#import "XCStarView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    XCStarView *editStar = [XCStarView starViewWithFrame:CGRectMake(30, 300, 300, 30) configure:NULL];
    editStar.starStateDidChangeHandle = ^(NSInteger starCount){
        
        NSLog(@"点亮星星的个数：  %zi", starCount);
    };
    [self.view addSubview:editStar];
    
    XCStarViewConfigure *configure = [XCStarViewConfigure defaultConfigure];
    configure.canEdit    = NO;
    configure.starMargin = 0;
    XCStarView *star = [XCStarView starViewWithFrame:CGRectMake(30, 500, 300, 30) configure:configure];
    star.value = 0.75;
    [self.view addSubview:star];
    
}


@end
