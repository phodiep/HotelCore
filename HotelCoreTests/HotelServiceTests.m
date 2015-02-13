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

- (void)testRemoveReservation {
    NSDate *startDate = [NSDate date];
    NSDate *endDate = [NSDate dateWithTimeInterval:(60 * 60 * 24 * 3) sinceDate:startDate];
    
    Reservation *reservation = [self.hotelService bookReservationForGuest:self.guest forRoom:self.room startDate:startDate endDate:endDate];
    
    XCTAssertNotNil(reservation, @"init with valid dates, should not be nil");

    [self.hotelService removeReservation:reservation];
    
    NSError *error;
    NSManagedObjectID *reservationID = [reservation objectID];
    NSManagedObject *removedReservation = [self.context existingObjectWithID:reservationID error:&error];
    
    XCTAssertNil(removedReservation);

    
}

- (void)testAddNewHotel {
    NSString *name = @"name";
    NSString *location = @"here";
    NSNumber *stars = @2;
    
    Hotel *newHotel = [self.hotelService addNewHotel:name atLocation:location starRating:stars];
    XCTAssertNotNil(newHotel);
    
}

- (void)testAddNewHotelWithoutStarRating {
    NSString *name = @"name";
    NSString *location = @"here";
    
    Hotel *newHotel = [self.hotelService addNewHotel:name atLocation:location starRating:nil];
    XCTAssertNotNil(newHotel);
    
}

- (void)testAddNewHotelMissingName {
    NSString *location = @"here";
    NSNumber *stars = @2;
    
    Hotel *newHotel = [self.hotelService addNewHotel:nil atLocation:location starRating:stars];
    XCTAssertNil(newHotel);
    
}

- (void)testAddNewHotelMissingLocation {
    NSString *name = @"name";
    NSNumber *stars = @2;
    
    Hotel *newHotel = [self.hotelService addNewHotel:name atLocation:nil starRating:stars];
    XCTAssertNil(newHotel);
    
}

- (void)testRemoveHotel {
    NSManagedObjectID *hotelId = [self.hotel objectID];
    NSManagedObject *hotel = [self.context existingObjectWithID:hotelId error:nil];

    XCTAssertNotNil(hotel);
    
    [self.hotelService removeHotel:self.hotel];
    
    NSManagedObject *removedHotel = [self.context existingObjectWithID:hotelId error:nil];
    
    XCTAssertNil(removedHotel);
}

- (void)testAddNewRoom {
    NSNumber *number = @1;
    NSNumber *beds = @2;
    NSNumber *rate = @1;
    
    Room *room = [self.hotelService addNewRoom:number atHotel:self.hotel withNumberOfBeds:beds rate:rate];
    
    XCTAssertNotNil(room);
}

- (void)testRemoveRoom {
    NSManagedObjectID *roomID = [self.room objectID];
    NSManagedObject *room = [self.context existingObjectWithID:roomID error:nil];
    XCTAssertNotNil(room);
    
    [self.hotelService removeRoom:self.room];
    NSManagedObject *removedRoom = [self.context existingObjectWithID:roomID error:nil];
    XCTAssertNil(removedRoom);
    
}

- (void)testAddNewRoomWithoutRate {
    NSNumber *number = @1;
    NSNumber *beds = @2;
    
    Room *room = [self.hotelService addNewRoom:number atHotel:self.hotel withNumberOfBeds:beds rate:nil];
    
    XCTAssertNotNil(room);
}

- (void)testAddNewRoomMissingNumber {
    NSNumber *beds = @2;
    NSNumber *rate = @1;
    
    Room *room = [self.hotelService addNewRoom:nil atHotel:self.hotel withNumberOfBeds:beds rate:rate];
    
    XCTAssertNil(room);
}

- (void)testAddNewRoomMissingBeds {
    NSNumber *number = @1;
    NSNumber *rate = @1;
    
    Room *room = [self.hotelService addNewRoom:number atHotel:self.hotel withNumberOfBeds:nil rate:rate];
    
    XCTAssertNil(room);
}

- (void)testAddNewRoomMissingHotel {
    NSNumber *number = @1;
    NSNumber *beds = @2;
    NSNumber *rate = @1;
    
    Room *room = [self.hotelService addNewRoom:number atHotel:nil withNumberOfBeds:beds rate:rate];
    
    XCTAssertNil(room);
}



@end
