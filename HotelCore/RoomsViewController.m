//
//  RoomsViewController.m
//  HotelCore
//
//  Created by Pho Diep on 2/9/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "RoomsViewController.h"
#import "RoomCell.h"
#import "Room.h"
#import "ReservationViewController.h"

#pragma mark - Interface
@interface RoomsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *rooms;

@end

#pragma mark - Implementation
@implementation RoomsViewController

- (void)loadView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = [[UIScreen mainScreen]bounds];
    
    self.view = self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Rooms";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:RoomCell.class forCellReuseIdentifier:@"ROOM_CELL"];
    
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:valueDescriptor];
    self.rooms = [[[self.selectedHotel rooms] allObjects]sortedArrayUsingDescriptors:descriptors];
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.rooms == nil) {
        return 0;
    }
    return [self.rooms count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RoomCell *cell = (RoomCell*)[self.tableView dequeueReusableCellWithIdentifier:@"ROOM_CELL" forIndexPath:indexPath];

    Room *room = self.rooms[indexPath.row];

    cell.nameLabel.text = [[room number] stringValue];
    cell.bedsLabel.text = [[room beds] stringValue];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", [self.rooms[indexPath.row] number]);
 
    ReservationViewController *reservationVC = [ReservationViewController new];
    reservationVC.selectedRoom = self.rooms[indexPath.row];
    [self.navigationController pushViewController:reservationVC animated:true];
    
}

@end