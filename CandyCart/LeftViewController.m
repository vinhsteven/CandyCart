//
//  LeftViewController.m
//  EasySample
//
//  Created by Marian PAUL on 12/06/12.
//  Copyright (c) 2012 Marian PAUL aka ipodishima — iPuP SARL. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

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
    
   //Hide NavBar
    if(hideNavBar == YES)
    {
        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-35, 0, 250, 44)];
        [searchBar setNuiClass:@"SearchBar"];
        
        searchBar.delegate = self;
        
        UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0,0,250,44)];
        [iv addSubview:searchBar];
        self.navigationItem.titleView = iv;
    }
    else
    {
       
    }
    
    
    
    tbl = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 250, [[DeviceClass instance] getResizeScreen:NO].size.height)];
    tbl.dataSource = self;
    tbl.delegate = self;
    
    [self.view addSubview:tbl];
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:tbl];
    [refreshControl addTarget:self action:@selector(refreshControl:) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshControl:(ODRefreshControl *)refreshControl
{
    
    NSLog(@"Refreshed");
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [[DataService instance] getLeftMenuData];
      
        [self setMenuItems:[[[DataService instance] leftMenuData] objectForKey:@"menu"] hideNavBar:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [tbl reloadData];
            
            [refreshControl endRefreshing];
            
        });
        
    });
    
}


-(void)viewDidAppear:(BOOL)animated{
    
    [[[MainViewClass instance] getPPReavealController] replaceAfterOpenedCompletelyAnimated:YES completion:nil];
}

-(void)setMenuItems:(NSArray*)items hideNavBar:(BOOL)hide{
    menuItems = items;
    hideNavBar = hide;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)search
{
    NSLog(@"Start Search");
    
    
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)search
{
    
    NSLog(@"Search Click");
    
    HUD = [[MBProgressHUD alloc] initWithView:[[MainViewClass instance] getCurrentMainWindow]];
    [[[MainViewClass instance] getCurrentMainWindow] addSubview:HUD];
    
    HUD.delegate = self;
    
    
    [HUD showWhileExecuting:@selector(searchPostExe:) onTarget:self withObject:search.text animated:YES];
    
    
}

-(void)searchPostExe:(NSString*)searchText
{
    
    NSDictionary *linkPostResult = [[DataService instance] get_search_post:searchText currentPage:@"1" postPerPage:@"10"];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [[[MainViewClass instance] getPPReavealController] openCompletelyAnimated:YES];
            PostByCategoryViewController *productDetail = [[PostByCategoryViewController alloc] init];
            [productDetail setPostDictionary:linkPostResult];
            [self.navigationController pushViewController:productDetail animated:YES];
            
            
        });
        
    });
    
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *menuAttr = [menuItems objectAtIndex:indexPath.row];
    NSString *sub = [NSString stringWithFormat:@"%@",[menuAttr objectForKey:@"subtitle"]];
    
    
    if([sub isEqualToString:@"0"])
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [menuAttr objectForKey:@"name"]];
    
        
        
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [menuAttr objectForKey:@"name"]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [menuAttr objectForKey:@"subtitle"]];
    }
    
    UIImage *image = [UIImage imageNamed:@"arrow.png"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    button.frame = frame;   // match the button's size with the image size
    
    //[button setBackgroundImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    // set the button's target to this table view controller so we can interpret touch events and map that to a NSIndexSet
    [button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    cell.accessoryView = button;

    
    
    
    NSArray *children = [menuAttr objectForKey:@"child"];
    if([children count] == 0)
    {
        
        button.hidden = YES;
    }
    else
    {
        button.hidden = NO;
        
      }
    
    
    
    
    return cell;
}

- (void)checkButtonTapped:(id)sender event:(id)event
{
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:tbl];
    NSIndexPath *indexPath = [tbl indexPathForRowAtPoint: currentTouchPosition];
    NSLog(@"Section:%d",indexPath.section);
    NSLog(@"Index:%d",indexPath.row);
    if (indexPath != nil)
    {
        [ self tableView: tbl accessoryButtonTappedForRowWithIndexPath: indexPath];
        
    }
    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
     NSDictionary *menuAttr = [menuItems objectAtIndex:indexPath.row];
     NSArray *children = [menuAttr objectForKey:@"child"];
    LeftViewController *left = [[LeftViewController alloc] init];
    left.title = [menuAttr objectForKey:@"name"];
    [left setMenuItems:children hideNavBar:NO];
    [self.navigationController pushViewController:left animated:YES];
    
}


- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *menuAttr = [menuItems objectAtIndex:indexPath.row];
    NSArray *children = [menuAttr objectForKey:@"child"];
    if([children count] == 0)
    {
        return UITableViewCellAccessoryDetailDisclosureButton;
    }
    else
    {
        return UITableViewCellAccessoryDetailDisclosureButton;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSDictionary *menuAttr = [menuItems objectAtIndex:indexPath.row];
    NSString *productType= [menuAttr objectForKey:@"type"];
    if([productType isEqualToString:@"page"])
    {
        HUD = [[MBProgressHUD alloc] initWithView:[[MainViewClass instance] getCurrentMainWindow]];
        [[[MainViewClass instance] getCurrentMainWindow] addSubview:HUD];

        HUD.delegate = self;
        
      
        [HUD showWhileExecuting:@selector(goToPageExe:) onTarget:self withObject:menuAttr animated:YES];
    
    }
    else if([productType isEqualToString:@"custom"])
    {
        [[[MainViewClass instance] getPPReavealController] openCompletelyAnimated:YES];
        iPhoneWebView *ip = [[iPhoneWebView alloc] init];
        [ip loadUrlInWebView:[menuAttr objectForKey:@"link"]];
        ip.navigationController.navigationBar.translucent = NO;
        [self.navigationController pushViewController:ip animated:YES];
        
    }
    else if([productType isEqualToString:@"product"])
    {
        HUD = [[MBProgressHUD alloc] initWithView:[[MainViewClass instance] getCurrentMainWindow]];
        [[[MainViewClass instance] getCurrentMainWindow] addSubview:HUD];
        
        HUD.delegate = self;
        
        
        [HUD showWhileExecuting:@selector(goToProductExe:) onTarget:self withObject:menuAttr animated:YES];
        
        
        
        
        
    }
    else if([productType isEqualToString:@"product_cat"])
    {
        HUD = [[MBProgressHUD alloc] initWithView:[[MainViewClass instance] getCurrentMainWindow]];
        [[[MainViewClass instance] getCurrentMainWindow] addSubview:HUD];
        
        HUD.delegate = self;
        
        
        [HUD showWhileExecuting:@selector(goToProductCatExe:) onTarget:self withObject:menuAttr animated:YES];
        
    }
    else if([productType isEqualToString:@"category"])
    {
        HUD = [[MBProgressHUD alloc] initWithView:[[MainViewClass instance] getCurrentMainWindow]];
        [[[MainViewClass instance] getCurrentMainWindow] addSubview:HUD];
        
        HUD.delegate = self;
        
        
        [HUD showWhileExecuting:@selector(goToPostCatExe:) onTarget:self withObject:menuAttr animated:YES];
        
    }
}


-(void)goToPostCatExe:(NSDictionary*)dic{
    NSDictionary *getPostByCategoryResult = [[DataService instance] getPostByCategory:[dic objectForKey:@"objectID"] currentPage:@"1" postPerPage:WP_POST_PER_PAGE];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            NSLog(@"%@",getPostByCategoryResult);
            
            
            [[[MainViewClass instance] getPPReavealController] openCompletelyAnimated:YES];
            PostByCategoryViewController *postByCategory = [[PostByCategoryViewController alloc] init];
            [postByCategory setPostDictionary:getPostByCategoryResult];
            postByCategory.navigationController.navigationBar.translucent = NO;
              postByCategory.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            [self.navigationController pushViewController:postByCategory animated:YES];
            
        });
        
    });
    
    
}



-(void)goToProductCatExe:(NSDictionary*)dic{
    
    NSArray *childCategory = [[DataService instance] getChildProductCategories:[dic objectForKey:@"objectID"]];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [[[MainViewClass instance] getPPReavealController] openCompletelyAnimated:YES];
            BrowseDetailViewController *browse = [[BrowseDetailViewController alloc] init];
            [browse initPopOverCategoriesControllerArray:childCategory];
            [browse initCategoryID:[dic objectForKey:@"objectID"]];
            browse.title = [[ToolClass instance] decodeHTMLCharacterEntities:[dic objectForKey:@"name"]];
            browse.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            browse.navigationController.navigationBar.translucent = NO;
            [self.navigationController pushViewController:browse animated:YES];
            
        });
        
    });
    
    
}


-(void)goToProductExe:(NSDictionary*)dic{
    NSDictionary *linkPostResult = [[DataService instance] getSingleProduct:[dic objectForKey:@"objectID"]];
  
    
    
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [[[MainViewClass instance] getPPReavealController] openCompletelyAnimated:YES];
            DetailViewController *productDetail = [[DetailViewController alloc] init];
            [productDetail setProductInfo:linkPostResult];
            productDetail.navigationController.navigationBar.translucent = NO;
            productDetail.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            [self.navigationController pushViewController:productDetail animated:YES];
            ;

        });
    });
    
}


-(void)goToPageExe:(NSDictionary*)dic{
    
  
      NSDictionary *postInfo = [[DataService instance] getWpPostByPostID:[dic objectForKey:@"objectID"]];
    
    NSString *pageTemplate = [postInfo objectForKey:@"page_template_type"];
    
    NSArray *xmlArray;
     NSDictionary *instagram_responses;
    NSString *hashtag;
      NSDictionary *business_plugin_directory;
    int hashtag_post_total = 0;
    if([pageTemplate isEqualToString:@"RSSFeed"])
    {
        NSString *rssUrl = [[[postInfo objectForKey:@"page_template_meta"] objectForKey:@"if_candyRSSFeed"] objectForKey:@"candyRSSFeed"];
       
         xmlArray= [[DataService instance] getRSSXmlData:rssUrl];
        
    }
    else if([pageTemplate isEqualToString:@"instagramHash"])
    {
       hashtag = [[[postInfo objectForKey:@"page_template_meta"] objectForKey:@"if_instagramHash"] objectForKey:@"hash_tag"];
        
        
        instagram_responses = [[DataService instance] getInstagramAPI:hashtag];
         hashtag_post_total = [[DataService instance] countInstagramHashTag:hashtag];
    }
    else if([pageTemplate isEqualToString:@"businessDirectoryPlugin"])
    {
        
        business_plugin_directory = [[DataService instance] getBussinessDirectoryPlugin];
    }

    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
      
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
          
            
           
            
            if([pageTemplate isEqualToString:@"ParallaxPage"])
            {
                [[[MainViewClass instance] getPPReavealController] openCompletelyAnimated:YES];
                PostDetailViewController *pDetail = [[PostDetailViewController alloc] init];
                [pDetail setPostDictionary:postInfo];
                pDetail.navigationController.navigationBar.translucent = NO;
                pDetail.navigationController.navigationBar.tintColor = [UIColor whiteColor];
                [self.navigationController pushViewController:pDetail animated:YES];
                
            }
            else if([pageTemplate isEqualToString:@"PlainPageWithoutFeaturedImage"])
            {
                [[[MainViewClass instance] getPPReavealController] openCompletelyAnimated:YES];
                PlainPostDetailViewController *plainPost = [[PlainPostDetailViewController alloc] init];
                plainPost.title = [dic objectForKey:@"name"];
                [plainPost setPostInfo:postInfo];
                plainPost.navigationController.navigationBar.tintColor = [UIColor whiteColor];
                 plainPost.navigationController.navigationBar.translucent = NO;
                [self.navigationController pushViewController:plainPost animated:YES];
                
            }
            else if([pageTemplate isEqualToString:@"OfficeOrStoreLocation"])
            {
                [[[MainViewClass instance] getPPReavealController] openCompletelyAnimated:YES];
                NSDictionary *contactInfo = [[postInfo objectForKey:@"page_template_meta"] objectForKey:@"if_OfficeOrStoreLocation"];
                ContactUsViewController *con = [[ContactUsViewController alloc] initWithNibName:@"ContactUsViewController" bundle:nil];
                con.title = [dic objectForKey:@"name"];
                 con.navigationController.navigationBar.translucent = NO;
                con.navigationController.navigationBar.tintColor = [UIColor whiteColor];
                [con initContactUsTemplateDictionary:contactInfo];
                [self.navigationController pushViewController:con animated:YES];
                
                
            }
            else if([pageTemplate isEqualToString:@"CallUs"])
            {
                 NSString *phoneNumber = [[[postInfo objectForKey:@"page_template_meta"] objectForKey:@"if_CallUs"] objectForKey:@"candyCallUs"];
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]]];
                
            }
            else if([pageTemplate isEqualToString:@"EmailUs"])
            {
                
                NSString *email = [[[postInfo objectForKey:@"page_template_meta"] objectForKey:@"if_EmailUs"] objectForKey:@"candyEmail"];
                
                
                MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
                mailer.mailComposeDelegate = self;
                
                NSArray *usersTo = [NSArray arrayWithObjects:email, nil];
                [mailer setToRecipients:usersTo];
                [[[MainViewClass instance] getPPReavealController] presentViewController:mailer animated:YES completion:nil];
                
                
                
            }
            else if([pageTemplate isEqualToString:@"KrukChat"])
            {
                
                
                
            }
            else if([pageTemplate isEqualToString:@"imggallery"])
            {
                [[[MainViewClass instance] getPPReavealController] openCompletelyAnimated:YES];
                NSArray *galleryImages = [[postInfo objectForKey:@"images"] objectForKey:@"other_images"];
                ImageGalleryThumbController *gallery = [[ImageGalleryThumbController alloc] init];
                gallery.navigationController.navigationBar.tintColor = [UIColor whiteColor];
                gallery.navigationController.navigationBar.translucent = NO;
                [gallery setImageInfo:galleryImages];
                gallery.title = [dic objectForKey:@"name"];
                [self.navigationController pushViewController:gallery animated:YES];
                
                
                
            }
            else if([pageTemplate isEqualToString:@"RSSFeed"])
            {
                [[[MainViewClass instance] getPPReavealController] openCompletelyAnimated:YES];
                RSSFeedControllerViewController *rss = [[RSSFeedControllerViewController alloc] init];
                rss.navigationController.navigationBar.tintColor = [UIColor whiteColor];
                rss.navigationController.navigationBar.translucent = NO;
                [rss setRSSInfo:xmlArray];
                rss.title = [dic objectForKey:@"name"];
                [self.navigationController pushViewController:rss animated:YES];
                
                
                
            }
            else if([pageTemplate isEqualToString:@"instagramHash"])
            {
                [[[MainViewClass instance] getPPReavealController] openCompletelyAnimated:YES];
                InstagramViewController *insta = [[InstagramViewController alloc] init];
                [insta setInfoDictionary:instagram_responses hashtag:hashtag postTotal:hashtag_post_total];
                insta.navigationController.navigationBar.tintColor = [UIColor whiteColor];
                insta.navigationController.navigationBar.translucent = NO;
                insta.title = [dic objectForKey:@"name"];
                [self.navigationController pushViewController:insta animated:YES];
                
                
                
            }
            else if([pageTemplate isEqualToString:@"businessDirectoryPlugin"])
            {
               [[[MainViewClass instance] getPPReavealController] openCompletelyAnimated:YES];
                mapViewViewController *map = [[mapViewViewController alloc] initWithNibName:@"mapViewViewController" bundle:nil];
                
                map.navigationController.navigationBar.tintColor = [UIColor whiteColor];
                map.navigationController.navigationBar.translucent = NO;
                map.title = [dic objectForKey:@"name"];
                
                
                [map loadPlaces:[business_plugin_directory objectForKey:@"posts"]];
                [self.navigationController pushViewController:map animated:YES];
                
            }
            
           
            
            
            
        });
        
    });

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

@end
