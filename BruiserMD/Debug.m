//
//  Debug.m
//  BruiserMD
//
//  Created by perkee on 4/13/13.
//  Copyright (c) 2013 perkee. All rights reserved.
//

#import "Debug.h"

@implementation Debug

+(NSString *)printRect:(CGRect)rect
{
  return [NSString stringWithFormat:@"view: ( %3.0f, %3.0f) %3.0f x %3.0f",
          rect.origin.x,rect.origin.y,
          rect.size.width,rect.size.height
          ];

}

@end
