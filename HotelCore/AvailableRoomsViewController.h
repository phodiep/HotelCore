//
//  AvailableRoomsViewController.h
//  HotelCore
//
//  Created by Pho Diep on 2/10/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvailableRoomsViewController : UIViewController

@property (strong, nonatomic) NSArray *rooms;

@property (strong, nonatomic) NSDate *setStartDate;
@property (strong, nonatomic) NSDate *setEndDate;


@end
