//
//  Tab.m
//  BruiserMD
//
//  Created by perkee on 3/17/13.
//  Copyright (c) 2013 perkee. All rights reserved.
//

#import "Tab.h"

@implementation Tab

- (id) init
{
  
  if(self = [super init])
  {
    [self setTitle:[[NSDate date] description]];
  }
  else
  {
    self = nil;
  }
  return self;
}

- (NSString *) description
{
  return [NSString stringWithFormat:@"NT: %@",self.title];
}

@end
