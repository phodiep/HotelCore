//
//  ReservationListViewController.h
//  HotelCore
//
//  Created by Pho Diep on 2/11/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"

@interface ReservationListViewController : UIViewController

@property (strong, nonatomic) NSArray *reservations;
@property (strong, nonatomic) Room *selectedRoom;

@end
