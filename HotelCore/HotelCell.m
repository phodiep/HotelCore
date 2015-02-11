//
//  HotelCell.m
//  HotelCore
//
//  Created by Pho Diep on 2/9/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "HotelCell.h"

#pragma mark - Implementation
@implementation HotelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.nameLabel = [[UILabel alloc] init];
        self.locationLabel = [[UILabel alloc] init];

        [self.nameLabel setTranslatesAutoresizingMaskIntoConstraints:false];
        [self.locationLabel setTranslatesAutoresizingMaskIntoConstraints:false];
        
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.locationLabel];
        
        NSDictionary *views = @{@"nameLabel": self.nameLabel, @"locationLabel": self.locationLabel};
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[nameLabel]-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[nameLabel]-[locationLabel]-16-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    }
    
    return self;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
