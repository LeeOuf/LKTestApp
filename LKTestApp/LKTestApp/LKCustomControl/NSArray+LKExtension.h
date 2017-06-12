//
//  NSArray+LKExtension.h
//  LKTestApp
//
//  Created by Li,Ke(BBTD) on 2017/6/12.
//  Copyright © 2017年 Li,Ke(BBTD). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (LKExtension)

- (id)safeObjectAtIndex:(NSUInteger)index;

@end

@interface NSMutableArray (LKExtension)

- (void)safeAddObject:(id)anObject;

- (void)safeRemoveObject:(id)object;

-(bool)safeInsertObject:(id)anObject atIndex:(NSUInteger)index;

-(bool)safeRemoveObjectAtIndex:(NSUInteger)index;

-(bool)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

@end
