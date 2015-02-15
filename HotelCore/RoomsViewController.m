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
#import "ReservationListViewController.h"
#import "Reservation.h"
#import "HotelService.h"

#pragma mark - Interface
@interface RoomsViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *rooms;
@property (strong, nonatomic) UIBarButtonItem *addRoomButton;
@property (strong, nonatomic) UIAlertView *roomAlert;
@property (strong, nonatomic) HotelService *hotelService;
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

    self.hotelService = [HotelService sharedService];
    self.title = [NSString stringWithFormat:@"%@", self.selectedHotel.name];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:RoomCell.class forCellReuseIdentifier:@"ROOM_CELL"];
    
    self.addRoomButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewRoom:)];
    self.navigationItem.rightBarButtonItem = self.addRoomButton;
    
    [self loadListOfRooms];
}

- (void)loadListOfRooms {
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:valueDescriptor];
    self.rooms = [[[self.selectedHotel rooms] allObjects] sortedArrayUsingDescriptors:descriptors];
    [self.tableView reloadData];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    Room *selectedRoom = self.rooms[indexPath.row];
    ReservationListViewController *reservationsVC = [ReservationListViewController new];
    reservationsVC.selectedRoom = selectedRoom;
//    reservationsVC.reservations = [selectedRoom.reservations allObjects];
    [self.navigationController pushViewController:reservationsVC animated:true];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Room *selectedRoom = self.rooms[indexPath.row];
        [self.hotelService removeRoom:selectedRoom];
        [self loadListOfRooms];
    }
}


#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *number = [[alertView textFieldAtIndex:0] text];
    NSString *beds = [[alertView textFieldAtIndex:1] text];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;

    NSNumber *numberInt = [formatter numberFromString:number];
    NSNumber *bedsInt = [formatter numberFromString:beds];
    
    if (buttonIndex == 1) { //pressed continue
        if (numberInt == nil || bedsInt == nil) {
            [self alertUserOfMissingInfoForNewRoom:number beds:beds];
        } else {
            [self.hotelService addNewRoom:numberInt atHotel:self.selectedHotel withNumberOfBeds:bedsInt rate:nil];
            [self loadListOfRooms];
        }
    }
}

#pragma mark - Button Actions
-(void)addNewRoom:(UIBarButtonItem*)sender {
    [self setupRoomAlert:nil withNumberOfBeds:nil];
    [self.roomAlert show];
    
}

-(void)setupRoomAlert:(NSString*)number withNumberOfBeds:(NSString*)beds {
    self.roomAlert = [[UIAlertView alloc] initWithTitle:@"New Room" message:@"Room number and beds are required and must be numbers" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add New Room", nil];
    self.roomAlert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    UITextField *numberField = [self.roomAlert textFieldAtIndex:0];
    numberField.placeholder = @"Enter room number";
    UITextField *bedsField = [self.roomAlert textFieldAtIndex:1];
    bedsField.placeholder = @"Enter number of beds";
    [[self.roomAlert textFieldAtIndex:1] setSecureTextEntry:NO];
}

-(void)alertUserOfMissingInfoForNewRoom:(NSString*)number beds:(NSString*)beds {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Unable to Add Room" message:@"Both number and beds of new room are required and must be numbers" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okOption = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self setupRoomAlert:number withNumberOfBeds:beds];
        
        [[self.roomAlert textFieldAtIndex:0] setText:number];
        [[self.roomAlert textFieldAtIndex:1] setText:beds];
        
        [self.roomAlert show];
    }];
    [alertController addAction:okOption];
    [self presentViewController:alertController animated:true completion:nil];
    
}

@end
