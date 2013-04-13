//
//  MasterViewController.h
//  BruiserMD
//
//  Created by perkee on 3/17/13.
//  Copyright (c) 2013 perkee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tab.h"
#import "TabDelegate.h"
@class DetailViewController;

@interface MasterViewController : UITableViewController <TabDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
