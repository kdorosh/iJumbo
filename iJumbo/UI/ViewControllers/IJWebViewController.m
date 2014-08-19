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
  _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.maxY, self.view.frame.size.width, self.view.frame.size.height)];
  _webView.delegate = self;
  _webView.backgroundColor = [UIColor clearColor];
  // TODO(amadou): Lolz - change this.
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bling+dou.png"]];
  [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
  [self.view addSubview:_webView];
}

@end
