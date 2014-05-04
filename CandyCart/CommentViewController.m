//
//  CommentViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/29/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()

@end

@implementation CommentViewController
@synthesize postID;
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
    scroller = [MGScrollView scroller];
    scroller.frame = [[DeviceClass instance] getResizeScreen:NO];
    scroller.delegate = self;
    scroller.alwaysBounceVertical = YES;
    scroller.bottomPadding = 8;
    [self.view addSubview:scroller];
    
    
    UIButton *post = [UIButton buttonWithType:UIButtonTypeCustom];
    post.frame = CGRectMake(self.view.frame.size.width - 69, 8, 63, 30);
    post.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [post setTitle:NSLocalizedString(@"product_review_compose_btn", nil) forState:UIControlStateNormal];
    [post addTarget:self
                 action:@selector(postBtnAction)
       forControlEvents:UIControlEventTouchDown];
    
    [post setNuiClass:@"UiBarButtonItem"];
    [post.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithCustomView:post];
    self.navigationItem.rightBarButtonItem = button;

    
    
    [self createView];
     
}

-(void)postBtnAction{
    if([[UserAuth instance] checkUserAlreadyLogged] == YES)
    {
        
        DEComposeViewController *composeVC = [[DEComposeViewController alloc] init];
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        
        composeVC.title = NSLocalizedString(@"product_review_compose_title", nil);
      
        [self presentViewController:composeVC animated:YES completion:nil];
        
        
    DEComposeViewControllerCompletionHandler completionHandler = ^(DEComposeViewControllerResult result, NSString* message, UIImage* image, NSString* lat, NSString* lon,float starRating) {
        switch (result) {
            case DEComposeViewControllerResultCancelled:
                NSLog(@"Note Result: Cancelled");
                [self dismissViewControllerAnimated:YES completion:nil];
                break;
            case DEComposeViewControllerResultDone:
                NSLog(@"Note Result: Done %f",starRating);
                
                if([message length] > 0)
                {
                    [self dismissViewControllerAnimated:YES completion:^{
                    
                        
                        HUD = [[MBProgressHUD alloc] initWithView:[[MainViewClass instance] getCurrentMainWindow]];
                        [[[MainViewClass instance] getCurrentMainWindow] addSubview:HUD];
                        
                        HUD.delegate = self;
                        
                        
                        [HUD showWhileExecuting:@selector(commentExe:) onTarget:self withObject:[NSArray arrayWithObjects:message,[NSString stringWithFormat:@"%f",starRating], nil] animated:YES];
                    
                    }];
                    
                    
                    
                    
                
                }
                else{
                    
                    composeVC.sendButton.enabled = YES;
                }
                                
                break;
        }
        
    };
      composeVC.completionHandler = completionHandler;
    
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"product_review_alert_title", nil)
                                                       message: NSLocalizedString(@"product_review_alert_error_content", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"product_review_alert_ok_button", nil),nil];
        
        
        [alert show];

    }
}


-(void)commentExe:(NSArray*)array{
    
    
    
   [self postcomment:[array objectAtIndex:0] andStarRating:[[array objectAtIndex:1] floatValue]];
    
}

-(void)postcomment:(NSString*)message andStarRating:(float)starRating{
    
    
    
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:message forKey:@"comment"];
    [data setValue:@"0" forKey:@"comment_parent"];
    [data setValue:postID forKey:@"postID"];
    [data setValue:[NSString stringWithFormat:@"%.1f",starRating] forKey:@"starRating"];
    NSDictionary *dic = [[DataService instance] post_comment:[UserAuth instance].username password:[UserAuth instance].password arg:data];
    if([[dic objectForKey:@"status"] intValue] == 0)
    {
         //So mean Every time people add new comment, they always follow thier own comment...
        [[DataService instance] comment_follow:[UserAuth instance].username password:[UserAuth instance].password commentID:[dic objectForKey:@"commentID"]  type:@"follow"];
       
        [scroller.boxes removeAllObjects];
        [self createView];
         [scroller layoutWithSpeed:0.3 completion:nil];
    }
}

-(void)createView{
    
    [self spinner];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        productReview = [[DataService instance] getProductReview:postID parent:@"0"];
                
        
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            NSArray *reviews = [productReview objectForKey:@"comments"];
            if([reviews count] > 0)
            {
            for(int i=0;i<[reviews count];i++)
            {
                NSDictionary *review = [reviews objectAtIndex:i];
                int childCount = 0;
                for(int x= 0;x<[(NSArray*)[[review objectForKey:@"childs"] objectForKey:@"comments"] count];x++)
                {
                    childCount++;
                }
                
                [self shortDesc:[[review objectForKey:@"author"] objectForKey:@"author_name"] desc:[review objectForKey:@"content"] imgUrl:[[review objectForKey:@"author"] objectForKey:@"avatar"] timeAgo:[review objectForKey:@"ago"] repliedNumber:childCount rating:[[review objectForKey:@"rating"] floatValue] child:[review objectForKey:@"childs"]];
            }
            }
            else
            {
                [self noCommentBox];
            }
            [scroller layoutWithSpeed:0.3 completion:nil];
            
            [spinner removeFromSuperview];
        });
        
    });

}

-(void)spinner{
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(150, 70, 24, 24);
    spinner.hidesWhenStopped = YES;
    
    [self.view addSubview:spinner];
    
    [spinner startAnimating];
}

-(void)shortDesc:(NSString*)title desc:(NSString*)desc imgUrl:(NSString*)imageUrl timeAgo:(NSString*)timeAgo repliedNumber:(int)repliedCount rating:(float)rating child:(NSDictionary*)childs
{
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    [scroller.boxes addObject:section];
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
   
    
    
    PhotoBox *head = [PhotoBox reviewHeader:CGSizeMake(280, 50) username:title imgUrl:imageUrl rating:rating];
    head.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [section.topLines addObject:head];
    head.layer.borderColor = nil;
    head.layer.borderWidth = 0;
    
    
    
    

    
    id body = [NSString stringWithFormat:@"%@",desc];
    
    
    
    // stuff
    MGLineStyled *line = [MGLineStyled multilineWithText:body font:nil width:300
                                                 padding:UIEdgeInsetsMake(0, 10, 5, 10)];
    line.backgroundColor = [UIColor clearColor];
    line.borderStyle &= ~MGBorderEtchedBottom;
    [section.topLines addObject:line];
    
    
  
    
   
    MGLineStyled
    *triggers = [MGLineStyled lineWithLeft:nil
                                     right:[NSString stringWithFormat:@"%@ . %d %@",timeAgo,repliedCount,NSLocalizedString(@"product_review_replied_lbl", nil)] size:CGSizeMake(300, 29)];
    triggers.font = [UIFont fontWithName:PRIMARYFONT size:12];
    [section.topLines addObject:triggers];
    
    
    section.onTap = ^{
        
        if(ENABLE_MULTILEVEL_COMMENT > 1)
        {
        ChildCommentViewController *child = [[ChildCommentViewController alloc] init];
        child.child = childs;
        child.title = NSLocalizedString(@"product_review_child_view_controller_title", nil);
        [self.navigationController pushViewController:child animated:YES];
        }
    };
}



-(void)noCommentBox
{
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    [scroller.boxes addObject:section];
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    
    
    
    id body = NSLocalizedString(@"product_review_no_comment", nil);
    
    
    
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
