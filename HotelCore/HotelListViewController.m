//
//  HotelListViewController.m
//  HotelCore
//
//  Created by Pho Diep on 2/9/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "HotelListViewController.h"
#import "AppDelegate.h"
#import "HotelCell.h"
#import "Hotel.h"
#import "Room.h"
#import "RoomsViewController.h"

#pragma mark - Interface
@interface HotelListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView* tableView;
@property (weak, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) UIBarButtonItem *addHotelButton;

@end

#pragma mark - Implementation
@implementation HotelListViewController

#pragma mark - UIViewController Lifecycle
- (void)loadView {
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.frame = [[UIScreen mainScreen] bounds];
    
    self.view = self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Hotels";

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:HotelCell.class forCellReuseIdentifier:@"HOTEL_CELL"];
    
    self.addHotelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewHotel:)];
    self.navigationItem.rightBarButtonItem = self.addHotelButton;

    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.context =  appDelegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Hotel"];
    NSError *fetchError;
    
    NSArray *results = [self.context executeFetchRequest:fetchRequest error:&fetchError];
    if (fetchError == nil) {
        self.hotels = results;
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.hotels == nil) {
        return 0;
    }
    return [self.hotels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotelCell *cell = (HotelCell*)[self.tableView dequeueReusableCellWithIdentifier:@"HOTEL_CELL" forIndexPath:indexPath];
    cell.nameLabel.text = [(Hotel*)self.hotels[indexPath.row] name];
    cell.locationLabel.text = [(Hotel*)self.hotels[indexPath.row] location];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RoomsViewController *roomVC = [RoomsViewController new];
    roomVC.selectedHotel = self.hotels[indexPath.row];
    [self.navigationController pushViewController:roomVC animated:true];
}

#pragma mark - Button Actions
- (void)addNewHotel:(UIBarButtonItem*)sender {
    NSLog(@"new hotel");
    
}

@end
