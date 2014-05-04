//
//  RSSFeedControllerViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/26/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "RSSFeedControllerViewController.h"

@interface RSSFeedControllerViewController ()

@end

@implementation RSSFeedControllerViewController

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
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    scroller = [MGScrollView scroller];
    scroller.frame = [[DeviceClass instance] getResizeScreen:NO];
    scroller.delegate = self;
    scroller.bottomPadding = 8;
    [self.view addSubview:scroller];
    [self createView];
}

-(void)createView{
    
    
    for(int i =0;i<[info count];i++)
    {
        NSDictionary *infoAttr = [info objectAtIndex:i];
        [self rssBox:[infoAttr objectForKey:@"title"] shortDesc:[infoAttr objectForKey:@"description"] time:[infoAttr objectForKey:@"pubDate"]  link:[infoAttr objectForKey:@"link"]];
        
    }
    
     [scroller layoutWithSpeed:0.3 completion:nil];
    
}

-(void)setRSSInfo:(NSArray*)setInfo{
    
    info = setInfo;
}

-(void)rssBox:(NSString*)pTitle shortDesc:(NSString*)shortDesc time:(NSString*)time link:(NSString*)link{
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    //HEADER
    id headerBody = [NSString stringWithFormat:@"%@",[[ToolClass instance] decodeHTMLCharacterEntities:pTitle]];
    
    MGLineStyled *header = [MGLineStyled multilineWithText:headerBody font:nil width:300
                                                   padding:UIEdgeInsetsMake(10, 10, 10.0, 10.0)];
    header.backgroundColor = [UIColor clearColor];
    header.font = [UIFont fontWithName:BOLDFONT size:14];
    [section.topLines addObject:header];
    //END HEADER
    
    //TIME AGO
    WpPostBox *timeAgo = [WpPostBox timeAgo:time];
    [section.topLines addObject:timeAgo];
    
    /*
    //HEADER
    id bottomBody = [NSString stringWithFormat:@"%@",[[ToolClass instance] decodeHTMLCharacterEntities:shortDesc]];
    
    MGLineStyled *bottom = [MGLineStyled multilineWithText:bottomBody font:nil width:300
                                                   padding:UIEdgeInsetsMake(10, 10, 10.0, 10.0)];
    bottom.backgroundColor = [UIColor clearColor];
    bottom.font = [UIFont fontWithName:PRIMARYFONT size:11];
    [section.topLines addObject:bottom];
    //END HEADER
    */
    
    section.onTap = ^{
       
        iPhoneWebView *webView = [[iPhoneWebView alloc] init];
        [webView loadUrlInWebView:link];
        [self.navigationController pushViewController:webView animated:YES];
    };
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
