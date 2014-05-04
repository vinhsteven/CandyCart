//
//  BrowseViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/1/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "BrowseViewController.h"

@interface BrowseViewController ()

@end

@implementation BrowseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"tabb_bar_browse", nil);
        self.tabBarItem.image = [UIImage imageNamed:NSLocalizedString(@"tabb_bar_browse_image", nil)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setNuiClass:@"ViewInit"];
    tblView = [[UITableView alloc] initWithFrame:[[DeviceClass instance] getResizeScreen:NO] style:UITableViewStylePlain];
    tblView.delegate = self;
    tblView.dataSource = self;
    tblView.backgroundColor = [UIColor clearColor];
    //tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblView.scrollEnabled = YES;
    [self.view addSubview:tblView];
    
    searchLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 40, tblView.frame.size.width, tblView.frame.size.height)];
    [searchLayer setNuiClass:@"SearchBarTintView"];
    searchLayer.userInteractionEnabled = NO;
    searchLayer.multipleTouchEnabled = NO;
    
    
    [self.view addSubview:searchLayer];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [searchLayer addGestureRecognizer:tapGesture];
    
    NSString *categoryOption = [[[[SettingDataClass instance] getSetting] objectForKey:@"appearance_option"] objectForKey:@"category_browse_option"];
    
    if([categoryOption isEqualToString:@"listall"])
    {
        aryDic = [DataService instance].productCategories;
    }
    else
    {
        aryDic = [DataService instance].productCategoriesCustom;
    }
    
    //hide chuc nang scan qrcode doi voi cac loai hinh` dich vu khac
#ifdef ishop
    UIButton *qrcode = [UIButton buttonWithType:UIButtonTypeCustom];
    qrcode.frame = CGRectMake(self.view.frame.size.width - 69, 8, 63, 30);
    qrcode.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [qrcode setTitle:NSLocalizedString(@"browse_view_open_camera_btn", nil)  forState:UIControlStateNormal];
    [qrcode addTarget:self
               action:@selector(qrCodeAction)
     forControlEvents:UIControlEventTouchDown];
    
    [qrcode setNuiClass:@"UiBarButtonItem"];
    [qrcode.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithCustomView:qrcode];
    self.navigationItem.leftBarButtonItem = button;
#endif
}

- (void) viewWillAppear:(BOOL)animated {
    NSString *categoryOption = [[[[SettingDataClass instance] getSetting] objectForKey:@"appearance_option"] objectForKey:@"category_browse_option"];
    
    if([categoryOption isEqualToString:@"listall"])
    {
        aryDic = [DataService instance].productCategories;
    }
    else
    {
        aryDic = [DataService instance].productCategoriesCustom;
    }
    
    [tblView reloadData];
}
-(void)qrCodeAction{
    
    CameraViewController *camera = [[CameraViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:camera];
    nav.navigationBar.translucent = NO;
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController.tabBarController setTabBarHidden:NO animated:YES];
}

- (void)dismissKeyboard:(UserDataTapGestureRecognizer *)gesture {
    [productSearchBar resignFirstResponder];
}

#pragma mark - Table view data source
//- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellAccessoryDisclosureIndicator;
//}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    
    productSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    [productSearchBar setNuiClass:@"SearchBar"];
    
    
    productSearchBar.tintColor = [UIColor blackColor];
    productSearchBar.delegate = self;
    [headerView addSubview:productSearchBar];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [aryDic count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    NSString *showThumb = [[[[SettingDataClass instance] getSetting] objectForKey:@"appearance_option"] objectForKey:@"category_browse_show_thumb"];
    if([showThumb isEqualToString:@"show"])
    {
        UIImageView *img = [[UIImageView alloc] init];
        img = cell.imageView;
        [cell.imageView setImageWithURL:[NSURL URLWithString:[[ToolClass instance] decodeHTMLCharacterEntities:[[aryDic objectAtIndex:indexPath.row] objectForKey:@"thumb"]]]
                       placeholderImage:[UIImage imageNamed:NSLocalizedString(@"image_loading_placeholder", nil)]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                  
                                  img.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(57, 57) source:image];
                                  
                              }];
    }
    
    //[cell.imageView setImageWithURL:[NSURL URLWithString:[[aryDic objectAtIndex:indexPath.row] objectForKey:@"thumb"]] placeholderImage:[UIImage imageNamed:NSLocalizedString(@"image_loading_placeholder", nil)]];
    
    cell.textLabel.text = [[ToolClass instance] decodeHTMLCharacterEntities:[[aryDic objectAtIndex:indexPath.row] objectForKey:@"name"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BrowseDetailViewController *browse = [[BrowseDetailViewController alloc] init];
    [browse initPopOverCategoriesControllerArray:[[aryDic objectAtIndex:indexPath.row] objectForKey:@"children"]];
    [browse initCategoryID:[[aryDic objectAtIndex:indexPath.row] objectForKey:@"term_id"]];
    browse.title = [[ToolClass instance] decodeHTMLCharacterEntities:[[aryDic objectAtIndex:indexPath.row] objectForKey:@"name"]];
    [self.navigationController pushViewController:browse animated:YES];
}


#pragma mark - Search Bar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"Start Search");
    tblView.scrollEnabled = NO;
    searchLayer.hidden = NO;
    UIImage *blurImage = [[[ToolClass instance] ChangeViewToImage:self.view] stackBlur:3];
    UIImage *newBlurImage = [[ToolClass instance] cropRect:CGRectMake(0, 40, blurImage.size.width, blurImage.size.height-40) source:blurImage];
    blurView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, newBlurImage.size.width, newBlurImage.size.height)];
    
    
    [blurView setImage:newBlurImage];
    [searchLayer addSubview:blurView];
    
    searchLayer.userInteractionEnabled = YES;
    searchLayer.multipleTouchEnabled = YES;
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    NSLog(@"Search Click");
    
    BrowseDetailViewController *browse = [[BrowseDetailViewController alloc] init];
    [browse initKeyword:[searchBar.text stringByAddingPercentEscapesUsingEncoding:
                         NSASCIIStringEncoding]];
    browse.title = searchBar.text;
    [self.navigationController pushViewController:browse animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchLayer.hidden = YES;
    NSLog(@"End Editing");
    tblView.scrollEnabled = YES;
    [blurView removeFromSuperview];
    searchLayer.userInteractionEnabled = NO;
    searchLayer.multipleTouchEnabled = NO;
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
