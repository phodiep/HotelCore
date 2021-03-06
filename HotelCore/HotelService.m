//
//  HotelService.m
//  HotelCore
//
//  Created by Pho Diep on 2/11/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "HotelService.h"

#pragma mark - Interface
@interface HotelService ()

@property (strong, nonatomic) NSManagedObjectContext *context;

@end

#pragma mark - Implementation
@implementation HotelService

+(id)sharedService {
    static HotelService *mySharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mySharedService = [[self alloc] init];
    });
    return mySharedService;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        self.coreDataStack = [[CoreDataStack alloc] init];
        self.context = self.coreDataStack.managedObjectContext;
    }
    return self;
}

-(instancetype)initForTesting {
    self = [super init];
    if (self) {
        self.coreDataStack = [[CoreDataStack alloc] initForTesting];
        self.context = self.coreDataStack.managedObjectContext;
    }
    return self;
}



-(Hotel *)addNewHotel:(NSString*)name atLocation:(NSString*)location starRating:(NSNumber*)stars {
    if (name != nil && location != nil) {
        Hotel *hotel = [NSEntityDescription insertNewObjectForEntityForName:@"Hotel" inManagedObjectContext:self.context];
        hotel.name = name;
        hotel.location = location;
        if (stars > 0) {
            hotel.stars = stars;
        }
        
        NSError *saveError;
        [self.context save:&saveError];
        
        if (saveError == nil) {
            return hotel;
        }
    }
    return nil;
}

-(BOOL)removeHotel:(Hotel*)hotel {
    [self.context deleteObject:hotel];
    
    NSError *saveError;
    [self.context save:&saveError];
    if (saveError == nil) {
        return true;
    }
    return false;
}

-(Room *)addNewRoom:(NSNumber *)number atHotel:(Hotel *)hotel withNumberOfBeds:(NSNumber *)beds rate:(NSNumber*)rate {
    if (number != nil && hotel != nil && beds != nil) {
        Room *room = [NSEntityDescription insertNewObjectForEntityForName:@"Room" inManagedObjectContext:self.context];
        room.number = number;
        room.beds = beds;
        room.hotel = hotel;
        if (rate != nil) {
            room.rate = rate;
        }
        
        NSError *saveError;
        [self.context save:&saveError];
        
        if (saveError == nil) {
            return room;
        }
    }
    return nil;
}

-(BOOL)removeRoom:(Room*)room {
    [self.context deleteObject:room];
    
    NSError *saveError;
    [self.context save:&saveError];
    if(saveError == nil) {
        return true;
    }
    return false;
}


-(Reservation *)bookReservationForGuest:(Guest *)guest forRoom:(Room *)room startDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    if ([self datesAreValid:startDate endDate:endDate]) {
        Reservation *reservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:self.context];
        reservation.startDate = startDate;
        reservation.endDate = endDate;
        reservation.room = room;
        reservation.guest = guest;
    
        NSError *saveError;
        [self.context save:&saveError];

        if (saveError == nil) {
            return reservation;
        }
    }

    return nil;
    
}

-(BOOL)removeReservation:(Reservation*)reservation {
    [self.context deleteObject:reservation];
    
    NSError *saveError;
    [self.context save:&saveError];
    if(saveError == nil) {
        return true;
    }
    return false;
}

-(BOOL)datesAreValid:(NSDate*)startDate endDate:(NSDate*)endDate {
    if ([startDate timeIntervalSinceNow] <= -60 ||  //startDate has passed
        [endDate   timeIntervalSinceNow] <= -60 ||  //endDate has passed
        [startDate compare:endDate] >= 0 )          //startDate is after endDate
    {
        return false;
    }
    return true;
}


@end
