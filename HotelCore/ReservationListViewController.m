//
//  ReservationListViewController.m
//  HotelCore
//
//  Created by Pho Diep on 2/11/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "ReservationListViewController.h"
#import "ReservationCell.h"
#import "Reservation.h"
#import "Room.h"
#import "Hotel.h"
#import "Guest.h"
#import "HotelService.h"

#pragma mark - Interface
@interface ReservationListViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *sortedReservations;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *context;

@end

#pragma mark - Implementation
@implementation ReservationListViewController

#pragma mark - UIViewController Lifecycle
- (void)loadView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = [[UIScreen mainScreen]bounds];
    
    self.view = self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Current Reservations";
    self.context = [[[HotelService sharedService] coreDataStack] managedObjectContext];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:ReservationCell.class forCellReuseIdentifier:@"RESERVATION_CELL"];

    NSSortDescriptor *hotelDescriptor = [[NSSortDescriptor alloc] initWithKey:@"room.hotel.name" ascending:YES];
    NSSortDescriptor *roomDescriptor = [[NSSortDescriptor alloc] initWithKey:@"room.number" ascending:YES];
    NSSortDescriptor *startDateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
    
    NSArray *descriptors = @[hotelDescriptor, roomDescriptor, startDateDescriptor];
    self.sortedReservations = [self.reservations sortedArrayUsingDescriptors:descriptors];

    
    //---FetchedResultsController
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Reservation"];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"", self.selectedRoom];
//    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:true];
//    fetchRequest.predicate = predicate;
//    fetchRequest.sortDescriptors = @[sortDescriptor];
//    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
//    self.fetchedResultsController.delegate = self;
//    NSError *fetchError;
//    [self.fetchedResultsController performFetch:&fetchError];
//    if (fetchError) {
//        NSLog(@"%@", fetchError);
//    }
    
}

-(NSString*)dateAsString:(NSDate*)date {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MMM-dd-yy"];
    return [dateFormatter stringFromDate:date];
}

#pragma mark - NSFetchedResultsControllerDelegate
-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}

-(void)configureCell:(ReservationCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    Reservation *reservation = [self.fetchedResultsController objectAtIndexPath:indexPath];

    NSString *startDate = [self dateAsString:reservation.startDate];
    NSString *endDate = [self dateAsString:reservation.endDate];
    
    cell.hotelLabel.text = reservation.room.hotel.name;
    cell.roomLabel.text = [[NSString alloc] initWithFormat:@"Room# %@", reservation.room.number];
    cell.dateLabel.text = [[NSString alloc] initWithFormat:@"%@ ... %@", startDate, endDate];
    cell.guestLabel.text = [[NSString alloc] initWithFormat:@"%@, %@", reservation.guest.lastname, reservation.guest.firstname];
    
}

#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Reservation *reservation = self.sortedReservations[indexPath.row];
    NSString *startDate = [self dateAsString:reservation.startDate];
    NSString *endDate = [self dateAsString:reservation.endDate];
    
    ReservationCell *cell = (ReservationCell*)[self.tableView dequeueReusableCellWithIdentifier:@"RESERVATION_CELL" forIndexPath:indexPath];

    cell.hotelLabel.text = reservation.room.hotel.name;
    cell.roomLabel.text = [[NSString alloc] initWithFormat:@"Room# %@", reservation.room.number];
    cell.dateLabel.text = [[NSString alloc] initWithFormat:@"%@ ... %@", startDate, endDate];
    cell.guestLabel.text = [[NSString alloc] initWithFormat:@"%@, %@", reservation.guest.lastname, reservation.guest.firstname];
    
//    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.sortedReservations count] > 0) {
        return [self.sortedReservations count];
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

#pragma mark - UITableViewDelegate

@end
