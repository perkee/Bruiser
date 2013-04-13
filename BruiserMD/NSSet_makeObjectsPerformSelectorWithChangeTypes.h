//
//  NSSet_makeObjectsPerformSelectorWithChangeTypes.h
//  BruiserMD
//
//  Created by perkee on 4/13/13.
//  Copyright (c) 2013 perkee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChangeTypes.h"


@interface NSSet (ChangeTypes)
-(void) makeObjectsPerformSelector:(SEL)selector withUpdateChanges:(UpdateChanges)changes;
@end

@interface NSMutableSet (ChangeTypes)
-(void) makeObjectsPerformSelector:(SEL)selector withUpdateChanges:(UpdateChanges)changes;
-(void) sayHello;
@end
