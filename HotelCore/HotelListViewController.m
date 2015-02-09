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

#pragma mark - Interface
@interface HotelListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView* tableView;

@end

#pragma mark - Implementation
@implementation HotelListViewController

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
    

    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context =  appDelegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Hotel"];
    NSError *fetchError;
    
    NSArray *results = [context executeFetchRequest:fetchRequest error:&fetchError];
    if (fetchError == nil) {
        self.hotels = results;
        [self.tableView reloadData];
    }
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.hotels == nil) {
        return 0;
    }
    return [self.hotels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotelCell *cell = (HotelCell*)[self.tableView dequeueReusableCellWithIdentifier:@"HOTEL_CELL" forIndexPath:indexPath];
    Hotel *hotel = self.hotels[indexPath.row];

    cell.nameLabel.text = hotel.name;
    
    return cell;
}




@end
