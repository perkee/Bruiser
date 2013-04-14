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
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.navBar = [UINavigationItem new];
    self.controlView = [UIView new];
  }
  else
  {
    self = nil;
  }
  return self;
}

- (void)setTab:(id)newTab
{
  if (_tab != newTab)
  {
    _tab = newTab;
    [self.delegates addObject:self.tab];
    //[self.delegates sayHello];
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

  if (self.tab)
  {
    [self.urlField setDelegate:self];
    self.restore = [self.urlField frame];
    NSLog(@"URLF dimensions: %3.0f x %3.0f",self.restore.size.width,self.restore.size.height);
    NSLog(@"URLF origin:     %3.0f x %3.0f",self.restore.origin.x,  self.restore.origin.y);
    [self.mainWebView setDelegate:self];
    [self navigate];
    self.urlField.text = [self.tab urlString];
    [self textFieldDidEndEditing:self.urlField];
  }
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

#pragma mark - Web Navigation

- (void)navigate
{
  [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[self.tab url]]];
}
-(void)navigateWithURL:(NSURL *)url
{
  [self.tab setUrl:url];
  [self navigate];
}

-(void)navigateWithURLString:(NSString *)urlString
{
  [self.tab setUrlString:urlString];
  [self navigate];
}

-(void)navigateWithString:(NSString *)string
{
  //NSLog(@"Navigate to: %@",string);
  NSString *encoded = [string  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  encoded = [encoded stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  NSURL *url;
  if([encoded rangeOfString:@"."].location != NSNotFound)
  {
    //NSLog(@"There is a period in  %@",encoded);
    url = [NSURL URLWithString:encoded];
    if(url.scheme && url.host)
    {
      //NSLog(@"Good enc:   %@",url.host);
    }
    else
    {
      //NSLog(@"Badd enc:   %@",url);
      NSString *http = [NSString stringWithFormat:@"http://%@",encoded];
      url = [NSURL URLWithString:http];
      if(url.scheme && url.host)
      {
        //NSLog(@"Good http: %@",url.host);
      }
      else
      {
        //NSLog(@"Badd http: %@",url.host);
      }
    }
  }
  else
  {
    //NSLog(@"There is no period in %@",encoded);
    NSString *search = [string stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    url = [NSURL URLWithString:[NSString stringWithFormat:@"https://duckduckgo.com?q=%@",search]];
  }
  [self navigateWithURL:url];
}

#pragma mark - WebView Delegate Methods

-(void)webViewDidStartLoad:(UIWebView *)webView
{
  //NSLog(@"Start Load");
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
  
  [self.tab setTitle:title];
  [self updateDelegates:TitleChanged];
}

#pragma mark - Handle Own Delegates
-(void)updateDelegates:(UpdateChanges)changes
{
  //NSLog(@"DVC updating with: %u",changes);
  [self.delegates makeObjectsPerformSelector:@selector(detailViewDidUpdate:) withUpdateChanges:changes];
}

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  return NO;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  self.navBar.hidesBackButton = YES;
  [self.cancelButton setHidden:NO];
  [self.moreButton setHidden:YES];
  CGRect frame = self.controlView.frame;
  NSLog(@"view: ( %3.0f, %3.0f) %3.0f x %3.0f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
  frame.origin.x = 0.0;
  frame.size.width = [[UIScreen mainScreen] bounds].size.width;
  [self.controlView setFrame:frame];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
  self.navBar.hidesBackButton = NO;
  [self.cancelButton setHidden:YES];
  [self.moreButton setHidden:NO];
  CGRect frame = self.cancelButton.frame;
  frame.size.width = 0.0;
  [self.cancelButton setFrame:frame];
  [self navigateWithString:textField.text];
}

@end
