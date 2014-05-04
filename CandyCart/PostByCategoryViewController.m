//
//  PostByCategoryViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/24/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "PostByCategoryViewController.h"

@interface PostByCategoryViewController ()

@end

@implementation PostByCategoryViewController

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
    [self.view setNuiClass:@"ViewInit"];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = [[ToolClass instance] decodeHTMLCharacterEntities:[postDictionary objectForKey:@"categoryName"]];
    
    
    scroller = [MGScrollView scroller];
    scroller.frame = [[DeviceClass instance] getResizeScreen:NO];
    scroller.delegate = self;
    scroller.bottomPadding = 8;
    [self.view addSubview:scroller];
    
    fixedHeight = CGRectGetHeight(scroller.frame);
    currentPage = 1;
    
    processing = NO;

    [self createPostBox:@"init"];
   
}


-(void)createPostBox:(NSString*)type{
    
   
    
    if([type isEqualToString:@"pagination"])
    {
        [scroller.boxes removeObjectAtIndex:[scroller.boxes count]-1];
    }
    NSArray *postArray = [postDictionary objectForKey:@"posts"];
    if([postArray count] > 0)
    {
    for(int i=0;i<[postArray count];i++)
    {
        NSDictionary *post = [postArray objectAtIndex:i];
        NSString *postOnBrowseTemplate = [post objectForKey:@"post_onBrowseTemplate_type"];
        if([postOnBrowseTemplate isEqualToString:@"onBrowseTemplateTitleImgDesc"])
        {
            [self onBrowseTemplateTitleImgDesc:[[post objectForKey:@"images"] objectForKey:@"featured_image"] title:[[ToolClass instance] decodeHTMLCharacterEntities:[post objectForKey:@"title"]] shortDesc:[[ToolClass instance] decodeHTMLCharacterEntities:[post objectForKey:@"excerpt"]] ago:[post objectForKey:@"post_date_ago"] postInfo:post];
        }
        else if([postOnBrowseTemplate isEqualToString:@"onBrowseTemplateImgTitleDate"])
        {
        [self onBrowseTemplateImgTitleDate:[[post objectForKey:@"images"] objectForKey:@"featured_image"] title:[[ToolClass instance] decodeHTMLCharacterEntities:[post objectForKey:@"title"]] ago:[post objectForKey:@"post_date_ago"] postInfo:post];
        }
        else
        {
            [self onBrowseTemplateTitleImgDesc:[[post objectForKey:@"images"] objectForKey:@"featured_image"] title:[[ToolClass instance] decodeHTMLCharacterEntities:[post objectForKey:@"title"]] shortDesc:[[ToolClass instance] decodeHTMLCharacterEntities:[post objectForKey:@"excerpt"]] ago:[post objectForKey:@"post_date_ago"] postInfo:post];
        }
        
    }
    }
    else
    {
        [self noPostFound];
    }
    
    
    totalPage = [[postDictionary objectForKey:@"total_page"] intValue];
    
    //Check total page more than 1
    if(currentPage < totalPage)
    {
        [self loadMore];
    }
    [scroller layoutWithSpeed:0.3 completion:nil];
}



-(void)noPostFound
{
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    [scroller.boxes addObject:section];
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    
    
    
    id body = NSLocalizedString(@"post_controller_no_post_found", nil);
    
    
    
    // stuff
    MGLineStyled *line = [MGLineStyled multilineWithText:body font:nil width:300
                                                 padding:UIEdgeInsetsMake(10, 10, 10, 10)];
    line.backgroundColor = [UIColor clearColor];
    line.borderStyle &= ~MGBorderEtchedBottom;
    [section.topLines addObject:line];
    
    
    
    
}
-(void)onBrowseTemplateTitleImgDesc:(NSString*)featuredImage title:(NSString*)pTitle shortDesc:(NSString*)shortDesc ago:(NSString*)ago postInfo:(NSDictionary*)info{
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
    WpPostBox *timeAgo = [WpPostBox timeAgo:ago];
    [section.topLines addObject:timeAgo];
    
   
    
    //END TIME AGO
    
    //Img Center
    WpPostBox *box = [WpPostBox onBrowseTemplateTitleImgDesc:featuredImage];
    [section.topLines addObject:box];
    //END Img Center
    
    
    //HEADER
    id bottomBody = [NSString stringWithFormat:@"%@",[[ToolClass instance] decodeHTMLCharacterEntities:shortDesc]];
    
    MGLineStyled *bottom = [MGLineStyled multilineWithText:bottomBody font:nil width:300
                                                   padding:UIEdgeInsetsMake(10, 10, 10.0, 10.0)];
    bottom.backgroundColor = [UIColor clearColor];
    bottom.font = [UIFont fontWithName:PRIMARYFONT size:11];
    [section.topLines addObject:bottom];
    //END HEADER
    
    
    section.onTap = ^{
        NSString *pageTem = [info objectForKey:@"page_template_type"];
       
        if([pageTem isEqualToString:@"PlainPageWithoutFeaturedImage"])
        {
            PlainPostDetailViewController *pDetail = [[PlainPostDetailViewController alloc] init];
            pDetail.title = [info objectForKey:@"title"];
            [pDetail setPostInfo:info];
            [self.navigationController pushViewController:pDetail animated:YES];
        }
        else 
        {
            
            PostDetailViewController *pDetail = [[PostDetailViewController alloc] init];
            [pDetail setPostDictionary:info];
            [self.navigationController pushViewController:pDetail animated:YES];
           
        }
        
    };
}


-(void)onBrowseTemplateImgTitleDate:(NSString*)featuredImage title:(NSString*)pTitle ago:(NSString*)ago postInfo:(NSDictionary*)info{
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    
    WpPostBox *box = [WpPostBox onBrowseTemplateImgTitleDate:featuredImage title:pTitle ago:ago ];
    
    
    box.onTap = ^{
        
        NSString *pageTem = [info objectForKey:@"page_template_type"];
     
        if([pageTem isEqualToString:@"PlainPageWithoutFeaturedImage"])
        {
            PlainPostDetailViewController *pDetail = [[PlainPostDetailViewController alloc] init];
            pDetail.title = [info objectForKey:@"title"];
            [pDetail setPostInfo:info];
            [self.navigationController pushViewController:pDetail animated:YES];
        }
        else
        {
            
            PostDetailViewController *pDetail = [[PostDetailViewController alloc] init];
            [pDetail setPostDictionary:info];
            [self.navigationController pushViewController:pDetail animated:YES];
            
        }

    };
    
    [section.topLines addObject:box];
}



-(void)loadMore {
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    PhotoBox *box = [PhotoBox loadMore:CGSizeMake(300, 30)];
    
    
    box.onTap = ^{
        
        
        if(currentPage == totalPage)
        {
            NSLog(@"Maximun page is reached");
        }
        else
        {
            if(processing == NO)
            {
            currentPage = currentPage +1;
            [self processingLoadMore];
            }
        }
        
        
        
    };
    
    [section.topLines addObject:box];
}

-(void)processingLoadMore{
    
    
    UIActivityIndicatorView *act = [[MiscInstances instance] getLoadMoreActivityView];
    [act startAnimating];
    
    UILabel *loadMoreLbl = [[MiscInstances instance] getLoadMoreUILabel];
    loadMoreLbl.hidden = YES;
    
    processing = YES;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSDictionary *postDictionaryTemp = [[DataService instance] getPostByCategory:[postDictionary objectForKey:@"categoryID"] currentPage:[NSString stringWithFormat:@"%d",currentPage] postPerPage:WP_POST_PER_PAGE];
        postDictionary = postDictionaryTemp;
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
           
            [act stopAnimating];
            loadMoreLbl.hidden = NO;
            
            processing = NO;
            
            [self createPostBox:@"pagination"];
        });
        
    });
        
        
        
    
    
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


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    
    
    
    
    if ([self detectEndofScroll]){
        
        NSLog(@"Now go to another page");
        
        
        if(processing == NO)
        {
            
            if(currentPage == totalPage)
            {
                NSLog(@"Maximun page is reached");
            }
            else
            {
                currentPage = currentPage +1;
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


-(void)setPostDictionary:(NSDictionary*)postDictionarys{
    
    postDictionary = postDictionarys;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
