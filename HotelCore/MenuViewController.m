//
//  MenuViewController.m
//  HotelCore
//
//  Created by Pho Diep on 2/9/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCell.h"
#import "HotelListViewController.h"

#pragma mark - Interface
@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSArray* menu;

@end

#pragma mark - Implementation
@implementation MenuViewController

#pragma mark - UIViewController Lifecycle
- (void)loadView {
    self.tableView = [[UITableView alloc]init];
    self.tableView.frame = [[UIScreen mainScreen] bounds];
    
    self.view = self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Main";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self.tableView registerClass:MenuCell.class forCellReuseIdentifier:@"MENU_CELL"];
    
    self.menu = @[@"Hotels"];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = (MenuCell*)[self.tableView dequeueReusableCellWithIdentifier:@"MENU_CELL"];
    
    cell.nameLabel.text = self.menu[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.menu[indexPath.row] isEqualToString:@"Hotels"]) {
        HotelListViewController *hotelListVC = [HotelListViewController new];
        [self.navigationController pushViewController:hotelListVC animated:true];
    }
}

@end
