//
//  HashTable.h
//  HotelCore
//
//  Created by Pho Diep on 2/14/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HashTable : NSObject

- (instancetype)initWithSize:(NSInteger)size;
- (id)objectForKey:(NSString*)key;
- (void)removeObjectForKey:(NSString*)key;
- (void)setObject:(id)object forKey:(NSString*)key;


@end
