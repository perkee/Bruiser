//
//  DebugWindow.m
//  BruiserMD
//
//  Created by perkee on 4/14/13.
//  Copyright (c) 2013 perkee. All rights reserved.
//

#import "DebugWindow.h"
#import "Debug.h"

@implementation DebugWindow

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    NSLog(@"DebugWindow init: %@",[Debug printRect:frame]);
  }
  return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self)
  {
    NSLog(@"DebugWindow init: %@",aDecoder);
  }
  return self;
}

-(void)sendEvent:(UIEvent *)event
{
  NSLog(@"Window event: %@",event);
  [super sendEvent:event];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
