//
//  AvailablityViewController.m
//  HotelCore
//
//  Created by Pho Diep on 2/10/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "AvailablityViewController.h"
#import "AppDelegate.h"
#import "Hotel.h"
#import "Reservation.h"
#import "Room.h"
#import "AvailableRoomsViewController.h"

#pragma mark - Interface
@interface AvailablityViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) UIDatePicker *startDatePicker;
@property (strong, nonatomic) UIDatePicker *endDatePicker;
@property (strong, nonatomic) UISegmentedControl *hotelSegmentControl;
@property (strong, nonatomic) UIButton *searchButton;

@property (strong, nonatomic) NSMutableDictionary *views;

@end

#pragma mark - Implementation
@implementation AvailablityViewController

#pragma mark - UIViewController Lifecycle
- (void)loadView {
    UIView* rootView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    rootView.backgroundColor = [UIColor lightGrayColor];
    self.views = [[NSMutableDictionary alloc] init];

    self.searchButton = [[UIButton alloc] init];
    [self.searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.searchButton setTitle:@"Search" forState:UIControlStateNormal];
    [self.searchButton addTarget:self action:@selector(searchForAvailableRoom:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *startDateLabel = [[UILabel alloc] init];
    startDateLabel.text = @"Start Date";
    
    UILabel *endDateLabel = [[UILabel alloc] init];
    endDateLabel.text = @"End Date";
    
    self.startDatePicker = [[UIDatePicker alloc] init];
    self.startDatePicker.datePickerMode = UIDatePickerModeDate;
    [self.startDatePicker setMinimumDate:[NSDate date]];
    
    self.endDatePicker = [[UIDatePicker alloc] init];
    self.endDatePicker.datePickerMode = UIDatePickerModeDate;
    [self.endDatePicker setMinimumDate:[NSDate date]];

//        self.hotelSegmentControl = [[UISegmentedControl alloc] initWithItems:[self getNamesOfHotels]];
    self.hotelSegmentControl = [[UISegmentedControl alloc] initWithItems:@[@"Fancy Estates", @"Solid Stay", @"Decent Inn", @"Okay Motel"]];

    self.hotelSegmentControl.frame = CGRectMake(0, 0, 300, 50);
    [self.hotelSegmentControl addTarget:self action:@selector(hotelSelected:) forControlEvents:UIControlEventValueChanged];
    
    [self setupForAutolayout:self.searchButton          addToView:rootView  keyForViewsDictionary:@"searchButton"];
    [self setupForAutolayout:startDateLabel             addToView:rootView  keyForViewsDictionary:@"startLabel"];
    [self setupForAutolayout:endDateLabel               addToView:rootView  keyForViewsDictionary:@"endLabel"];
    [self setupForAutolayout:self.startDatePicker       addToView:rootView  keyForViewsDictionary:@"startDate"];
    [self setupForAutolayout:self.endDatePicker         addToView:rootView  keyForViewsDictionary:@"endDate"];
    [self setupForAutolayout:self.hotelSegmentControl   addToView:rootView  keyForViewsDictionary:@"hotelSeg"];

    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                              @"H:|-[hotelSeg]-|" options:0 metrics:nil views:self.views]];

    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                              @"V:|-75-[hotelSeg]-8-[startLabel][startDate]-8-[endLabel]-[endDate]-8-[searchButton]-16-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:self.views]];

    
    
    self.view = rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.context = appDelegate.managedObjectContext;
    
}

#pragma mark - autolayout setup
- (void)setupForAutolayout:(id)object addToView:(UIView *)view keyForViewsDictionary:(id)key {
    [object setTranslatesAutoresizingMaskIntoConstraints:false];
    [view addSubview:object];
    [self.views setObject:object forKey:key];

}

#pragma mark - UISegmentedControl setup
- (NSArray*)getNamesOfHotels {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Hotel"];
    NSError *fetchError;
    NSArray *results = [self.context executeFetchRequest:fetchRequest error:&fetchError];
    
    NSMutableArray *hotelNames;
    if (fetchError == nil) {
        NSArray *hotels = results;
        for (Hotel *hotel in hotels) {
            [hotelNames addObject:[NSString stringWithFormat:@"%@",[hotel name]]];
        }
    }
    return hotelNames;
}

- (void)hotelSelected:(UISegmentedControl *)segment {
//    NSLog(@"%@", [segment titleForSegmentAtIndex:segment.selectedSegmentIndex]);
}

#pragma mark - filter results
- (NSArray*)applyPredicate:(NSPredicate*)predicate toFetchEntity:(NSString*)entityName {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    
    fetchRequest.predicate = predicate;
    NSError *fetchError;
    NSArray *results = [self.context executeFetchRequest:fetchRequest error:&fetchError];
    
    if (fetchError != nil) {
        NSLog(@"Fetch Error... %@", fetchError.localizedDescription);
        return nil;
    }
    return results;
}

#pragma mark - Button Actions
- (void)searchForAvailableRoom:(UIButton*)sender {

    NSDate *startDate = self.startDatePicker.date;
    NSDate *endDate = self.endDatePicker.date;
    
    if ([startDate compare:endDate] > 0) {
        [self alertUserOfBadDateRange];
    } else {
        NSArray *availableRooms = [self filterForRoom];
        
        if (availableRooms != nil) {
            AvailableRoomsViewController *availableVC = [AvailableRoomsViewController new];
            availableVC.rooms = availableRooms;
            availableVC.setStartDate = startDate;
            availableVC.setEndDate = endDate;
            [self.navigationController pushViewController:availableVC animated:true];
        } else {
            [self alertUserOfNoRooms];
        }
    }
}

- (NSArray*)filterForRoom {
    NSString *selectedHotel = [self.hotelSegmentControl titleForSegmentAtIndex:self.hotelSegmentControl.selectedSegmentIndex];
    NSDate *startDate = self.startDatePicker.date;
    NSDate *endDate = self.endDatePicker.date;
    
    //get list of reservations overlapping w/ start/end dates
    NSPredicate *reservationPredicate = [NSPredicate predicateWithFormat:
                                         @"room.hotel.name MATCHES %@ AND ((startDate <= %@ AND endDate >= %@ AND endDate <= %@) OR (startDate >= %@ AND endDate <= endDate) OR (startDate >= %@ AND startDate <= %@ AND endDate >= %@) OR (startDate <= %@ AND endDate >= %@))",
                                         selectedHotel,
                                         startDate, startDate, endDate,
                                         startDate, endDate,
                                         startDate, endDate, endDate,
                                         startDate, endDate];
    NSArray *allOverlappingReservations = [self applyPredicate:reservationPredicate toFetchEntity:@"Reservation"];
    
    NSMutableArray *reservedRooms = [NSMutableArray new];
    for (Reservation *reservation in allOverlappingReservations) {
        [reservedRooms addObject:reservation.room];
    }
    
    NSPredicate *roomPredicate = [NSPredicate predicateWithFormat:@"self.hotel.name MATCHES %@ AND NOT (self IN %@)",selectedHotel, reservedRooms];
    NSArray *availableRooms = [self applyPredicate:roomPredicate toFetchEntity:@"Room"];
    
//    for (Room *room in availableRooms) {
//        NSLog(@"%@", room.number);
//    }
//    
//    NSLog(@"%lu", (unsigned long)[availableRooms count]);
    return availableRooms;
}

- (void)alertUserOfBadDateRange {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Unable to Search for a Reservation" message:@"Selected Start Date occurs after the Selected End Date" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelOpton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelOpton];
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)alertUserOfNoRooms {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Rooms Available" message:@"Select different dates or hotels" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelOpton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelOpton];
    [self presentViewController:alertController animated:true completion:nil];
}


@end
