//
//  ISGViewController.m
//  ISGCycleScrollView
//
//  Created by isaaclzg on 02/02/2021.
//  Copyright (c) 2021 isaaclzg. All rights reserved.
//

#import "ISGViewController.h"
#import <ISGCycleScrollView.h>
#import "ISGCustomeViewController.h"

@interface ISGViewController ()

@end

@implementation ISGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    ISGCycleScrollView *banner = [[ISGCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    [self.view addSubview:banner];
    banner.imageViewContentMode = UIViewContentModeScaleAspectFill;
    banner.imageURLStringsGroup = @[@"https://t7.baidu.com/it/u=1621548477,242232046&fm=193&f=GIF",@"https://t7.baidu.com/it/u=1962848802,1705699489&fm=193&f=GIF",@"https://t7.baidu.com/it/u=3863249326,4619162&fm=193&f=GIF"];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:nextBtn];
    [nextBtn setTitle:@"下一页自定义" forState:UIControlStateNormal];
    nextBtn.frame = CGRectMake(0, 400, 200, 60);
    [nextBtn setTitleColor:UIColor.orangeColor forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [nextBtn addTarget:self action:@selector(didNext:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didNext:(id)sender {
    ISGCustomeViewController *customeVC = [[ISGCustomeViewController alloc] init];
    [self presentViewController:customeVC animated:YES completion:nil];
}
@end
