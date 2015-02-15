//
//  AvailablityViewController.m
//  HotelCore
//
//  Created by Pho Diep on 2/10/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "AvailablityViewController.h"
#import "Hotel.h"
#import "Reservation.h"
#import "Room.h"
#import "AvailableRoomsViewController.h"
#import "HotelService.h"

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
    [self.startDatePicker addTarget:self action:@selector(startDateChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.endDatePicker = [[UIDatePicker alloc] init];
    self.endDatePicker.datePickerMode = UIDatePickerModeDate;
    [self.endDatePicker setMinimumDate:[NSDate date]];
    self.endDatePicker.date = [[NSDate alloc] initWithTimeInterval:(60 * 60 * 24) sinceDate:[NSDate date]];
    [self.endDatePicker addTarget:self action:@selector(endDateChanged:) forControlEvents:UIControlEventValueChanged];
    
//        self.hotelSegmentControl = [[UISegmentedControl alloc] initWithItems:[self getNamesOfHotels]];
    self.hotelSegmentControl = [[UISegmentedControl alloc] initWithItems:@[@"Fancy Estates", @"Solid Stay", @"Decent Inn", @"Okay Motel"]];
    self.hotelSegmentControl.frame = CGRectMake(0, 0, 300, 50);
    [self.hotelSegmentControl addTarget:self action:@selector(hotelSelected:) forControlEvents:UIControlEventValueChanged];
    self.hotelSegmentControl.tintColor = [UIColor blackColor];
    
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

    self.title = @"Search Available Rooms";
    self.context = [[[HotelService sharedService] coreDataStack] managedObjectContext];
    
}

#pragma mark - UIDatePicker change
- (void)startDateChanged:(UIDatePicker*)sender {
    if ([self.startDatePicker.date compare:self.endDatePicker.date] > 0 ) {
        self.endDatePicker.date = [[NSDate alloc] initWithTimeInterval:(60 * 60 * 24) sinceDate:sender.date];
    }
}

- (void)endDateChanged:(UIDatePicker*)sender {
    if ([self.startDatePicker.date compare:self.endDatePicker.date] > 0 ) {
        self.startDatePicker.date = sender.date;
    }
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
        
        if ([availableRooms count] > 0 ) {
            AvailableRoomsViewController *availableVC = [[AvailableRoomsViewController alloc] init];
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
    NSDate *startDate = [[NSDate alloc] initWithTimeInterval:-60 sinceDate:self.startDatePicker.date];
    NSDate *endDate = [[NSDate alloc] initWithTimeInterval:60 sinceDate:self.endDatePicker.date];

    NSString *selectedHotelName;
    if (self.hotelSegmentControl.selectedSegmentIndex >= 0) {
        selectedHotelName = [self.hotelSegmentControl titleForSegmentAtIndex:self.hotelSegmentControl.selectedSegmentIndex];
    } else {
        selectedHotelName = nil;
    }
    
    NSArray *overlappingReservations = [self searchForExistingOverlappingReservations:selectedHotelName fromStartDate:startDate toEndDate:endDate];
    
    NSMutableArray *reservedRooms = [NSMutableArray new];
    for (Reservation *reservation in overlappingReservations) {
        [reservedRooms addObject:reservation.room];
    }

    return [self availableRooms:selectedHotelName excludingReservedRooms:reservedRooms];
}

- (NSArray*)availableRooms:(NSString*)selectedHotelName excludingReservedRooms:(NSArray*)reservedRooms {
    NSPredicate *roomPredicate;
    if (selectedHotelName != nil) {
        roomPredicate = [NSPredicate predicateWithFormat:@"self.hotel.name MATCHES %@ AND NOT (self IN %@)", selectedHotelName, reservedRooms];
    } else {
        roomPredicate = [NSPredicate predicateWithFormat:@"NOT (self IN %@)", reservedRooms];
    }
    
    return [self applyPredicate:roomPredicate toFetchEntity:@"Room"];
}

- (NSArray*)searchForExistingOverlappingReservations:(NSString*)selectedHotelName fromStartDate:(NSDate*)startDate toEndDate:(NSDate*)endDate {
    NSPredicate *reservationPredicate;

    if (selectedHotelName != nil) {
        reservationPredicate = [NSPredicate predicateWithFormat:@"room.hotel.name MATCHES %@ AND startDate <= %@ AND endDate >= %@", selectedHotelName, endDate, startDate];
    } else {
        reservationPredicate = [NSPredicate predicateWithFormat:@"startDate <= %@ AND endDate >= %@", endDate, startDate];
    }
    
    return [self applyPredicate:reservationPredicate toFetchEntity:@"Reservation"];

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
