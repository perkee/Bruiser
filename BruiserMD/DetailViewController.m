//
//  DetailViewController.m
//  BruiserMD
//
//  Created by perkee on 3/17/13.
//  Copyright (c) 2013 perkee. All rights reserved.
//

#import "DetailViewController.h"
#define BUTTONWIDTH  ((CGFloat)45.0)
#define BUTTONHEIGHT ((CGFloat)45.0)


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
    self.mainWebView = [UIWebView new];
    
    NSLog(@"initWithCode");
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
    // Update the view.
    NSLog(@"setTab");
    //[self configureView];
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
    //set delegates
    [self.urlField setDelegate:self];
    [self.mainWebView setDelegate:self];
    
    self.urlField.text = [self.tab urlString];
    //NSLog(@"ConfigureView:%@",self.urlField.text);
    [self textFieldDidEndEditing:self.urlField];
  }
  else
  {
    NSLog(@"BAD ConfigureView!!");
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  NSLog(@"viewDidLoad");
  [self configureView];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Web Navigation

- (void)navigate
{
  //NSLog(@"Navigate:     %@",[self.tab url]);
  [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[self.tab url]]];
}
-(void)navigateWithURL:(NSURL *)url
{
  //NSLog(@"Navigate url: %@",url);
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
  //NSLog(@"Navigate to:  %@",string);
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

#pragma mark - UI Methods
-(IBAction)cancel:(id)sender
{
  NSLog(@"Cancel");
  [self.urlField setText:@""];
  [self textFieldDidEndEditing:self.urlField];
}

- (IBAction)more:(id)sender
{
  NSLog(@"More");
}

#pragma mark - WebView Delegate Methods

-(void)webViewDidStartLoad:(UIWebView *)webView
{
  NSLog(@"Start Load");
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
  const CGFloat buttonWidth  = BUTTONWIDTH;
  const CGFloat buttonHeight = BUTTONHEIGHT;
  
  //Hide Normal buttons, only show "Cancel"
  self.navBar.hidesBackButton = YES;
  [self.cancelButton setHidden:NO];
  [self.moreButton setHidden:YES];
  
  CGRect controlFrame = self.controlView.frame;
  
  CGRect urlFrame = self.urlField.frame;
  CGRect moreFrame    = self.moreButton.frame;
  CGRect cancelFrame  = self.cancelButton.frame;
  NSLog(@"Unmodified:\n%@ : %@\n    %@ : %@\n   %@ : %@\n %@ : %@",
        @"Control",[Debug printRect:controlFrame],
        @"URL"    ,[Debug printRect:urlFrame],
        @"more"   ,[Debug printRect:moreFrame],
        @"cancel" ,[Debug printRect:cancelFrame]
        );
  
  //resize control view
  controlFrame.size.width = [[UIScreen mainScreen] bounds].size.width - 20; //screen padding
  controlFrame.origin.x = 0.0;
  [self.controlView setFrame:controlFrame];
  
  //hide more button
  moreFrame.size.width  = 0;
  moreFrame.size.height = 0;
  moreFrame.origin.x    = controlFrame.size.width;
  [self.moreButton setFrame:moreFrame];
  
  //resize URL frame
  urlFrame.size.width = controlFrame.size.width - buttonWidth;
  [self.urlField setFrame:urlFrame];
  
  //show cancel button
  cancelFrame.size.width  = buttonWidth;
  cancelFrame.size.height = buttonHeight;
  cancelFrame.origin.x    = controlFrame.size.width - buttonWidth;
  [self.cancelButton setFrame:cancelFrame];
  
  NSLog(@"Modified:\n%@ : %@\n    %@ : %@\n   %@ : %@\n %@ : %@",
        @"Control",[Debug printRect:controlFrame],
        @"URL"    ,[Debug printRect:urlFrame],
        @"more"   ,[Debug printRect:moreFrame],
        @"cancel" ,[Debug printRect:cancelFrame]
        );
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
  const CGFloat buttonWidth  = BUTTONWIDTH;
  const CGFloat buttonHeight = BUTTONHEIGHT;
  //Show normal buttons, hide "Cancel"
  
  self.navBar.hidesBackButton = NO;
  [self.cancelButton setHidden:YES];
  [self.moreButton setHidden:NO];
  
  CGRect controlFrame = self.controlView.frame;
  
  CGRect urlFrame = self.urlField.frame;
  CGRect moreFrame    = self.moreButton.frame;
  CGRect cancelFrame  = self.cancelButton.frame;
  NSLog(@"Unmodified:\n%@ : %@\n    %@ : %@\n   %@ : %@\n %@ : %@",
        @"Control",[Debug printRect:controlFrame],
        @"URL"    ,[Debug printRect:urlFrame],
        @"more"   ,[Debug printRect:moreFrame],
        @"cancel" ,[Debug printRect:cancelFrame]
        );
  
  //resize control view
  controlFrame.size.width = [[UIScreen mainScreen] bounds].size.width - 70.00; //about width of "Tabs" button
  controlFrame.origin.x = 0.0;
  [self.controlView setFrame:controlFrame];
  
  //move more button
  moreFrame.size.width  = buttonWidth;
  moreFrame.size.height = buttonHeight;
  moreFrame.origin.x    = controlFrame.size.width - buttonWidth;
  [self.moreButton setFrame:moreFrame];
  
  //resize URL frame
  urlFrame.size.width = controlFrame.size.width - buttonWidth;
  [self.urlField setFrame:urlFrame];
  
  //hide cancel button
  cancelFrame.size.width  = 0;
  cancelFrame.size.height = 0;
  [self.cancelButton setFrame:cancelFrame];
  
  NSLog(@"Modified:\n%@ : %@\n    %@ : %@\n   %@ : %@\n %@ : %@",
        @"Control",[Debug printRect:controlFrame],
        @"URL"    ,[Debug printRect:urlFrame],
        @"more"   ,[Debug printRect:moreFrame],
        @"cancel" ,[Debug printRect:cancelFrame]
        );

  //navigate to wherever was typed
  if([textField.text length] != 0)
  {
    [self navigateWithString:textField.text];
  }
  else
  {
    [textField setText:[self.tab urlString]];
  }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController
     willHideViewController:(UIViewController *)viewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)popoverController
{
  barButtonItem.title = NSLocalizedString(@"Master", @"Master");
  [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
  self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController
     willShowViewController:(UIViewController *)viewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
  // Called when the view is shown again in the split view, invalidating the button and popover controller.
  [self.navigationItem setLeftBarButtonItem:nil animated:YES];
  self.masterPopoverController = nil;
}


@end
