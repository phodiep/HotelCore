//
//  RoomCell.m
//  HotelCore
//
//  Created by Pho Diep on 2/9/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "RoomCell.h"

@implementation RoomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.nameLabel = [[UILabel alloc] init];
        self.bedsLabel = [[UILabel alloc] init];
        
        [self.nameLabel setTranslatesAutoresizingMaskIntoConstraints:false];
        [self.bedsLabel setTranslatesAutoresizingMaskIntoConstraints:false];
        
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.bedsLabel];
        
        NSDictionary *views = @{@"nameLabel": self.nameLabel, @"bedsLabel": self.bedsLabel};
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[nameLabel]" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[bedsLabel]-16-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[nameLabel(30)]-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[bedsLabel(30)]-|" options:0 metrics:nil views:views]];
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
