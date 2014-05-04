//
//  ReadMoreViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/26/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "ReadMoreViewController.h"

@interface ReadMoreViewController ()

@end

@implementation ReadMoreViewController

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
    [self.view setNuiClass:@"ViewInit"];
	// Do any additional setup after loading the view.
    
    /*
    
    if(hasAttribute == YES)
    {
        
        
        
    NSArray *ary = [NSArray arrayWithObjects:NSLocalizedString(@"product_detail_read_more_desc", nil),NSLocalizedString(@"product_detail_read_more_additional_inf", nil), nil];
    segmentedControl = [[SDSegmentedControl alloc] initWithItems:ary];
    segmentedControl.frame = CGRectMake(0, 0, 320, 50);
    segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(valueChanged) forControlEvents: UIControlEventValueChanged];
    [segmentedControl setNuiClass:@"Button:TopTabButton"];
    
    [self.view addSubview:segmentedControl];

        [self ifHasAttributeDescription];
        [self ifHasAttributeAdditional];
        
        
        
        firstView.hidden = NO;
        secondView.hidden = YES;
    }
    else
    {
        webViewC = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 490)];
        
        NSString *resources = [[NSBundle mainBundle] resourcePath];
        NSURL *baseURL = [NSURL fileURLWithPath:resources];
         NSString *myHTML = [NSString stringWithFormat:@"<script src='%@'></script><script src='%@'></script><script src='%@'></script><script src='%@'></script><script src='%@'></script><script src='%@'></script><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'> <style type=\"text/css\">body {background-color: transparent; padding:10px; font-family: \"%@\"; font-size: %@;} img{ width:100%%; height:auto; }</style><body>%@<br><br><br></body>",JQUERY,BOOTSTRAP_JS,CUSTOM_JS,SWIPER_JS,SWIPER_JS_SCROLLBAR,SWIPER_JS_3D_FLOW,BOOTSTRAP_CSS,BOOTSTRAP_THEME,CUSTOM_CSS,SWIPER_CSS,SWIPER_CSS_SCROLLBAR,SWIPER_CSS_3D,PRIMARYFONT,GENERAL_UIWEBVIEW_FONT_SIZE,[[ToolClass instance] decodeHTMLCharacterEntities:html]];
        
        
        [webViewC loadHTMLString:myHTML baseURL:baseURL];
        [self.view addSubview:webViewC];
    }
     */
    
    webViewC = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 490)];
    
    NSString *resources = [[NSBundle mainBundle] resourcePath];
    NSURL *baseURL = [NSURL fileURLWithPath:resources];
    NSString *myHTML = [NSString stringWithFormat:@"<script src='%@'></script><script src='%@'></script><script src='%@'></script><script src='%@'></script><script src='%@'></script><script src='%@'></script><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'> <style type=\"text/css\">body {background-color: transparent; padding:10px; font-family: \"%@\"; font-size: %@;} img{ width:100%%; height:auto; }</style><body>%@<br><br><br></body>",JQUERY,BOOTSTRAP_JS,CUSTOM_JS,SWIPER_JS,SWIPER_JS_SCROLLBAR,SWIPER_JS_3D_FLOW,BOOTSTRAP_CSS,BOOTSTRAP_THEME,CUSTOM_CSS,SWIPER_CSS,SWIPER_CSS_SCROLLBAR,SWIPER_CSS_3D,PRIMARYFONT,GENERAL_UIWEBVIEW_FONT_SIZE,[[ToolClass instance] decodeHTMLCharacterEntities:html]];
    
    
    [webViewC loadHTMLString:myHTML baseURL:baseURL];
    [self.view addSubview:webViewC];
    
    for(UIView *wview in [[[webViewC subviews] objectAtIndex:0] subviews]) {
        if([wview isKindOfClass:[UIImageView class]]) { wview.hidden = YES; }
    }
    webViewC.backgroundColor = [UIColor clearColor];
    webViewC.delegate = self;
    webViewC.scrollView.delegate = self;
    [webViewC setOpaque:NO];
}

-(void)valueChanged{
  
    
    if(segmentedControl.selectedSegmentIndex == 1)
    {
        firstView.hidden = YES;
        secondView.hidden = NO;
    }
    else if(segmentedControl.selectedSegmentIndex == 0)
    {
        firstView.hidden = NO;
        secondView.hidden = YES;
    }
        
    
}

-(void)ifHasAttributeDescription{
    firstView = [[UIView alloc] initWithFrame:[[DeviceClass instance] getResizeScreen:YES]];
    
    webViewC = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, firstView.frame.size.width, firstView.frame.size.height)];
    
    NSString *resources = [[NSBundle mainBundle] resourcePath];
    NSURL *baseURL = [NSURL fileURLWithPath:resources];
    
    NSString *myHTML = [NSString stringWithFormat:@"<script src='%@'></script><script src='%@'></script><script src='%@'></script><script src='%@'></script><script src='%@'></script><script src='%@'></script><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'> <style type=\"text/css\">body {background-color: transparent; padding:10px; font-family: \"%@\"; font-size: %@;} img{ width:100%%; height:auto; }</style><body>%@<br><br><br></body>",JQUERY,BOOTSTRAP_JS,CUSTOM_JS,SWIPER_JS,SWIPER_JS_SCROLLBAR,SWIPER_JS_3D_FLOW,BOOTSTRAP_CSS,BOOTSTRAP_THEME,CUSTOM_CSS,SWIPER_CSS,SWIPER_CSS_SCROLLBAR,SWIPER_CSS_3D,PRIMARYFONT,GENERAL_UIWEBVIEW_FONT_SIZE,[[ToolClass instance] decodeHTMLCharacterEntities:html]];
    
    [webViewC loadHTMLString:myHTML baseURL:baseURL];
    [firstView addSubview:webViewC];
    
    [self.view addSubview:firstView];
    
}


-(void)ifHasAttributeAdditional{
    secondView = [[UIView alloc] initWithFrame:[[DeviceClass instance] getResizeScreen:YES]];
    [self ifHasAttributeAdditionalContent];
    [self.view addSubview:secondView];
    
}

-(void)ifHasAttributeAdditionalContent{
    
    CGRect se = [[DeviceClass instance] getResizeScreen:YES];
    scroller = [MGScrollView scroller];
    scroller.frame = CGRectMake(0, 1, se.size.width, se.size.height);
    scroller.delegate = self;
    scroller.alwaysBounceVertical = YES;
    scroller.bottomPadding = 8;
    [secondView addSubview:scroller];
    
    
    NSNumber *has_attribute = (NSNumber *)[[productInfo objectForKey:@"attributes"] objectForKey:@"has_attributes"];
    
    NSNumber *has_weight = (NSNumber *)[[[productInfo objectForKey:@"shipping"] objectForKey:@"weight"] objectForKey:@"has_weight"];
    NSNumber *has_dimension = (NSNumber *)[[[productInfo objectForKey:@"shipping"] objectForKey:@"dimension"] objectForKey:@"has_dimension"];
    
    if([has_weight boolValue] == TRUE)
    {
    [self shortDesc:NSLocalizedString(@"product_detail_read_more_has_weight_title", nil) desc:[NSString stringWithFormat:@"%@ %@",[[[productInfo objectForKey:@"shipping"] objectForKey:@"weight"] objectForKey:@"value"],[[[productInfo objectForKey:@"shipping"] objectForKey:@"weight"] objectForKey:@"unit"]]];
    }
    
    if([has_dimension boolValue] == TRUE)
    {
        
        [self shortDesc:NSLocalizedString(@"product_detail_read_more_has_dimension_title", nil) desc:[NSString stringWithFormat:@"%@ x %@ x %@ %@",
            [[[productInfo objectForKey:@"shipping"] objectForKey:@"dimension"] objectForKey:@"value_l"],
            [[[productInfo objectForKey:@"shipping"] objectForKey:@"dimension"] objectForKey:@"value_w"],
            [[[productInfo objectForKey:@"shipping"] objectForKey:@"dimension"] objectForKey:@"value_h"],
            [[[productInfo objectForKey:@"shipping"] objectForKey:@"dimension"] objectForKey:@"unit"]                                                                                          
            ]];
    }
    
    if([has_attribute boolValue] == TRUE)
    {
        NSArray *ary = [[productInfo objectForKey:@"attributes"] objectForKey:@"attributes"];
        for(int i=0;i<[ary count];i++)
        {
            NSDictionary *dic = [ary objectAtIndex:i];
            
            
            if([[dic objectForKey:@"is_visible"] intValue] == 1)
            {
                NSArray *value = [dic objectForKey:@"value"];
                NSMutableArray *change = [[NSMutableArray alloc] init];
                for(int x=0;x<[value count];x++)
                {
                    NSDictionary *valueDic = [value objectAtIndex:x];
                    [change addObject:[valueDic objectForKey:@"term"]];
                }
                
                NSString * result = [change componentsJoinedByString:@","];
                if([dic objectForKey:@"label"] != [NSNull null])
                {
                    [self shortDesc:[dic objectForKey:@"label"] desc:result];
                }
                else
                {
                [self shortDesc:[dic objectForKey:@"slug"] desc:result];
                }
            }
        }
    }
    
    [scroller layoutWithSpeed:0.3 completion:nil];
    
}

-(void)shortDesc:(NSString*)title desc:(NSString*)desc
{
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    [scroller.boxes addObject:section];
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    
    
    MGLineStyled *head = [MGLineStyled lineWithLeft:title
                                              right:nil size:CGSizeMake(300, 23)];
    head.padding = UIEdgeInsetsMake(20, 10, 10, 10);
    head.borderStyle &= ~MGBorderEtchedBottom;
    [section.topLines addObject:head];
    head.font = [UIFont fontWithName:BOLDFONT size:14];
    
    
    id body = [NSString stringWithFormat:@"%@",desc];
    
    
    
    // stuff
    MGLineStyled *line = [MGLineStyled multilineWithText:body font:nil width:300
                                                 padding:UIEdgeInsetsMake(10, 10, 10, 10)];
    line.backgroundColor = [UIColor clearColor];
    line.borderStyle &= ~MGBorderEtchedBottom;
    [section.topLines addObject:line];
    
    
    
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    initialContentOffset = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [[SettingDataClass instance] autoHideGlobal:scrollView navigationView:self.navigationController contentOffset:initialContentOffset];
    
    
    
}

-(void)setFullDescString:(NSString*)string andHasAttribute:(BOOL)has andProductInfo:(NSDictionary*)productInfos{
    
    html = [[ToolClass instance] decodeHTMLCharacterEntities:string];
    hasAttribute = has;
    productInfo = productInfos;
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
