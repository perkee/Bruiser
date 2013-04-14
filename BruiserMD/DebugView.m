//
//  DebugView.m
//  BruiserMD
//
//  Created by perkee on 4/14/13.
//  Copyright (c) 2013 perkee. All rights reserved.
//

#import "DebugView.h"
#import "Debug.h"

@implementation DebugView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      NSLog(@"DebugView init: %@",[Debug printRect:frame]);
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    NSLog(@"DebugView init: %@",aDecoder);
  }
  return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  CGPoint point = [[touches anyObject]locationInView:self];
  //NSLog(@"\nTouches Began At:%@",[Debug printPoint:point]);
  for(id subview in self.subviews)
  {
    if(CGRectContainsPoint([subview frame], point))
    {
      //NSLog(@"Touch began: %@",subview);
      [subview sendActionsForControlEvents:UIControlEventTouchDown];
    }
  }
  [super touchesBegan:touches withEvent:event];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  CGPoint point = [[touches anyObject]locationInView:self];
  //NSLog(@"\nTouches Ended At:%@",[Debug printPoint:point]);
  for(id subview in self.subviews)
  {
    if(CGRectContainsPoint([subview frame], point))
    {
      //NSLog(@"Touch ended: %@",subview);
      [subview sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
  }
  [super touchesEnded:touches withEvent:event];
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
  //NSLog(@"HitTest:%@ %d.%d",[Debug printPoint:point],event.type,event.subtype);
  return [super hitTest:point withEvent:event];
}

@end
