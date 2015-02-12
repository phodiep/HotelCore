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

-(BOOL)datesAreValid:(NSDate*)startDate endDate:(NSDate*)endDate {
    return ( [startDate compare:[NSDate date]] < 0 || //startDate has passed
             [endDate   compare:[NSDate date]] < 0 || //endDate has passed
             [startDate compare:endDate] > 0 );       //startDate is after endDate
}


@end
