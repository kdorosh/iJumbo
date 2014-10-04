//
//  IJWebViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/19/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJWebViewController.h"

@interface IJWebViewController () <UIWebViewDelegate>
@property(nonatomic) UIWebView *webView;
@property(nonatomic) NSString *url;
@property(nonatomic) UIActivityIndicatorView *activityIndicator;
@property(nonatomic) UIBarButtonItem *forwardButton;
@property(nonatomic) UIBarButtonItem *backButton;
@end

@implementation IJWebViewController

- (instancetype)initWithURL:(NSString *)url {
  self = [super init];
  if (self) {
    self.url = url;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.edgesForExtendedLayout = UIRectEdgeNone;
  self.navigationController.toolbar.tintColor = [UIColor whiteColor];
  self.navigationController.toolbar.barTintColor = kIJumboBlue;
  _webView =
      [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.navigationController.navigationBar.maxY - self.navigationController.toolbar.height)];
  _webView.delegate = self;
  _webView.backgroundColor = [UIColor clearColor];
  _webView.scalesPageToFit = YES;
  self.view.backgroundColor = [UIColor lightGrayColor];
  self.activityIndicator =
      [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
  UIBarButtonItem * barButton =
      [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
  [self navigationItem].rightBarButtonItem = barButton;
  [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
  [self.view addSubview:_webView];
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
                                                  target:self
                                                  action:@selector(webViewForwardAction)];
  
  spacing.width = self.navigationController.toolbar.width - (2 * leftArrow.size.width) - (2 * 22);
  [self setToolbarItems:@[self.backButton, spacing, self.forwardButton]];
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

- (void)viewWillDisappear:(BOOL)animated {
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
