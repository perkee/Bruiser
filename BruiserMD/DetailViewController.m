//
//  DetailViewController.m
//  BruiserMD
//
//  Created by perkee on 3/17/13.
//  Copyright (c) 2013 perkee. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

  if (self.detailItem)
  {
    NSString *urlString = @"http://perk.ee";
    
    [self.webView setDelegate:self];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    self.urlField.text = [self.detailItem description];
  }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
  NSString *cssFile = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
  NSString *css = [[NSString stringWithContentsOfFile:cssFile encoding:NSUTF8StringEncoding error:nil] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
  
  NSString* js = [NSString stringWithFormat:
                  @"var styleNode = document.createElement('style');\n"
                  "styleNode.type = \"text/css\";\n"
                  "var styleText = document.createTextNode(\"%@\");\n"
                  "styleNode.appendChild(styleText);\n"
                  "document.getElementsByTagName('head')[0].appendChild(styleNode);\n",css];
  
  //NSLog(@"cssFile:\t%@",cssFile);
  //NSLog(@"css:\t%@",css);
  NSLog(@"js:\n%@",js);
  NSLog(@"result:\t%@",[self.webView stringByEvaluatingJavaScriptFromString:js]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
