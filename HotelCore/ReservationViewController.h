//
//  ReservationViewController.h
//  HotelCore
//
//  Created by Pho Diep on 2/10/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"

@interface ReservationViewController : UIViewController

@property (strong, nonatomic) Room *selectedRoom;

@property (nonatomic) BOOL dateSet;
@property (strong, nonatomic) NSDate *setStartDate;
@property (strong, nonatomic) NSDate *setEndDate;


@end
