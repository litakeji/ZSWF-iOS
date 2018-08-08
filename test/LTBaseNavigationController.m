//
//  LTBaseNavigationController.m
//  test
//
//  Created by letar on 2018/7/17.
//  Copyright © 2018年 letar. All rights reserved.
//

#import "LTBaseNavigationController.h"
#import "UIColor+YMHex.h"
@interface LTBaseNavigationController ()

@end

@implementation LTBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.barTintColor = [UIColor colorWithHexString:@"#fcb200"];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        
        // 设置返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setTitle:@"   " forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"navLeft"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"navLeft"] forState:UIControlStateHighlighted];
//        [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        [backButton sizeToFit];
        
        // 注意:一定要在按钮内容有尺寸的时候,设置才有效果
//        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
        
        // 设置返回按钮
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}


@end
