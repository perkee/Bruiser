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
    [self setTitle:@"New Tab"];
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

-(void)detailViewDidUpdate:(UpdateChanges) changes
{
  NSLog(@"Tab receives update %u",changes);
  [self.delegates makeObjectsPerformSelector:@selector(tabDidUpdate:) withObject:[NSNumber numberWithInt:changes]];
}
-(void)addDelegate:(id<TabDelegate>)delegate
{
  [self.delegates addObject:delegate];
}

@end
