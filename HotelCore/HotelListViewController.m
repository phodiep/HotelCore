//
//  HotelListViewController.m
//  HotelCore
//
//  Created by Pho Diep on 2/9/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "HotelListViewController.h"
#import "HotelCell.h"
#import "Hotel.h"
#import "RoomsViewController.h"
#import "HotelService.h"

#pragma mark - Interface
@interface HotelListViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) HotelService *hotelService;
@property (strong, nonatomic) UITableView *tableView;
@property (weak, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) UIBarButtonItem *addHotelButton;
@property (strong, nonatomic) UIAlertView *hotelAlert;

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
    self.hotelService = [HotelService sharedService];
    self.context = [[self.hotelService coreDataStack] managedObjectContext];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:HotelCell.class forCellReuseIdentifier:@"HOTEL_CELL"];
    
    self.addHotelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewHotel:)];
    self.navigationItem.rightBarButtonItem = self.addHotelButton;

    [self fetchListOfHotels];
}

-(void)fetchListOfHotels {
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
    
    RoomsViewController *roomVC = [[RoomsViewController alloc] init];
    roomVC.selectedHotel = self.hotels[indexPath.row];
    [self.navigationController pushViewController:roomVC animated:true];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *name = [[alertView textFieldAtIndex:0] text];
    NSString *location = [[alertView textFieldAtIndex:1] text];
    
    if (buttonIndex == 1) { //pressed continue
        if ([name isEqualToString:@""] || [location isEqualToString:@""]) {
            [self alertUserOfMissingInfoForNewHotel:name location:location];
        } else {
            [self.hotelService addNewHotel:name atLocation:location starRating:nil];
            [self fetchListOfHotels];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Hotel *selectedHotel = self.hotels[indexPath.row];
        [self.hotelService removeHotel:selectedHotel];
        [self fetchListOfHotels];
    }
}


#pragma mark - Button Actions
- (void)addNewHotel:(UIBarButtonItem*)sender {
    [self setupHotelAlert:nil location:nil];
    [self.hotelAlert show];
}

- (void)setupHotelAlert:(NSString*)name location:(NSString*)location {

    self.hotelAlert = [[UIAlertView alloc] initWithTitle:@"New Hotel" message:@"Name and Location are required" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add New Hotel",nil];
    self.hotelAlert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    UITextField *nameField = [self.hotelAlert textFieldAtIndex:0];
    nameField.placeholder = @"Enter name of hotel";
    UITextField *locationField = [self.hotelAlert textFieldAtIndex:1];
    locationField.placeholder = @"Enter location";
    [[self.hotelAlert textFieldAtIndex:1]setSecureTextEntry:NO];

    
}

-(void)alertUserOfMissingInfoForNewHotel:(NSString*)name location:(NSString*)location {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Unable to Add Hotel" message:@"Both Name and Location of the new hotel are required." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okOption = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self setupHotelAlert:name location:location];
        
        [[self.hotelAlert textFieldAtIndex:0] setText:name];
        [[self.hotelAlert textFieldAtIndex:1] setText:location];
        
        [self.hotelAlert show];
    }];
    [alertController addAction:okOption];
    [self presentViewController:alertController animated:true completion:nil];
}




@end
