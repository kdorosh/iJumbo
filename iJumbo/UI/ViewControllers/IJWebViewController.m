//
//  IJWebViewController.m
//  iJumbo
//
//  Created by Amadou Crookes on 8/19/14.
//  Copyright (c) 2014 Amadou.It. All rights reserved.
//

#import "IJWebViewController.h"

static const CGFloat kBottomBarHeight = 45;

@interface IJWebViewController () <UIWebViewDelegate>
@property(nonatomic) UIWebView *webView;
@property(nonatomic) NSString *url;
@property(nonatomic) UIActivityIndicatorView *activityIndicator;
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
  // TODO(amadou): Lolz - change this.
  self.view.backgroundColor =
      [UIColor colorWithPatternImage:[UIImage imageNamed:@"bling+dou.png"]];
  self.activityIndicator =
      [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
  UIBarButtonItem * barButton =
      [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
  [self navigationItem].rightBarButtonItem = barButton;
  [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
  [self.view addSubview:_webView];
}

- (void)viewDidAppear:(BOOL)animated {
  [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
  [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
  [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  [self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  [self.activityIndicator stopAnimating];
}

@end
