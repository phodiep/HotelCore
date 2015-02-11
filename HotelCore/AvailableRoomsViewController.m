//
//  AvailableRoomsViewController.m
//  HotelCore
//
//  Created by Pho Diep on 2/10/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "AvailableRoomsViewController.h"
#import "Room.h"
#import "RoomCell.h"
#import "ReservationViewController.h"

@interface AvailableRoomsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *sortedRooms;

@end

@implementation AvailableRoomsViewController

- (void)loadView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = [[UIScreen mainScreen]bounds];
    
    self.view = self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Available Rooms";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:RoomCell.class forCellReuseIdentifier:@"ROOM_CELL"];
    
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:valueDescriptor];
    self.sortedRooms = [self.rooms sortedArrayUsingDescriptors:descriptors];
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.sortedRooms == nil) {
        return 0;
    }
    return [self.sortedRooms count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RoomCell *cell = (RoomCell*)[self.tableView dequeueReusableCellWithIdentifier:@"ROOM_CELL" forIndexPath:indexPath];
    
    Room *room = self.sortedRooms[indexPath.row];
    
    cell.nameLabel.text = [[room number] stringValue];
    cell.bedsLabel.text = [[room beds] stringValue];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", [self.sortedRooms[indexPath.row] number]);
    
    ReservationViewController *reservationVC = [ReservationViewController new];
    reservationVC.selectedRoom = self.sortedRooms[indexPath.row];
    reservationVC.dateSet = true;
    reservationVC.setStartDate = self.setStartDate;
    reservationVC.setEndDate = self.setEndDate;
    [self.navigationController pushViewController:reservationVC animated:true];
    
}


@end
