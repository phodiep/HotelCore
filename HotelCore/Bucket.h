//
//  Bucket.h
//  HotelCore
//
//  Created by Pho Diep on 2/14/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bucket : NSObject

@property (strong, nonatomic) Bucket *next;
@property (strong, nonatomic) id data;
@property (strong, nonatomic) NSString *key;

@end
