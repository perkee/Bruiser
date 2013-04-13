//
//  NSSet_makeObjectsPerformSelectorWithChangeTypes.m

//  BruiserMD
//
//  Created by perkee on 4/13/13.
//  Copyright (c) 2013 perkee. All rights reserved.
//

#import "NSSet_makeObjectsPerformSelectorWithChangeTypes.h"

@implementation NSSet (ChangeTypes)
-(void) makeObjectsPerformSelector:(SEL)selector withUpdateChanges:(UpdateChanges)changes
{
  [self makeObjectsPerformSelector:selector withObject:[NSNumber numberWithInt:changes]];
}
@end


@implementation NSMutableSet (ChangeTypes)
-(void) makeObjectsPerformSelector:(SEL)selector withUpdateChanges:(UpdateChanges)changes
{
  [self makeObjectsPerformSelector:selector withObject:[NSNumber numberWithInt:changes]];
}
-(void) sayHello
{
  NSLog(@"I'm a weird set: %@",self);
}
@end
