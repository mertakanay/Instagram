//
//  MainPageViewController.m
//  Instagram
//
//  Created by Mert Akanay on 4/6/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "MainPageViewController.h"

@interface MainPageViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

@end
