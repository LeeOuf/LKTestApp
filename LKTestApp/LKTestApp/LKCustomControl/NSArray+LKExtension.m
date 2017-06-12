//
//  NSArray+LKExtension.m
//  LKTestApp
//
//  Created by Li,Ke(BBTD) on 2017/6/12.
//  Copyright © 2017年 Li,Ke(BBTD). All rights reserved.
//

#import "NSArray+LKExtension.h"

@implementation NSArray (LKExtension)

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if ( index >= self.count )
        return nil;
    
    return [self objectAtIndex:index];
}

@end

@implementation NSMutableArray (LKExtension)

- (void)safeAddObject:(id)anObject
{
    if (anObject) {
        [self addObject:anObject];
    }
}
- (void)safeRemoveObject:(id)object
{
    if (object)
    {
        [self removeObject:object];
    }
}
-(bool)safeInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    if ( index > self.count && index != 0)
    {
        return NO;
    }
    
    if (!anObject)
    {
        return NO;
    }
    
    [self insertObject:anObject atIndex:index];
    
    return YES;
}

-(bool)safeRemoveObjectAtIndex:(NSUInteger)index
{
    if ( index >= self.count )
    {
        return NO;
    }
    [self removeObjectAtIndex:index];
    return YES;
    
}
-(bool)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if ( index >= self.count )
    {
        return NO;
    }
    [self replaceObjectAtIndex:index withObject:anObject];
    return YES;
}

@end
