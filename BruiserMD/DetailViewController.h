//
//  DetailViewController.h
//  BruiserMD
//
//  Created by perkee on 3/17/13.
//  Copyright (c) 2013 perkee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, UIWebViewDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UITextField *urlField;
@end
