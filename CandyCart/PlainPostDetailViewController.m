//
//  PlainPostDetailViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/23/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "PlainPostDetailViewController.h"

@interface PlainPostDetailViewController ()

@end

@implementation PlainPostDetailViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setNuiClass:@"ViewInit"];
    [self loadHtmlIntoWebView];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSString *enableShare = [postInfo objectForKey:@"share_enable"];
    if([enableShare isEqualToString:@"no"])
    {
        
    }
    else
    {
    shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(self.view.frame.size.width - 69, 8, 63, 30);
    shareBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [shareBtn setTitle:NSLocalizedString(@"product_detail_view_share_btn", nil) forState:UIControlStateNormal];
    [shareBtn addTarget:self
                 action:@selector(shareBtnAction)
       forControlEvents:UIControlEventTouchDown];
    
    [shareBtn setNuiClass:@"UiBarButtonItem"];
    [shareBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = button;
    }
    
}

-(void)shareBtnAction{
    
    socialMediaController *menu = [[socialMediaController alloc] init];
    menu.delegate = self;
    [menu setUrl:[postInfo objectForKey:@"permalink"]];
    
    sharePopOver = [[FPPopoverController alloc] initWithViewController:menu];
    sharePopOver.border = YES;
    
    sharePopOver.contentSize = CGSizeMake(170,170);
    [sharePopOver.view setNuiClass:@"DropDownView"];
    
    [sharePopOver presentPopoverFromView:shareBtn];
    
}


-(void)didChooseEmail{
    NSLog(@"Did Choose");
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    
    NSString *emailBody = [postInfo objectForKey:@"permalink"];
    [mailer setMessageBody:emailBody isHTML:NO];
    [self presentViewController:mailer animated:YES completion:nil];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)setPostInfo:(NSDictionary*)postIn{
    
    postInfo = postIn;
}

-(void)loadHtmlIntoWebView{
    
    CGRect webFrame;
    webFrame = [[DeviceClass instance] getResizeScreen:NO];
    webViewSe = [[UIWebView alloc] initWithFrame:webFrame];
    
    webViewSe.delegate = self;
    
    webViewSe.scrollView.delegate = self;
    webViewSe.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    for(UIView *wview in [[[webViewSe subviews] objectAtIndex:0] subviews]) {
        if([wview isKindOfClass:[UIImageView class]]) { wview.hidden = YES; }
    }
    webViewSe.backgroundColor = [UIColor clearColor];
    [webViewSe setOpaque:NO];
    
     NSString *myHTML = [NSString stringWithFormat:@"<script src='%@'></script><script src='%@'></script><script src='%@'></script><script src='%@'></script><script src='%@'></script><script src='%@'></script><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'> <style type=\"text/css\">body {background-color: transparent; padding:10px; font-family: \"%@\"; font-size: %@;} img{ width:100%%; height:auto; }</style><body>%@<br><br><br></body>",JQUERY,BOOTSTRAP_JS,CUSTOM_JS,SWIPER_JS,SWIPER_JS_SCROLLBAR,SWIPER_JS_3D_FLOW,BOOTSTRAP_CSS,BOOTSTRAP_THEME,CUSTOM_CSS,SWIPER_CSS,SWIPER_CSS_SCROLLBAR,SWIPER_CSS_3D,PRIMARYFONT,GENERAL_UIWEBVIEW_FONT_SIZE,[[ToolClass instance] decodeHTMLCharacterEntities:[postInfo objectForKey:@"full_content"]]];
    
    NSString *resources = [[NSBundle mainBundle] resourcePath];
    NSURL *baseURL = [NSURL fileURLWithPath:resources];
    [webViewSe loadHTMLString:myHTML baseURL:baseURL];
    
    [self.view addSubview:webViewSe];
    
    [self createCommentView];
}


-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        
        NSString *myString = [[inRequest URL] absoluteString];
        
        
        
        if ([myString rangeOfString:@"#"].location == NSNotFound) {
            
            HUD = [[MBProgressHUD alloc] initWithView:[[MainViewClass instance] getCurrentMainWindow]];
            [[[MainViewClass instance] getCurrentMainWindow] addSubview:HUD];
            
            HUD.delegate = self;
            
            
            [HUD showWhileExecuting:@selector(checkLink:) onTarget:self withObject:myString animated:YES];
            
        } else {
            return YES;
        }
        
        
        
        
        
        return NO;
    }
    return YES;
}

-(void)checkLink:(NSString*)str{
    
    [[ToolClass instance] checkLink:str navigation:self.navigationController];
    
}


-(void)createCommentView{
    NSString *comment_status = [postInfo objectForKey:@"comment_status"];
    if([comment_status isEqualToString:@"open"])
    {
        UIImageView *commentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 30, 30)];
        commentIcon.image = [UIImage imageNamed:@"commenticon"];
        commentIcon.userInteractionEnabled = YES;
        
        UILabel *comments = [[UILabel alloc] initWithFrame:CGRectMake(260, 440, 50, 50)];
        comments.backgroundColor = [UIColor colorWithRed:210 green:210 blue:210 alpha:1];
        
        comments.userInteractionEnabled = YES;
        comments.font = [UIFont fontWithName:PRIMARYFONT size:13];
        comments.layer.cornerRadius = 25;
        comments.layer.masksToBounds = YES;
        
        comments.layer.borderColor = [UIColor lightGrayColor].CGColor;
        comments.layer.borderWidth = 0.5;
        
        [comments addSubview:commentIcon];
        
        [self.view addSubview:comments];
        
        UITapGestureRecognizer *tapGestureComment = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTap:)];
        [commentIcon addGestureRecognizer:tapGestureComment];
        
    }
}


- (void)commentTap:(UIGestureRecognizer *)gesture {
    
    NSLog(@"Go To Comment");
    
    CommentViewController *comment = [[CommentViewController alloc] init];
    comment.postID = [postInfo objectForKey:@"ID"];
    comment.title = NSLocalizedString(@"product_detail_reviews_btn_title", nil);
    
    [self.navigationController pushViewController:comment animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
