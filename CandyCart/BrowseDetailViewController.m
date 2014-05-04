//
//  BrowseDetailViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/11/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "BrowseDetailViewController.h"


@interface BrowseDetailViewController ()

@end

@implementation BrowseDetailViewController

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
    // Do any additional setup after loading the view from its nib.
    
    
    //init
    scroller = [[MGScrollView alloc] initWithFrame:[[DeviceClass instance] getResizeScreen:NO]];
    scroller.contentLayoutMode = MGLayoutGridStyle;
    scroller.bottomPadding = 8;
    
    scroller.delegate = self;
    scroller.alwaysBounceVertical = YES;
    
    [self.view addSubview:scroller];
    
    
    
    fixedHeight = CGRectGetHeight(scroller.frame);
    currentPage = 1;
    
    processing = YES;
    
    if(isSearch == NO)
    {
        [self loadProductDataByCategory:globalCategoryID page:[NSString stringWithFormat:@"%d",currentPage] postPerPage:WOO_PRODUCT_PERPAGE type:@"start"];
        [self chooseSubCategory];
    }
    else
    {
        [self loadProductDataByKeyWord:globalCategoryID page:[NSString stringWithFormat:@"%d",currentPage] postPerPage:WOO_PRODUCT_PERPAGE type:@"start"];
    }
    
    //init popover
    UILabel *se =[PhotoBox getUILabelForSubCategoryLabel];
    ChooseSubCategoryController *menu = [[ChooseSubCategoryController alloc] init];
    menu.title = NSLocalizedString(@"popover_view_title", nil);
    [menu setCategoryParentID:globalCategoryID];
    [menu setParentController:self];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:menu];
    [menu setArray:categoriesArray];
    
    [menu setLabelToSend:se];
    nav.navigationBar.translucent = NO;
    popover = [[FPPopoverController alloc] initWithViewController:nav];
    
    [menu setPopOverController:popover];
    
    popover.border = NO;
    popover.delegate = self;
    popover.contentSize = CGSizeMake(300,420);
    [popover.view setNuiClass:@"DropDownView"];
    [popover disableDismissOutside:YES];
    [popover presentPopoverFromPoint:CGPointMake(160, 90)];
    popover.view.hidden = YES;
    
}


-(void)initPopOverCategoriesControllerArray:(NSArray*)ary{
    categoriesArray = ary;
}

-(void)initCategoryID:(NSString*)ID{
    globalCategoryID = ID;
    isSearch = NO;
}

-(void)initKeyword:(NSString*)keyword{
    globalCategoryID = keyword;
    isSearch = YES;
}


-(void)loadProductDataByCategory:(NSString*)categoryID page:(NSString*)page postPerPage:(NSString*)postPerPage type:(NSString*)type{
    
    if([type isEqualToString:@"pagination"])
    {
        UIActivityIndicatorView *act = [[MiscInstances instance] getLoadMoreActivityView];
        [act startAnimating];
        
        UILabel *loadMoreLbl = [[MiscInstances instance] getLoadMoreUILabel];
        loadMoreLbl.hidden = YES;
    }
    
    if([type isEqualToString:@"chooseCategory"])
    {
        [spinner startAnimating];
        for(int i = [scroller.boxes count]-1;i>0;i--)
        {
            NSLog(@"i is %d",i);
            if(i == 0)
            {
                
            }
            else
            {
                [scroller.boxes removeObjectAtIndex:i];
            }
        }
    }
    
    [self loadingIndicator];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        
        processing = YES;
        
        NSDictionary *categoryData = [[DataService instance] getProductByCategory:categoryID page:page productPerPage:postPerPage];
        
        productByCategoriesData = [categoryData objectForKey:@"products"];
        
        
        //Get categories Data
        
        
        if([type isEqualToString:@"pagination"])
        {
            [scroller.boxes removeObjectAtIndex:[scroller.boxes count]-1];
        }
        else if([type isEqualToString:@"start"])
        {
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            for (int i = 0; i<[productByCategoriesData count]; i++)
            {
                NSDictionary *productData = [productByCategoriesData objectAtIndex:i];
                
                if([[[productData objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"grouped"])
                {
                    [self gridStyleNormal:[[productData objectForKey:@"product_gallery"] objectForKey:@"featured_images"] title:[[productData objectForKey:@"general"] objectForKey:@"title"] priceRegular:[NSString stringWithFormat:@"%@ %@ %@",NSLocalizedString(@"group_and_variable_pricing", nil), [[SettingDataClass instance] getCurrencySymbol],[[[productData objectForKey:@"if_group"] objectForKey:@"min_price"] objectForKey:@"price"]] productInfo:productData];
                }
                else if([[[productData objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"variable"])
                {
                    [self gridStyleNormal:[[productData objectForKey:@"product_gallery"] objectForKey:@"featured_images"] title:[[productData objectForKey:@"general"] objectForKey:@"title"] priceRegular:[NSString stringWithFormat:@"%@ %@ %@",NSLocalizedString(@"group_and_variable_pricing", nil), [[SettingDataClass instance] getCurrencySymbol],[[[productData objectForKey:@"if_variants"] objectForKey:@"min_price"] objectForKey:@"price"]] productInfo:productData];
                }
                else
                {
                    NSNumber *boolean = (NSNumber *)[[[productData objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"is_on_sale"];
                    NSLog(@"Get ti %@",boolean);
                    if([boolean boolValue] == FALSE)
                    {
                        
                        [self gridStyleNormal:[[productData objectForKey:@"product_gallery"] objectForKey:@"featured_images"] title:[[productData objectForKey:@"general"] objectForKey:@"title"] priceRegular:[NSString stringWithFormat:@"%@ %@", [[SettingDataClass instance] getCurrencySymbol],[[AppDelegate instance] convertToThousandSeparator:[[[productData objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"regular_price"]]] productInfo:productData];
                    }
                    else
                    {
                        NSLog(@"OnSale");
                        [self gridStyleOnSale:[[productData objectForKey:@"product_gallery"] objectForKey:@"featured_images"] title:[[productData objectForKey:@"general"] objectForKey:@"title"] priceRegular:[NSString stringWithFormat:@"%@ %@", [[SettingDataClass instance] getCurrencySymbol],[[AppDelegate instance] convertToThousandSeparator:[[[productData objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"regular_price"]]] salePrice:[NSString stringWithFormat:@"%@ %@", [[SettingDataClass instance] getCurrencySymbol],[[AppDelegate instance] convertToThousandSeparator:[[[productData objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"sale_price"]]] productInfo:productData];
                    }
                    
                }
            }
            
            [spinner removeFromSuperview];
            
            totalPage = [[categoryData objectForKey:@"total_page"] intValue];
            
            //Check total page more than 1
            if(currentPage < totalPage)
            {
                [self loadMore];
            }
            [scroller layoutWithSpeed:0.3 completion:nil];
            processing = NO;
            
            if([type isEqualToString:@"pagination"])
            {
                UIActivityIndicatorView *act = [[MiscInstances instance] getLoadMoreActivityView];
                [act stopAnimating];
                
                UILabel *loadMoreLbl = [[MiscInstances instance] getLoadMoreUILabel];
                loadMoreLbl.hidden = NO;
            }
        });
    });
}


-(void)loadProductDataByKeyWord:(NSString*)keyword page:(NSString*)page postPerPage:(NSString*)postPerPage type:(NSString*)type{
    
    if([type isEqualToString:@"pagination"])
    {
        UIActivityIndicatorView *act = [[MiscInstances instance] getLoadMoreActivityView];
        [act startAnimating];
        
        UILabel *loadMoreLbl = [[MiscInstances instance] getLoadMoreUILabel];
        loadMoreLbl.hidden = YES;
    }
    
    if([type isEqualToString:@"chooseCategory"])
    {
        [spinner startAnimating];
        for(int i = [scroller.boxes count]-1;i>0;i--)
        {
            NSLog(@"i is %d",i);
            if(i == 0)
            {
                
            }
            else
            {
                [scroller.boxes removeObjectAtIndex:i];
            }
        }
    }
    
    [self loadingIndicator];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        
        processing = YES;
        NSDictionary *categoryData = [[DataService instance] getProductByKeyword:keyword page:page productPerPage:postPerPage];
        productByCategoriesData = [categoryData objectForKey:@"products"];
        
        //Get categories Data
        if([type isEqualToString:@"pagination"])
        {
            [scroller.boxes removeObjectAtIndex:[scroller.boxes count]-1];
        }
        else if([type isEqualToString:@"start"])
        {
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            if([productByCategoriesData count] > 0)
            {
                for (int i = 0; i<[productByCategoriesData count]; i++)
                {
                    NSDictionary *productData = [productByCategoriesData objectAtIndex:i];
                    
                    
                    if([[[productData objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"grouped"])
                    {
                        [self gridStyleNormal:[[productData objectForKey:@"product_gallery"] objectForKey:@"featured_images"] title:[[productData objectForKey:@"general"] objectForKey:@"title"] priceRegular:[NSString stringWithFormat:@"%@ %@ %@",NSLocalizedString(@"group_and_variable_pricing", nil), [[SettingDataClass instance] getCurrencySymbol],[[[productData objectForKey:@"if_group"] objectForKey:@"min_price"] objectForKey:@"price"]] productInfo:productData];
                    }
                    else if([[[productData objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"variable"])
                    {
                        [self gridStyleNormal:[[productData objectForKey:@"product_gallery"] objectForKey:@"featured_images"] title:[[productData objectForKey:@"general"] objectForKey:@"title"] priceRegular:[NSString stringWithFormat:@"%@ %@ %@",NSLocalizedString(@"group_and_variable_pricing", nil), [[SettingDataClass instance] getCurrencySymbol],[[[productData objectForKey:@"if_variants"] objectForKey:@"min_price"] objectForKey:@"price"]] productInfo:productData];
                    }
                    else
                    {
                        NSNumber *boolean = (NSNumber *)[[[productData objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"is_on_sale"];
                        NSLog(@"Get ti %@",boolean);
                        if([boolean boolValue] == FALSE)
                        {
                            
                            [self gridStyleNormal:[[productData objectForKey:@"product_gallery"] objectForKey:@"featured_images"] title:[[productData objectForKey:@"general"] objectForKey:@"title"] priceRegular:[NSString stringWithFormat:@"%@ %@", [[SettingDataClass instance] getCurrencySymbol],[[AppDelegate instance] convertToThousandSeparator:[[[productData objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"regular_price"]]] productInfo:productData];
                        }
                        else
                        {
                            NSLog(@"OnSale");
                            [self gridStyleOnSale:[[productData objectForKey:@"product_gallery"] objectForKey:@"featured_images"] title:[[productData objectForKey:@"general"] objectForKey:@"title"] priceRegular:[NSString stringWithFormat:@"%@ %@", [[SettingDataClass instance] getCurrencySymbol],[[AppDelegate instance] convertToThousandSeparator:[[[productData objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"regular_price"]]] salePrice:[NSString stringWithFormat:@"%@ %@", [[SettingDataClass instance] getCurrencySymbol],[[AppDelegate instance] convertToThousandSeparator:[[[productData objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"sale_price"]]] productInfo:productData];
                        }
                    }
                }
            }
            else
            {
                [self noProductInThisKeywordBox:globalCategoryID];
                
            }
            [spinner removeFromSuperview];
            
            totalPage = [[categoryData objectForKey:@"total_page"] intValue];
            
            //Check total page more than 1
            if(currentPage < totalPage)
            {
                [self loadMore];
            }
            [scroller layoutWithSpeed:0.3 completion:nil];
            processing = NO;
            
            if([type isEqualToString:@"pagination"])
            {
                UIActivityIndicatorView *act = [[MiscInstances instance] getLoadMoreActivityView];
                [act stopAnimating];
                
                UILabel *loadMoreLbl = [[MiscInstances instance] getLoadMoreUILabel];
                loadMoreLbl.hidden = NO;
            }
        });
    });
}


-(void)noProductInThisKeywordBox:(NSString*)keyword
{
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    [scroller.boxes addObject:section];
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    
    
    
    id body = [NSString stringWithFormat:@"%@ '%@'",NSLocalizedString(@"browse_view_no_product_found", nil),keyword];
    
    
    
    // stuff
    MGLineStyled *line = [MGLineStyled multilineWithText:body font:nil width:300
                                                 padding:UIEdgeInsetsMake(10, 10, 10, 10)];
    line.backgroundColor = [UIColor clearColor];
    line.borderStyle &= ~MGBorderEtchedBottom;
    [section.topLines addObject:line];
    
    
    
    
}


-(void)gridStyleOnSale:(NSString*)url title:(NSString*)str priceRegular:(NSString*)regularPrice salePrice:(NSString*)salePrice productInfo:(NSDictionary*)productInfo{
    MGBox *section =  MGBox.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    PhotoBox *box = [PhotoBox gridStyleOnSale:CGSizeMake(145, 165) img:url title:str priceRegular:regularPrice salePrice:salePrice];
    
    
    box.onTap = ^{
        
        DetailViewController *detail = [[DetailViewController alloc] init];
        [detail setProductInfo:productInfo];
        detail.title  = [[productInfo objectForKey:@"general"] objectForKey:@"title"];
        [self.navigationController pushViewController:detail animated:YES];
        
    };
    
    [section.boxes addObject:box];
}



-(void)gridStyleNormal:(NSString*)url title:(NSString*)str priceRegular:(NSString*)regularPrice productInfo:(NSDictionary*)productInfo{
    MGBox *section =  MGBox.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    BOOL isDisplayPrice = YES;
    
    NSArray *categories = [productInfo objectForKey:@"categories"];
    if ([categories count] > 0) {
        for (int i=0;i < [categories count];i++) {
            NSString *slug = [[categories objectAtIndex:i] objectForKey:@"slug"];
            if ([slug isEqualToString:@"ca-si"]) {
                isDisplayPrice = NO;
                break;
            }
        }
    }
    
    PhotoBox *box = [PhotoBox gridStyleNormal:CGSizeMake(145, 165) img:url title:str priceRegular:regularPrice displayPrice:isDisplayPrice];
    
    box.onTap = ^{
        
        DetailViewController *detail = [[DetailViewController alloc] init];
        [detail setProductInfo:productInfo];
        detail.title  = [[productInfo objectForKey:@"general"] objectForKey:@"title"];
        [self.navigationController pushViewController:detail animated:YES];
        
    };
    
    [section.boxes addObject:box];
}

-(void)chooseSubCategory {
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    PhotoBox *box = [PhotoBox chooseSubCategory:CGSizeMake(300, 30)];
    
    box.onTap = ^{
        popover.view.hidden = NO;
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
            currentPage = currentPage +1;
            [self loadProductDataByCategory:globalCategoryID page:[NSString stringWithFormat:@"%d",currentPage] postPerPage:WOO_PRODUCT_PERPAGE type:@"pagination"];
        }
    };
    
    [section.topLines addObject:box];
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




-(void)loadingIndicator {
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(150, 70, 24, 24);
    spinner.hidesWhenStopped = YES;
    
    [self.view addSubview:spinner];
    
    [spinner startAnimating];
}


-(void)subCategoryExe:(NSString*)categoryID{
    
    currentPage = 1;
    globalCategoryID = categoryID;
    [self loadProductDataByCategory:globalCategoryID page:[NSString stringWithFormat:@"%d",currentPage] postPerPage:WOO_PRODUCT_PERPAGE type:@"chooseCategory"];
    
}

//FFPopOverDelegate Method
- (void)popoverControllerDidDismissPopover:(FPPopoverController *)popoverController;
{
    
    NSLog(@"Done");
}


//UIScrollViewDelegate Method

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    initialContentOffset = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[SettingDataClass instance] autoHideGlobal:scrollView navigationView:self.navigationController contentOffset:initialContentOffset];
    
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
                [self loadProductDataByCategory:globalCategoryID page:[NSString stringWithFormat:@"%d",currentPage] postPerPage:WOO_PRODUCT_PERPAGE type:@"pagination"];
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
