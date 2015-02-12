//
//  ReservationCell.m
//  HotelCore
//
//  Created by Pho Diep on 2/11/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "ReservationCell.h"

#pragma mark - Interface
@interface ReservationCell ()

@property (strong, nonatomic) NSMutableDictionary *views;

@end

#pragma mark - Implementation
@implementation ReservationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.views = [[NSMutableDictionary alloc] init];
        self.hotelLabel = [[UILabel alloc] init];
        self.roomLabel = [[UILabel alloc] init];
        self.dateLabel = [[UILabel alloc] init];
        self.guestLabel = [[UILabel alloc] init];
        
        self.hotelLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        self.roomLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        self.dateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:14];
        self.guestLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:14];

        [self setupForAutolayout: self.hotelLabel   addToView:self.contentView  keyForViewsDictionary:@"hotelLabel"];
        [self setupForAutolayout: self.roomLabel    addToView:self.contentView  keyForViewsDictionary:@"roomLabel"];
        [self setupForAutolayout: self.dateLabel    addToView:self.contentView  keyForViewsDictionary:@"dateLabel"];
        [self setupForAutolayout: self.guestLabel   addToView:self.contentView  keyForViewsDictionary:@"guestLabel"];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[hotelLabel]-(>=5)-[dateLabel]-16-|" options:NSLayoutFormatAlignAllTop metrics:nil views:self.views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[roomLabel]-(>=5)-[guestLabel]-16-|" options:NSLayoutFormatAlignAllBottom metrics:nil views:self.views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[hotelLabel]-[roomLabel]-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:self.views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[dateLabel]-[guestLabel]-|" options:NSLayoutFormatAlignAllRight metrics:nil views:self.views]];
    }
    
    return self;
    
}

#pragma mark - autolayout setup
- (void)setupForAutolayout:(id)object addToView:(UIView *)view keyForViewsDictionary:(id)key {
    [object setTranslatesAutoresizingMaskIntoConstraints:false];
    [view addSubview:object];
    [self.views setObject:object forKey:key];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
