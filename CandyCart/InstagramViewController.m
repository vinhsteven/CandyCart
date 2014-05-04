//
//  InstagramViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/27/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "InstagramViewController.h"

@interface InstagramViewController ()

@end

@implementation InstagramViewController

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
    scroller.alwaysBounceVertical = YES;
    
    dataArray = [[NSMutableArray alloc] init]; //init functionality is to keep all respond data
    
    [self createView];
    [scroller layoutWithSpeed:0.3 completion:nil];
    fixedHeight = CGRectGetHeight(scroller.frame);
    reachMax = NO;
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:scroller];
    [refreshControl addTarget:self action:@selector(refreshControl:) forControlEvents:UIControlEventValueChanged];

}


- (void)refreshControl:(ODRefreshControl *)refreshControl
{
    
    NSLog(@"Refreshed");
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSDictionary *new_respond = [[DataService instance] getInstagramAPI:hashTag];
        postTotal = [[DataService instance] countInstagramHashTag:hashTag];
        respond = new_respond;
        NSLog(@"Responce %@",new_respond);
        dispatch_async(dispatch_get_main_queue(), ^(void){
              [scroller.boxes removeAllObjects];
            [dataArray removeAllObjects];
            if(is_list_view == YES)
            {
                [self createView];
            }
            else
            {
                [self createGridView];
            }
            [scroller layoutWithSpeed:0.3 completion:nil];
            
            [refreshControl endRefreshing];
        });
        
    });

}

-(void)createView{
    [self instagramNavBox];
    NSArray *data = [respond objectForKey:@"data"];
    
    
    for(int i=0;i<[data count];i++)
    {
        [dataArray addObject:[data objectAtIndex:i]];
        [self instagramBox:[data objectAtIndex:i]];
    }
    [self loadMore];
}


-(void)createViewSwitch{
    [self instagramNavBox];
  
    
    
    for(int i=0;i<[dataArray count];i++)
    {
     
        [self instagramBox:[dataArray objectAtIndex:i]];
    }
    [self loadMore];
}

-(void)createGridView{
    [self instagramNavBox];
    NSArray *data = [respond objectForKey:@"data"];
    for(int i=0;i<[data count];i++)
    {
         [dataArray addObject:[data objectAtIndex:i]];
        [self image_box:[data objectAtIndex:i]];
    }
    [self loadMore];
}



-(void)createGridViewSwitch{
    [self instagramNavBox];
   
    for(int i=0;i<[dataArray count];i++)
    {
     
        [self image_box:[dataArray objectAtIndex:i]];
    }
    [self loadMore];
}


-(void)setInfoDictionary:(NSDictionary*)instagramResponse hashtag:(NSString*)hashtag postTotal:(int)total{
    
    postTotal = total;
    respond = instagramResponse;
    hashTag = hashtag;
    
     is_list_view = YES;
}

-(void)instagramNavBox{
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    InstagramBox *header = [InstagramBox instagramNavTop:postTotal];
    [section.topLines addObject:header];
    
     listLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    
    if(is_list_view == YES)
    {
    listLbl.backgroundColor = [UIColor lightGrayColor];
    }
    else
    {
      listLbl.backgroundColor = [UIColor clearColor];
    }
    
    listLbl.userInteractionEnabled = YES;
     [header addSubview:listLbl];
    
    
    listBtn = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5.5, 30, 30)];
    listBtn.image = [UIImage imageNamed:@"instagram_list_icon.png"];
    
    listBtn.userInteractionEnabled = YES;
    [listLbl addSubview:listBtn];
    
    UserDataTapGestureRecognizer *listBtnGesture = [[UserDataTapGestureRecognizer alloc] initWithTarget:self action:@selector(listBtnGestureExe:)];
   
    [listLbl addGestureRecognizer:listBtnGesture];
    [listBtn addGestureRecognizer:listBtnGesture];
    
    
    gridLbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 50, 40)];
    if(is_list_view == YES)
    {
        gridLbl.backgroundColor = [UIColor clearColor];
    
    }
    else
    {
      gridLbl.backgroundColor = [UIColor lightGrayColor];
    }
    gridLbl.userInteractionEnabled = YES;
    [header addSubview:gridLbl];
    
    gridBtn = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    gridBtn.image = [UIImage imageNamed:@"instagram_grid_icon.png"];
    
    gridBtn.userInteractionEnabled = YES;
    [gridLbl addSubview:gridBtn];
    
    UserDataTapGestureRecognizer *gridBtnGesture = [[UserDataTapGestureRecognizer alloc] initWithTarget:self action:@selector(gridBtnGestureExe:)];
    
    [gridLbl addGestureRecognizer:gridBtnGesture];
    [gridBtn addGestureRecognizer:gridBtnGesture];


}


-(void)listBtnGestureExe:(UserDataTapGestureRecognizer*)gesture{
    if(is_list_view == NO)
    {
        is_list_view = YES;
        listLbl.backgroundColor = [UIColor lightGrayColor];
        gridLbl.backgroundColor = [UIColor clearColor];
        [scroller.boxes removeAllObjects];
        [self createViewSwitch];
        scroller.contentLayoutMode = MGLayoutTableStyle;
        [scroller layoutWithSpeed:0.3 completion:nil];
    }
    else
    {
   
        
        
    }
    
    
    
}


-(void)gridBtnGestureExe:(UserDataTapGestureRecognizer*)gesture{
    if(is_list_view == NO)
    {
     
    }
    else
    {
        is_list_view = NO;
        listLbl.backgroundColor = [UIColor clearColor];
        gridLbl.backgroundColor = [UIColor lightGrayColor];
        [scroller.boxes removeAllObjects];
        [self createGridViewSwitch];
        scroller.contentLayoutMode = MGLayoutGridStyle;
        [scroller layoutWithSpeed:0.3 completion:nil];
        
    }
}


-(void)image_box:(NSDictionary*)fullinfo{
    MGBox *section =  MGBox.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    ImageGalleryBox *thumb = [ImageGalleryBox imgThumb:CGSizeMake(93.333,93.333) img:[[[fullinfo objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"]];
    [section.boxes addObject:thumb];
    NSString *type= [fullinfo objectForKey:@"type"];
    
    if([type isEqualToString:@"video"])
    {
        UIImageView *videoIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"instagram_video_icon.png"]];
        videoIcon.frame = CGRectMake(68,5,20,20);
        [thumb addSubview:videoIcon];
    }
    else
    {
        
    }
    
    section.onTap = ^{
        
        InstagramNativeDetailViewController *detail = [[InstagramNativeDetailViewController alloc] init];
        [detail setPostInfo:fullinfo];
        
        if([type isEqualToString:@"video"])
        {
           detail.title = NSLocalizedString(@"instagram_video_title", nil);
            
        }
        else
        {
            
            detail.title = NSLocalizedString(@"instagram_image_title", nil);
        }
        
        [self.navigationController pushViewController:detail animated:YES];
        
    };
    
  }


-(void)instagramBox:(NSDictionary*)fullinfo{
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    InstagramBox *header = [InstagramBox instagramHeader:[[fullinfo objectForKey:@"user"] objectForKey:@"profile_picture"] name:[[fullinfo objectForKey:@"user"] objectForKey:@"username"] created:[fullinfo objectForKey:@"created_time"] mediaID:[fullinfo objectForKey:@"id"]];
    [section.topLines addObject:header];
    
    
    UIImageView *openInInsta = [[UIImageView alloc] initWithFrame:CGRectMake(260, 15, 30, 30)];
    openInInsta.image = [UIImage imageNamed:@"instagram_flat_icon.png"];
    openInInsta.userInteractionEnabled = YES;
    [header addSubview:openInInsta];
    
    UserDataTapGestureRecognizer *openInInstagram = [[UserDataTapGestureRecognizer alloc] initWithTarget:self action:@selector(openInInstagramExe:)];
    openInInstagram.userData = fullinfo;
    
    [openInInsta addGestureRecognizer:openInInstagram];
    
    //Img Center
    InstagramBox *box = [InstagramBox instagramBox:[[[fullinfo objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"] type:[fullinfo objectForKey:@"type"]];
    [section.topLines addObject:box];
    //END Img Center
    MGLineStyled *bottom;
    @try {
        NSString * str = [NSString stringWithFormat:@"%@",[[fullinfo objectForKey:@"caption"] objectForKey:@"text"]];
        
        if([str length] > 0)
        {
        id bottomBody = str;
        
        
        bottom = [MGLineStyled multilineWithText:bottomBody font:nil width:300
                                                       padding:UIEdgeInsetsMake(10, 10, 10.0, 10.0)];
        bottom.backgroundColor = [UIColor clearColor];
        bottom.font = [UIFont fontWithName:PRIMARYFONT size:11];
        [section.topLines addObject:bottom];
        }

    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }

    NSString * likes = [NSString stringWithFormat:@"%@ %@",[[fullinfo objectForKey:@"likes"] objectForKey:@"count"],NSLocalizedString(@"instagram_likes", nil)];
    NSString * comments = [NSString stringWithFormat:@"%@ %@",[[fullinfo objectForKey:@"comments"] objectForKey:@"count"],NSLocalizedString(@"instagram_comments", nil)];
    
    id likeID = likes;
    id commentsID = comments;
    
    
    
    
    MGLineStyled
    *likeAngComment = [MGLineStyled lineWithLeft:likeID
                                     right:commentsID size:CGSizeMake(300, 29)];
    likeAngComment.font = [UIFont fontWithName:PRIMARYFONT size:12];
    [section.topLines addObject:likeAngComment];
    
    InstagramBox *tempBox = box;
    
    box.onTap = ^{
        NSString *type = [fullinfo objectForKey:@"type"];
        if([type isEqualToString:@"video"])
        {
            [player.view removeFromSuperview];
            player.view.alpha = 0;
            NSString *videoUrl = [NSString stringWithFormat:@"%@",[[[fullinfo objectForKey:@"videos"] objectForKey:@"standard_resolution"] objectForKey:@"url"]];
          
            
        NSURL *movieURL = [NSURL URLWithString:videoUrl];
        player = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
        player.view.frame = CGRectMake(0, 0, 300, 300);
        [tempBox addSubview:player.view];
      
            
            
            player.shouldAutoplay = YES;
            [player prepareToPlay];
            
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            player.view.alpha = 1;
            
            [UIView commitAnimations];
            
              [player play];
            
            
            [[NSNotificationCenter defaultCenter] addObserver:self // the object listening / "observing" to the notification
                                                     selector:@selector(myMovieFinishedCallback) // method to call when the notification was pushed
                                                         name:MPMoviePlayerPlaybackDidFinishNotification // notification the observer should listen to
                                                       object:player];
        }
        else
        {
            /*
            InstagramDetailWebView *detail = [[InstagramDetailWebView alloc] init];
            [detail loadUrlInWebView:[fullinfo objectForKey:@"link"] mediaID:[fullinfo objectForKey:@"id"]];
            [self.navigationController pushViewController:detail animated:YES];
             */
        }

        
    };

    /*
    bottom.onTap = ^{
        InstagramDetailWebView *detail = [[InstagramDetailWebView alloc] init];
        [detail loadUrlInWebView:[fullinfo objectForKey:@"link"] mediaID:[fullinfo objectForKey:@"id"]];
        [self.navigationController pushViewController:detail animated:YES];
    };
    
    
    likeAngComment.onTap = ^{
        InstagramDetailWebView *detail = [[InstagramDetailWebView alloc] init];
        [detail loadUrlInWebView:[fullinfo objectForKey:@"link"] mediaID:[fullinfo objectForKey:@"id"]];
        [self.navigationController pushViewController:detail animated:YES];
    };
    */
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    CGFloat offset = [self tableScrollOffset];
    
    if (offset >= 0.0f) {
        
        NSLog(@"Load More");
        UILabel *loadMoreLbl = [[MiscInstances instance] getLoadMoreUILabel];
        loadMoreLbl.text = NSLocalizedString(@"browse_view_load_more", nil);
        
    } else if (offset <= 0 && offset >= -fixedHeight) {
        
        if([self detectEndofScroll])
        {
            
            NSLog(@"Release to refresh");
            UILabel *loadMoreLbl = [[MiscInstances instance] getLoadMoreUILabel];
            loadMoreLbl.text = NSLocalizedString(@"browse_view_release_to_refresh", nil);
        }
        else
        {
            NSLog(@"Pull to refresh");
            UILabel *loadMoreLbl = [[MiscInstances instance] getLoadMoreUILabel];
            loadMoreLbl.text = NSLocalizedString(@"browse_view_pull_to_refresh", nil);
        }
        
        
    } else {
        
        
    }
    
}


-(void)openInInstagramExe:(UserDataTapGestureRecognizer*)gesture{
    NSLog(@"Open Instagram");
    NSDictionary *fullinfo = gesture.userData;
    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://media?id=%@",[fullinfo objectForKey:@"id"]]];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    }
    else
    {
        InstagramDetailWebView *detail = [[InstagramDetailWebView alloc] init];
        [detail loadUrlInWebView:[fullinfo objectForKey:@"link"] mediaID:[fullinfo objectForKey:@"id"]];
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}

-(void)loadMore {
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    PhotoBox *box = [PhotoBox loadMore:CGSizeMake(300, 30)];
    
    
    box.onTap = ^{
        
        
       if(reachMax == YES)
       {
       }
       else{
            if(processing == NO)
            {
                
                [self processingLoadMore];
            }
       }
        
        
        
    };
    
    [section.topLines addObject:box];
}


-(void)myMovieFinishedCallback{
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    player.view.alpha = 0;
    
    [UIView commitAnimations];
    
   
}

- (CGFloat)tableScrollOffset {
    
    CGFloat offset = 0.0f;
    
    if ([scroller contentSize].height < CGRectGetHeight([scroller frame])) {
        
        offset = -[scroller contentOffset].y;
        
    } else {
        
        offset = ([scroller contentSize].height - [scroller contentOffset].y) - CGRectGetHeight([scroller frame]);
    }
    
    return offset;
}

- (BOOL)detectEndofScroll{
    
    BOOL scrollResult;
    CGPoint offset = scroller.contentOffset;
    CGRect bounds = scroller.bounds;
    CGSize size =scroller.contentSize;
    UIEdgeInsets inset = scroller.contentInset;
    float yaxis = offset.y + bounds.size.height - inset.bottom;
    float h = size.height+50;
    if(yaxis > h) {
        scrollResult = YES;
    }else{
        scrollResult = NO;
    }
    
    return scrollResult;
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    
    
    
    
    if ([self detectEndofScroll]){
        
        NSLog(@"Now go to another page");
        
        
        if(processing == NO)
        {
            
            if(reachMax == YES)
            {
                NSLog(@"Maximun page is reached");
            }
            else
            {
                [self processingLoadMore];
            }
        }
        else
        {
            NSLog(@"Still processing");
            
        }
        
    }
    else {
        
        
    }
}



-(void)processingLoadMore{
    
    
    UIActivityIndicatorView *act = [[MiscInstances instance] getLoadMoreActivityView];
    [act startAnimating];
    
    UILabel *loadMoreLbl = [[MiscInstances instance] getLoadMoreUILabel];
    loadMoreLbl.hidden = YES;
    
    processing = YES;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSDictionary *postDictionaryTemp = [[DataService instance] getPaginationApi:[[respond objectForKey:@"pagination"] objectForKey:@"next_url"]];
        respond = postDictionaryTemp;
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            
            [act stopAnimating];
            loadMoreLbl.hidden = NO;
            
            processing = NO;
            [self createPaginationView:postDictionaryTemp];
      
        });
        
    });
    
    
    
    
    
}


-(void)createPaginationView:(NSDictionary*)next_page{
    NSArray *data = [next_page objectForKey:@"data"];
    if([data count] > 0)
    {
        [scroller.boxes removeObjectAtIndex:[scroller.boxes count] -1];
        for(int i=0;i<[data count];i++)
        {
            [dataArray addObject:[data objectAtIndex:i]];
            if(is_list_view == YES)
            {
            [self instagramBox:[data objectAtIndex:i]];
            }
            else
            {
               [self image_box:[data objectAtIndex:i]];
            }
        }
        [self loadMore];
        
         [scroller layoutWithSpeed:0.3 completion:nil];
    }
    else
    {
        reachMax = YES;
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
