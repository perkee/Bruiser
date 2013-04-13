//
//  DetailvViewDelegate.h
//  BruiserMD
//
//  Created by perkee on 4/13/13.
//  Copyright (c) 2013 perkee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChangeTypes.h"

@protocol DetailViewDelegate <NSObject>
- (void) detailViewDidUpdate:(UpdateChanges) changes;
@end
