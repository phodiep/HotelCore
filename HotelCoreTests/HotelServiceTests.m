//
//  HotelServiceTests.m
//  HotelCore
//
//  Created by Pho Diep on 2/12/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Hotel.h"
#import "Room.h"
#import "Guest.h"
#import "HotelService.h"


@interface HotelServiceTests : XCTestCase

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) HotelService *hotelService;
@property (strong, nonatomic) Hotel *hotel;
@property (strong, nonatomic) Room *room;
@property (strong, nonatomic) Guest *guest;

@end

@implementation HotelServiceTests

- (void)setUp {
    [super setUp];
    self.hotelService = [[HotelService alloc] initForTesting];
    self.context = self.hotelService.coreDataStack.managedObjectContext;

    self.hotel = [NSEntityDescription insertNewObjectForEntityForName:@"Hotel" inManagedObjectContext:self.context];
    self.hotel.name = @"fake hotel";
    self.hotel.location = @"here";
    
    self.room = [NSEntityDescription insertNewObjectForEntityForName:@"Room" inManagedObjectContext:self.context];
    self.room.number = @101;
    self.room.beds = @1;
    self.room.hotel = self.hotel;
    
    self.guest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:self.context];
    self.guest.firstname = @"first";
    self.guest.lastname = @"last";
    

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.hotelService = nil;
    self.hotel = nil;
    self.room = nil;
    self.guest = nil;
}

- (void)testBookReservation {
    NSDate *startDate = [NSDate date];
    NSDate *endDate = [NSDate dateWithTimeInterval:(60 * 60 * 24 * 3) sinceDate:startDate];
    
    Reservation *reservation = [self.hotelService bookReservationForGuest:self.guest forRoom:self.room startDate:startDate endDate:endDate];
    
    XCTAssertNotNil(reservation, @"init with valid dates, should not be nil");

}

- (void)testBookReservationForInvalidDates {
    NSDate *earlierDate = [NSDate date];
    NSDate *laterDate = [NSDate dateWithTimeInterval:(60 * 60 * 24 * 1) sinceDate: earlierDate];
    
    Reservation *reservation = [self.hotelService bookReservationForGuest:self.guest forRoom:self.room startDate:laterDate endDate:earlierDate];
    
    XCTAssertNil(reservation, @"invalid dates should return a nil reservation");
    
}


@end
