//
//  HashTable.m
//  HotelCore
//
//  Created by Pho Diep on 2/14/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "HashTable.h"
#import "Bucket.h"

#pragma mark - Interface
@interface HashTable ()

@property (nonatomic) NSInteger size;
@property (strong, nonatomic) NSMutableArray *hashArray;

@end

#pragma mark - Implementation
@implementation HashTable

-(instancetype)initWithSize:(NSInteger)size {
    self = [super init];
    if (self) {
        self.size = size;
        self.hashArray = [[NSMutableArray alloc]init];
        
        for (int i=0; i < self.size; i++) {
            Bucket *bucket = [[Bucket alloc] init];
            [self.hashArray addObject:bucket];
        }
    }
    return self;
}

- (NSInteger)hash:(NSString*)key {
    NSInteger total = 0;
    for (int i = 0; i < key.length; i++) {
        NSInteger ascii = [key characterAtIndex:i];
        total += ascii;
    }
    return total % self.size;
}

- (id)objectForKey:(NSString*)key {
    NSInteger index = [self hash:key];
    
    Bucket *bucket = self.hashArray[index];
    
    while (bucket != nil) {
        if ([bucket.key isEqualToString:key]) {
            return bucket.data;
        } else {
            bucket = bucket.next;
        }
    }
    return nil;
}

- (void)removeObjectForKey:(NSString*)key {
    NSInteger index = [self hash:key];
    Bucket *previousBucket;
    Bucket *bucket = self.hashArray[index];
    
    while (bucket) {
        if ([key isEqualToString:bucket.key]) {
            if (!previousBucket) {
                Bucket *nextBucket = bucket.next;
                if (!nextBucket) {
                    nextBucket = [[Bucket alloc] init];
                }
                self.hashArray[index] = nextBucket;
            } else {
                previousBucket.next = bucket.next;
            }
            return;
        }
        previousBucket = bucket;
        bucket = bucket.next;
    }
}

- (void)setObject:(id)object forKey:(NSString*)key {
    NSInteger index = [self hash:key];
    Bucket *bucket = [[Bucket alloc] init];
    bucket.key = key;
    bucket.data = object;
    
    [self removeObjectForKey:key];
    Bucket *head = self.hashArray[index];
    if (!head.data) {
        self.hashArray[index] = bucket;
    } else {
        bucket.next = head;
        self.hashArray[index] = bucket;
    }
}

@end












