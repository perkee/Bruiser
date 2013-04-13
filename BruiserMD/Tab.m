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

-(void)detailViewDidUpdate
{
  if(self.delegate != nil && [self.delegate respondsToSelector:@selector(tabDidUpdate)])
  {
    [self.delegate tabDidUpdate];
  }
}

@end
