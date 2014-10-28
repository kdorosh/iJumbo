//
//  RKDropdownAlert.m
//  SlingshotDropdownAlert
//
//  Created by Richard Kim on 8/26/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//

#import "RKDropdownAlert.h"

static int HEIGHT = 80; //height of the alert view
static float ANIMATION_TIME = .36; //time it takes for the animation to complete in seconds
static int X_BUFFER = 10; //buffer distance on each side for the text
static int Y_BUFFER = 10; //buffer distance on top/bottom for the text
static int TIME = 3; //default time in seconds before the view is hidden
static int STATUS_BAR_HEIGHT = 20;
static int FONT_SIZE = 14;
NSString *DEFAULT_TITLE;

@implementation RKDropdownAlert{
    UILabel *titleLabel;
    UILabel *messageLabel;
}
@synthesize defaultTextColor;
@synthesize defaultViewColor;

//////////////////////////////////////////////////////////
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%%%%%%%%%%%%%       customizable       %%%%%%%%%%%%%%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

//%%% customize this to be whatever you want!
-(void)setupDefaultAttributes
{
    defaultViewColor = kIJumboBlue;
  
    defaultTextColor = [UIColor whiteColor];
    DEFAULT_TITLE = @"Default Text Here"; //%%% this text can only be edited if you do not use the pod solution. check the repo's README for more information
    
    //%%% to change the default time, height, animation speed, fonts, etc check the top of the this file
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaultAttributes];
        
        self.backgroundColor = defaultViewColor;
        
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(X_BUFFER, STATUS_BAR_HEIGHT, frame.size.width-2*X_BUFFER, 30)];
        [titleLabel setFont:[UIFont regularFontWithSize:FONT_SIZE]];
        titleLabel.textColor = defaultTextColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(X_BUFFER, STATUS_BAR_HEIGHT +Y_BUFFER*2.3, frame.size.width-2*X_BUFFER, 40)];
        messageLabel.textColor = defaultTextColor;
        messageLabel.font = [UIFont lightFontWithSize:FONT_SIZE - 2];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.numberOfLines = 2; // 2 lines ; 0 - dynamic number of lines
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:messageLabel];
        
        [self addTarget:self action:@selector(hideView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


//%%% button method (what happens when you touch the drop down view)
-(void)viewWasTapped:(UIButton *)alertView
{
  
    /*
     eg: say you have a messaging component in your app and someone sends a message to the user. Here is where you would write the method that takes the user to the conversation with the person that sent them the message
     */
    
    //%%% this hides the view, you can remove this if you don't want the view to disappear on tap
    [self hideView:alertView];
}

-(void)hideView:(UIButton *)alertView
{
    if (alertView) {
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            CGRect frame = alertView.frame;
            frame.origin.y = -HEIGHT;
            alertView.frame = frame;
        }];
        [self performSelector:@selector(removeView:) withObject:alertView afterDelay:ANIMATION_TIME];
    }
}

-(void)removeView:(UIButton *)alertView
{
    if (alertView){
        [alertView removeFromSuperview];
    }
}

//
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%%%%%%%%%%%%%       customizable        %%%%%%%%%%%%%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%%%%%%%%%%%%%          Ignore          %%%%%%%%%%%%%%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
//%%% these are necessary methods that call each other depending on which method you call. Generally shouldn't edit these unless you know what you're doing


+(RKDropdownAlert*)alertView
{
    RKDropdownAlert *alert = [[self alloc]initWithFrame:CGRectMake(0, -HEIGHT, [[UIScreen mainScreen]bounds].size.width, HEIGHT)];
    return alert;
}

//%%% shows all the default stuff
+(void)show
{
    [[self alertView]title:DEFAULT_TITLE message:nil backgroundColor:nil textColor:nil time:-1];
}

+(void)title:(NSString*)title
{
    [[self alertView]title:title message:nil backgroundColor:nil textColor:nil time:-1];
}

+(void)title:(NSString*)title time:(NSInteger)seconds
{
    [[self alertView]title:title message:nil backgroundColor:nil textColor:nil time:seconds];
}

+(void)title:(NSString*)title backgroundColor:(UIColor*)backgroundColor textColor:(UIColor*)textColor
{
    [[self alertView]title:title message:nil backgroundColor:backgroundColor textColor:textColor time:-1];
}

+(void)title:(NSString*)title backgroundColor:(UIColor*)backgroundColor textColor:(UIColor*)textColor time:(NSInteger)seconds
{
    [[self alertView]title:title message:nil backgroundColor:backgroundColor textColor:textColor time:seconds];
}

+(void)title:(NSString*)title message:(NSString*)message
{
    [[self alertView]title:title message:message backgroundColor:nil textColor:nil time:-1];
}

+(void)title:(NSString*)title message:(NSString*)message time:(NSInteger)seconds
{
    [[self alertView]title:title message:message backgroundColor:nil textColor:nil time:seconds];
}

+(void)title:(NSString*)title message:(NSString*)message backgroundColor:(UIColor*)backgroundColor textColor:(UIColor*)textColor
{
    [[self alertView]title:title message:message backgroundColor:backgroundColor textColor:textColor time:-1];
}

+(void)title:(NSString*)title message:(NSString*)message backgroundColor:(UIColor*)backgroundColor textColor:(UIColor*)textColor time:(NSInteger)seconds
{
    [[self alertView]title:title message:message backgroundColor:backgroundColor textColor:textColor time:seconds];
}

-(void)title:(NSString*)title message:(NSString*)message backgroundColor:(UIColor*)backgroundColor textColor:(UIColor*)textColor time:(NSInteger)seconds
{
    NSInteger time = seconds;
    titleLabel.text = title;
    
    if (message) {
        messageLabel.text = message;
        if ([self messageTextIsOneLine]) {
            CGRect frame = titleLabel.frame;
            frame.origin.y = STATUS_BAR_HEIGHT+5;
            titleLabel.frame = frame;
        }
    } else {
        CGRect frame = titleLabel.frame;
        frame.size.height = HEIGHT-2*Y_BUFFER-STATUS_BAR_HEIGHT;
        frame.origin.y = Y_BUFFER+STATUS_BAR_HEIGHT;
        titleLabel.frame = frame;
    }
    
    if (backgroundColor) {
        self.backgroundColor = backgroundColor;
    }
    if (textColor) {
        titleLabel.textColor = textColor;
        messageLabel.textColor = textColor;
    }
    
    if (seconds == -1) {
        time = TIME;
    }
    
    if(!self.superview){
        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
        
        for (UIWindow *window in frontToBackWindows)
            if (window.windowLevel == UIWindowLevelNormal) {
                [window.rootViewController.view addSubview:self];
                break;
            }
    }
    
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        CGRect frame = self.frame;
        frame.origin.y = 0;
        self.frame = frame;
    }];
    
    [self performSelector:@selector(hideView:) withObject:self afterDelay:time+ANIMATION_TIME];
}


-(BOOL)messageTextIsOneLine
{
    CGSize size = [messageLabel.text sizeWithAttributes:
                   @{NSFontAttributeName:
                         [UIFont systemFontOfSize:FONT_SIZE]}];
    if (size.width > messageLabel.frame.size.width) {
        return NO;
    }
    
    return YES;
}

//
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%%%%%%%%%%%%%           Ignore          %%%%%%%%%%%%%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//////////////////////////////////////////////////////////
@end
