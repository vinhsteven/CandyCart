//
//  ChildCommentViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/30/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "ChildCommentViewController.h"

@interface ChildCommentViewController ()

@end

@implementation ChildCommentViewController

@synthesize child,postID;
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
    
     postID = [child objectForKey:@"postID"];
    
   
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
    [data setValue:[[productReview objectForKey:@"main_comment"] objectForKey:@"comment_id"] forKey:@"comment_parent"];
    [data setValue:postID forKey:@"postID"];
    [data setValue:[NSString stringWithFormat:@"%.1f",starRating] forKey:@"starRating"];
    NSDictionary *dic = [[DataService instance] post_comment:[UserAuth instance].username password:[UserAuth instance].password arg:data];
    if([[dic objectForKey:@"status"] intValue] == 0)
    {
        //So mean Every time people add new comment, they always follow thier own comment...
        [[DataService instance] comment_follow:[UserAuth instance].username password:[UserAuth instance].password commentID:[dic objectForKey:@"commentID"]  type:@"follow"];
        
        [[DataService instance] comment_follow:[UserAuth instance].username password:[UserAuth instance].password commentID:[[productReview objectForKey:@"main_comment"] objectForKey:@"comment_id"]  type:@"follow"];
        
        [scroller.boxes removeAllObjects];
        [self createViewData];
        [scroller layoutWithSpeed:0.3 completion:nil];
    }
}


-(void)createView{
    
    [self spinner];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        productReview = child;
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            //Main
            NSDictionary *mainComment = [productReview objectForKey:@"main_comment"];
             NSArray *reviews = [productReview objectForKey:@"comments"];
            
            [self mainComment:[[mainComment objectForKey:@"author"] objectForKey:@"author_name"] desc:[mainComment objectForKey:@"content"] imgUrl:[[mainComment objectForKey:@"author"] objectForKey:@"avatar"] timeAgo:[mainComment objectForKey:@"ago"] repliedNumber:[reviews count] rating:[[mainComment objectForKey:@"rating"] floatValue]];
            
            //Child
           
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



-(void)createViewData{
    
    [self spinner];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        
        productReview = child;
        
        productReview = [[DataService instance] getProductReview:postID parent:[[productReview objectForKey:@"main_comment"] objectForKey:@"comment_id"]];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            //Main
            NSDictionary *mainComment = [productReview objectForKey:@"main_comment"];
            NSArray *reviews = [productReview objectForKey:@"comments"];
            
            [self mainComment:[[mainComment objectForKey:@"author"] objectForKey:@"author_name"] desc:[mainComment objectForKey:@"content"] imgUrl:[[mainComment objectForKey:@"author"] objectForKey:@"avatar"] timeAgo:[mainComment objectForKey:@"ago"] repliedNumber:[reviews count] rating:[[mainComment objectForKey:@"rating"] floatValue]];
            
            //Child
            
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
        
        if(ENABLE_MULTILEVEL_COMMENT > 2)
        {
        ChildCommentViewController *childView = [[ChildCommentViewController alloc] init];
        childView.child = childs;
        childView.title = NSLocalizedString(@"product_review_child_view_controller_title", nil);
        [self.navigationController pushViewController:childView animated:YES];
        }
    };
}

-(void)mainComment:(NSString*)title desc:(NSString*)desc imgUrl:(NSString*)imageUrl timeAgo:(NSString*)timeAgo repliedNumber:(int)repliedCount rating:(float)rating
{
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    [scroller.boxes addObject:section];
    
    
    
    section.margin = UIEdgeInsetsMake(0, 0, 0.0, 0.0);
    
    
    
    PhotoBox *head = [PhotoBox reviewHeader:CGSizeMake(310, 50) username:title imgUrl:imageUrl rating:rating];
    head.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [section.topLines addObject:head];
    head.layer.borderColor = nil;
    head.layer.borderWidth = 0;
    
    
    if([[UserAuth instance] checkUserAlreadyLogged] == true)
    {
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.frame = CGRectMake(230, 8, 65, 30);
        
        NSString *strCheck = [[productReview objectForKey:@"main_comment"] objectForKey:@"followed"];
        NSLog(@"Str Check : %@",strCheck);
        if([strCheck isEqualToString:@"unfollowed"])
        {
                lbl.text = NSLocalizedString(@"product_review_follow_btn", nil);
        }
        else
        {
            lbl.text = NSLocalizedString(@"product_review_unfollow_btn", nil);
        }
    [lbl setNuiClass:@"productReviewFollowBtn"];
        lbl.userInteractionEnabled = YES;
    lbl.font = [UIFont fontWithName:PRIMARYFONT size:12];
    [head addSubview:lbl];
    
    UserDataTapGestureRecognizer *tap = [[UserDataTapGestureRecognizer alloc] initWithTarget:self action:@selector(followTap:)];
    tap.currentLabel = lbl;
    tap.numberOfTapsRequired = 1;
    [lbl addGestureRecognizer:tap];
    
    
    }
    
    id body = [NSString stringWithFormat:@"%@",desc];
    
    
    
    // stuff
    MGLineStyled *line = [MGLineStyled multilineWithText:body font:nil width:310
                                                 padding:UIEdgeInsetsMake(0, 10, 5, 10)];
    line.backgroundColor = [UIColor clearColor];
    line.borderStyle &= ~MGBorderEtchedBottom;
    [section.topLines addObject:line];
    
    
    
    
    
    MGLineStyled
    *triggers = [MGLineStyled lineWithLeft:nil
                                     right:[NSString stringWithFormat:@"%@ . %d %@",timeAgo,repliedCount,NSLocalizedString(@"product_review_replied_lbl", nil)] size:CGSizeMake(320, 29)];
    triggers.margin = UIEdgeInsetsMake(0, 0, 0, 0);
    triggers.font = [UIFont fontWithName:PRIMARYFONT size:12];
    [section.topLines addObject:triggers];
}

-(void)followTap:(UserDataTapGestureRecognizer*)tap{
    
    UILabel *lbl = tap.currentLabel;
    
    if([lbl.text isEqualToString:NSLocalizedString(@"product_review_follow_btn", nil)])
    {
        lbl.text = NSLocalizedString(@"product_review_unfollow_btn", nil);
        
        
        HUD = [[MBProgressHUD alloc] initWithView:[[MainViewClass instance] getCurrentMainWindow]];
        [[[MainViewClass instance] getCurrentMainWindow] addSubview:HUD];
        
        HUD.delegate = self;
        
        
        [HUD showWhileExecuting:@selector(commentFollow) onTarget:self withObject:nil animated:YES];
        
        
        
    }
    else
    {
        lbl.text = NSLocalizedString(@"product_review_follow_btn", nil);
        
        HUD = [[MBProgressHUD alloc] initWithView:[[MainViewClass instance] getCurrentMainWindow]];
        [[[MainViewClass instance] getCurrentMainWindow] addSubview:HUD];
        
        HUD.delegate = self;
        
        
        [HUD showWhileExecuting:@selector(commentUnfollow) onTarget:self withObject:nil animated:YES];
    }
}


-(void)commentFollow{
    
    [[DataService instance] comment_follow:[UserAuth instance].username password:[UserAuth instance].password commentID:[[productReview objectForKey:@"main_comment"] objectForKey:@"comment_id"]  type:@"follow"];
}

-(void)commentUnfollow{
    
    [[DataService instance] comment_follow:[UserAuth instance].username password:[UserAuth instance].password commentID:[[productReview objectForKey:@"main_comment"] objectForKey:@"comment_id"]  type:@"unfollow"];
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
