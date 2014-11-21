//
//  IJWebViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/19/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJWebViewController.h"

#import "OpenInChromeController.h"

#import "UIColor+iJumboColors.h"

static NSString * const kActionSheetButtonTitleOpenInSafari = @"Open in Safari";
static NSString * const kActionSheetButtonTitleOpenInChrome = @"Open in Chrome";
static NSString * const kActionSheetButtonTitleCopyLink     = @"Copy Link";

@interface IJWebViewController () <UIWebViewDelegate, UIActionSheetDelegate>
@property(nonatomic) UIWebView *webView;
@property(nonatomic) NSString *url;
@property(nonatomic) UIActivityIndicatorView *activityIndicator;
@property(nonatomic) UIBarButtonItem *forwardButton;
@property(nonatomic) UIBarButtonItem *backButton;
@end

@implementation IJWebViewController

+ (IJWebViewController *)sharedInstance {
  static IJWebViewController* webVC = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    webVC = [[IJWebViewController alloc] initWithURL:@"about:blank"];
  });
  return webVC;
}

+ (IJWebViewController *)defaultInstanceWithURL:(NSString *)url {
  IJWebViewController *webVC = [self sharedInstance];
  [webVC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
  webVC.url = url;
  [webVC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webVC.url]]];
  return webVC;
}

- (instancetype)initWithURL:(NSString *)url {
  self = [super init];
  if (self) {
    self.url = url;
  }
  return self;
}

- (BOOL)shouldAutorotate {
  return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskPortrait |
         UIInterfaceOrientationLandscapeLeft |
         UIInterfaceOrientationLandscapeRight;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.edgesForExtendedLayout = UIRectEdgeNone;
  self.navigationController.toolbar.tintColor = [UIColor whiteColor];
  self.navigationController.toolbar.barTintColor = [UIColor iJumboBlue];
  _webView =
      [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.navigationController.navigationBar.maxY - self.navigationController.toolbar.height)];
  _webView.delegate = self;
  _webView.backgroundColor = [UIColor clearColor];
  _webView.scalesPageToFit = YES;
  self.view.backgroundColor = [UIColor transparentWhiteBackground];
  self.activityIndicator =
      [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
  UIBarButtonItem * barButton =
      [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
  [self navigationItem].rightBarButtonItem = barButton;
  [self.view addSubview:_webView];
  [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)viewDidAppear:(BOOL)animated {
  UIImage *leftArrow = [UIImage imageNamed:@"previous_arrow"];
  self.backButton =
      [[UIBarButtonItem alloc] initWithImage:leftArrow
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(webViewBackAction)];
  self.backButton.enabled = NO;
  self.forwardButton =
      [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"next_arrow"]
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(webViewForwardAction)];
  self.forwardButton.enabled = NO;
  UIBarButtonItem *spacing =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                    target:nil
                                                    action:nil];
  UIBarButtonItem *firstSpace =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                    target:nil
                                                    action:nil];
  
  UIBarButtonItem *reload =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                    target:self.webView
                                                    action:@selector(reload)];
  
  // Share on safari, copy link, chrome if on phone.
  UIBarButtonItem *options =
      [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Upload.png"]
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(showWebOptions)];
  const CGFloat spaceFifth = self.navigationController.toolbar.width/7.0f;
  spacing.width = spaceFifth;
  firstSpace.width = 30;
  [self setToolbarItems:@[firstSpace, self.backButton, spacing, self.forwardButton, spacing, reload, spacing, options]];
}

- (void)webViewBackAction {
  if ([self.webView canGoBack]) {
    [self.webView goBack];
  }
}

- (void)webViewForwardAction {
  if ([self.webView canGoForward]) {
    [self.webView goForward];
  }
}

- (void)showWebOptions {
  UIActionSheet *actionSheet =
      [[UIActionSheet alloc] initWithTitle:@"Options"
                                  delegate:self
                         cancelButtonTitle:@"Cancel"
                    destructiveButtonTitle:nil
                         otherButtonTitles:nil];
  [actionSheet addButtonWithTitle:kActionSheetButtonTitleOpenInSafari];
  if ([[OpenInChromeController sharedInstance] isChromeInstalled]) {
    [actionSheet addButtonWithTitle:kActionSheetButtonTitleOpenInChrome];
  }
  [actionSheet addButtonWithTitle:@"Copy Link"];
  [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
  if ([buttonTitle isEqualToString:kActionSheetButtonTitleOpenInSafari]) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.url]];
  } else if ([buttonTitle isEqualToString:kActionSheetButtonTitleCopyLink]) {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    [pasteBoard setString:self.url];
  } else if ([buttonTitle isEqualToString:kActionSheetButtonTitleOpenInChrome]) {
    [[OpenInChromeController sharedInstance] openInChrome:[NSURL URLWithString:self.url]];
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  if ([IJWebViewController sharedInstance] == self && [self.webView isLoading]) {
    [self.webView stopLoading];
  }
  [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
  [self.navigationController setToolbarHidden:NO animated:NO];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
  [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  [self.activityIndicator stopAnimating];
  [self enableBackForwardButtons];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  [self.activityIndicator stopAnimating];
  [self enableBackForwardButtons];
}

- (void)enableBackForwardButtons {
  self.backButton.enabled = [self.webView canGoBack];
  self.forwardButton.enabled = [self.webView canGoForward];
}

@end
