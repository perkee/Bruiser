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
  return [self initWithDelegate:nil];
}

- (id) initWithDelegate:(id<TabDelegate>)delegate
{
  return [self initWithDelegate:delegate withAddress:nil];
}

- (id) initWithDelegate:(id<TabDelegate>)delegate withAddress:(NSString *)address
{
  if(self = [super init])
  {
    [self setTitle:@"New Tab"];
    self.delegates = [NSMutableSet set];
    if(delegate != nil)
    {
      [self addDelegate:delegate];
    }
    if(address != nil)
    {
      [self setAddress:address];
    }
  }
  else
  {
    self = nil;
  }
  return self;
  
}



- (NSString *) description
{
  return self.title;
}

-(void)detailViewDidUpdate:(NSNumber *)changes
{
  NSLog(@"Tab DVC changes w/: %u = %@",[changes intValue],changes);
  [self.delegates makeObjectsPerformSelector:@selector(tabDidUpdate:) withObject:changes];
}
-(void)addDelegate:(id<TabDelegate>)delegate
{
  [self.delegates addObject:delegate];
}

@end
