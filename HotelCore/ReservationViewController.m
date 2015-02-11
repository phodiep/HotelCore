//
//  ReservationViewController.m
//  HotelCore
//
//  Created by Pho Diep on 2/10/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "ReservationViewController.h"
#import "Reservation.h"
#import "Guest.h"

#pragma mark - Interface
@interface ReservationViewController ()

@property (strong, nonatomic) UIDatePicker *startDatePicker;
@property (strong, nonatomic) UIDatePicker *endDatePicker;
@property (strong, nonatomic) UIButton *reservationButton;
@property (strong, nonatomic) NSMutableDictionary *views;

@end

#pragma mark - Implementation
@implementation ReservationViewController

#pragma mark - UIViewController Lifecycle
-(void)loadView {
    UIView *rootView = [[UIView alloc]init];
    rootView.frame = [[UIScreen mainScreen]bounds];
    self.views = [[NSMutableDictionary alloc] init];
    
    self.reservationButton = [[UIButton alloc] init];
    [self.reservationButton setTitle:@"Book Reservation" forState:UIControlStateNormal];
    [self.reservationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.reservationButton addTarget:self action:@selector(reservationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    [self presetDatesAndLockIfNecessary];
    
    [self setupForAutolayout:self.reservationButton  addToView:rootView  keyForViewsDictionary:@"reservationButton"];
    [self setupForAutolayout:startDateLabel          addToView:rootView  keyForViewsDictionary:@"startDateLabel"];
    [self setupForAutolayout:endDateLabel            addToView:rootView  keyForViewsDictionary:@"endDateLabel"];
    [self setupForAutolayout:self.startDatePicker    addToView:rootView  keyForViewsDictionary:@"startDatePicker"];
    [self setupForAutolayout:self.endDatePicker      addToView:rootView  keyForViewsDictionary:@"endDatePicker"];
    
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|-75-[startDateLabel]-[startDatePicker]-8-[endDateLabel]-[endDatePicker]-8-[reservationButton]-16-|"
                                                                     options:NSLayoutFormatAlignAllCenterX metrics:nil views:self.views]];
    
    self.view = rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [NSString stringWithFormat:@"Rm %@ Reservation", self.selectedRoom.number];
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)presetDatesAndLockIfNecessary {
    if (self.dateSet == true) {
        self.startDatePicker.date = self.setStartDate;
        self.startDatePicker.userInteractionEnabled = false;
        self.endDatePicker.date = self.setEndDate;
        self.endDatePicker.userInteractionEnabled = false;
    }
}

#pragma mark - autolayout setup
- (void)setupForAutolayout:(id)object addToView:(UIView *)view keyForViewsDictionary:(id)key {
    [object setTranslatesAutoresizingMaskIntoConstraints:false];
    [view addSubview:object];
    [self.views setObject:object forKey:key];
    
}

#pragma mark - Reservation Button Actions
- (void)reservationButtonPressed:(UIButton*)sender {

    NSDate *startDate = self.startDatePicker.date;
    NSDate *endDate = self.endDatePicker.date;
    if ([startDate compare:endDate] > 0) {
        [self alertUserOfBadDateRange];
    } else {
        [self saveReservationToRoom];
        [self.navigationController popViewControllerAnimated:true];
    }
}

- (void)alertUserOfBadDateRange {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Unable to Make Reservation" message:@"Selected Start Date occurs after the Selected End Date" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelOpton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelOpton];
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)saveReservationToRoom {
    Guest *guest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:self.selectedRoom.managedObjectContext];
    guest.firstname = @"first";
    guest.lastname = @"last";
    Reservation *reservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:self.selectedRoom.managedObjectContext];
    reservation.startDate = self.startDatePicker.date;
    reservation.endDate = self.endDatePicker.date;
    reservation.room = self.selectedRoom;
    reservation.guest = guest;
    [self.selectedRoom addReservationsObject:reservation];
    
    NSError *saveError;
    [self.selectedRoom.managedObjectContext save:&saveError];
    
    if (saveError != nil) {
        NSLog(@"%@", saveError.localizedDescription);
    }

    
}


@end
