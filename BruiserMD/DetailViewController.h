//
//  DetailViewController.h
//  BruiserMD
//
//  Created by perkee on 3/17/13.
//  Copyright (c) 2013 perkee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewDelegate.h"
#import "Tab.h"
#import "NSSet_makeObjectsPerformSelectorWithChangeTypes.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, UIWebViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UIWebView *mainWebView;
@property (strong, nonatomic) IBOutlet UITextField *urlField;
@property (strong, nonatomic) NSMutableSet *delegates;
-(void)updateDelegates:(UpdateChanges) changes;

-(void)navigate;
@end
