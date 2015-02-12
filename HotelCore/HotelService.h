//
//  HotelService.h
//  HotelCore
//
//  Created by Pho Diep on 2/11/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataStack.h"
#import "Reservation.h"
#import "Room.h"
#import "Guest.h"
#import "Hotel.h"

@interface HotelService : NSObject

@property (strong, nonatomic) CoreDataStack *coreDataStack;

+(id)sharedService;
-(instancetype)initForTesting;

-(Hotel *)addNewHotel:(NSString*)name atLocation:(NSString*)location starRating:(NSNumber*)stars;
-(Room *)addNewRoom:(NSNumber *)number atHotel:(Hotel *)hotel withNumberOfBeds:(NSNumber *)beds rate:(NSNumber*)rate;

-(Reservation*)bookReservationForGuest:(Guest*)guest forRoom:(Room*)room startDate:(NSDate*)startDate endDate:(NSDate*)endDate;

@end
