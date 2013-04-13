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

-(id)initWithCoder:(NSCoder *)aDecoder
{
  if(self = [super initWithCoder:aDecoder])
  {
    self.delegates = [NSMutableSet set];
  }
  else
  {
    self = nil;
  }
  return self;
}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem)
    {
      _detailItem = newDetailItem;
      [self.delegates addObject:self.detailItem];
      //[self.delegates sayHello];
      //NSLog(@"DV's delegates: %@",self.delegates);
        // Update the view.
      [self configureView];
    }

    if (self.masterPopoverController != nil)
    {
      [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

  if (self.detailItem)
  {
    
    NSString *urlString = @"http://perk.ee";
    [self.urlField setDelegate:self];
    [self.mainWebView setDelegate:self];
    [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    //self.urlField.text = [self.detailItem description];
    self.urlField.text = urlString;
  }
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
  [self.urlField setText:webView.request.URL.absoluteString];
  
  NSString *cssFile = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
  NSString *css = [[NSString stringWithContentsOfFile:cssFile encoding:NSUTF8StringEncoding error:nil] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
  
  NSString* js = [NSString stringWithFormat:
                  @"var styleNode = document.createElement('style');\n"
                  "styleNode.type = \"text/css\";\n"
                  "var styleText = document.createTextNode(\"%@\");\n"
                  "styleNode.appendChild(styleText);\n"
                  "document.getElementsByTagName('head')[0].appendChild(styleNode);\n"
                  "document.title",css];
  NSString *title = [self.mainWebView stringByEvaluatingJavaScriptFromString:js];
  
  [self.detailItem setTitle:title];
  [self updateDelegates:TitleChanged];
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

#pragma mark - Handle Own Delegates
-(void)updateDelegates:(UpdateChanges)changes
{
  NSLog(@"DVC updating with: %u",changes);
  [self.delegates makeObjectsPerformSelector:@selector(detailViewDidUpdate:) withUpdateChanges:changes];
}

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  NSLog(@"text field resigned: %@",[textField resignFirstResponder] ? @"yup" : @"nope");
  
  return NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
  NSLog(@"text field ended: %@",textField.text);
}

@end
