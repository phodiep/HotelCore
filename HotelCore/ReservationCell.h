//
//  ReservationCell.h
//  HotelCore
//
//  Created by Pho Diep on 2/11/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReservationCell : UITableViewCell

@property (strong, nonatomic) UILabel *hotelLabel;
@property (strong, nonatomic) UILabel *roomLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *guestLabel;

@end
