//
//  CartViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/1/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "CartViewController.h"
#import "ListBuyMethod.h"

@interface CartViewController ()

@end

@implementation CartViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"tabb_bar_cart", nil);
        self.tabBarItem.image = [UIImage imageNamed:NSLocalizedString(@"tabb_bar_cart_image", nil)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setNuiClass:@"ViewInit"];
    // Do any additional setup after loading the view from its nib.
    
    scroller = [[MGScrollView alloc] initWithFrame:[[DeviceClass instance] getResizeScreen:NO]];
    scroller.bottomPadding = 8;
    
    scroller.delegate = self;
    scroller.alwaysBounceVertical = YES;
    
    [self.view addSubview:scroller];
    
    
    btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNext.frame = CGRectMake(self.view.frame.size.width - 69, 8, 63, 30);
    btnNext.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [btnNext setTitle:NSLocalizedString(@"cart_next_btn_title", nil) forState:UIControlStateNormal];
    [btnNext addTarget:self
             action:@selector(nextBtnAction)
    forControlEvents:UIControlEventTouchDown];
    
    [btnNext setNuiClass:@"UiBarButtonItem"];
    [btnNext.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithCustomView:btnNext];
    self.navigationItem.rightBarButtonItem = button;
    
    //add popover when tap Next
    ListBuyMethod *controller = [[ListBuyMethod alloc] init];
    controller.parent = self;
    
    popover = [[FPPopoverController alloc] initWithViewController:controller];
    
    popover.border = NO;
    popover.delegate = self;
    popover.contentSize = CGSizeMake(200,160);
    [popover.view setNuiClass:@"DropDownView"];
    [popover disableDismissOutside:YES];
    
    [popover presentPopoverFromView:btnNext];
    popover.view.hidden = YES;
}

-(void)nextBtnAction{
    if([[MyCartClass instance] countProduct] > 0) {
        
        if([[UserAuth instance] checkUserIfAlreadyLoggedInMobile] == YES)
        {
            BillingCheckOutViewController *billing = [[BillingCheckOutViewController alloc] init];
            [self.navigationController pushViewController:billing animated:YES];
        }
        else {
            popover.view.hidden = NO;
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)
                              
                                                       message: NSLocalizedString(@"cart_error_empty", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        [alert show];
    }
    
    /*
    if([[MyCartClass instance] countProduct] > 0)
    {
        if([[UserAuth instance] checkUserIfAlreadyLoggedInMobile] == YES)
        {
            BillingCheckOutViewController *billing = [[BillingCheckOutViewController alloc] init];
            [self.navigationController pushViewController:billing animated:YES];
        }
        else
        {
            [self autoLogin];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)
                              
                                                       message: NSLocalizedString(@"cart_error_empty", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        [alert show];
    }
     */
}


-(void)autoLogin{
    if([[UserAuth instance] checkUserAlreadyLogged] == YES)
    {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.delegate = self;
        [HUD showWhileExecuting:@selector(autoLoginExe) onTarget:self withObject:nil animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)
                                                       message: NSLocalizedString(@"cart_error_need_login", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
    }
}

-(void)autoLoginExe{
    dispatch_queue_t queue = dispatch_queue_create("com.nhuanquang.autoLoginExe", NULL);
    dispatch_async(queue, ^(void) {
        NSDictionary * user_data = [[DataService instance] user_login:[UserAuth instance].username password:[UserAuth instance].password];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if([[user_data objectForKey:@"status"] intValue] == 0)
            {
                //Successful Logged
                [[UserAuth instance] setUserDatas:[user_data objectForKey:@"user"]];
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    BillingCheckOutViewController *billing = [[BillingCheckOutViewController alloc] init];
                    [self.navigationController pushViewController:billing animated:YES];
                });
            }
            else
            {
                //Not SuccessFull
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)
                                                                   message: NSLocalizedString(@"general_notification_error_loginwaschange", nil)
                                                                  delegate: nil
                                                         cancelButtonTitle:nil
                                                         otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil)
                                          ,nil];
                    
                    
                    [alert show];
                });
            }
        });
    });
}


-(void)viewDidAppear:(BOOL)animated{
    
    [scroller.boxes removeAllObjects];
    [self setCartItemView];
    [[MyCartClass instance] countCartTabBar];
}

-(void)setCartItemView{
    
    NSMutableArray *incart = [[MyCartClass instance] getMyCartArray];
    NSString *thisMethodCurrency;
    
    if([incart count] == 0)
    {
        [self emptyCart:NSLocalizedString(@"cart_error_empty", nil)];
    }
    else
    {
        for(int i=0;i<[incart count];i++)
        {
            
            if([[[incart objectAtIndex:i] objectAtIndex:0] isEqualToString:@"simple"])
            {
                NSDictionary *productInfo = [[incart objectAtIndex:i] objectAtIndex:3];
                
                NSNumber *boolean = (NSNumber *)[[[productInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"is_on_sale"];
                if([boolean boolValue] == FALSE)
                {
                    [self
                     cartItem:[[productInfo objectForKey:@"product_gallery"] objectForKey:@"featured_images"]
                     productTitle:[[productInfo objectForKey:@"general"] objectForKey:@"title"]
                     currency: [[SettingDataClass instance] getCurrencySymbol]
                     price:[[[productInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"regular_price"]
                     quantity:[[incart objectAtIndex:i] objectAtIndex:2]
                     productID:[productInfo objectForKey:@"product_ID"]
                     ];
                    thisMethodCurrency =  [[SettingDataClass instance] getCurrencySymbol];
                }
                else
                {
                    [self
                     cartItem:[[productInfo objectForKey:@"product_gallery"] objectForKey:@"featured_images"]
                     productTitle:[[productInfo objectForKey:@"general"] objectForKey:@"title"]
                     currency: [[SettingDataClass instance] getCurrencySymbol]
                     price:[[[productInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"sale_price"]
                     quantity:[[incart objectAtIndex:i] objectAtIndex:2]
                     productID:[productInfo objectForKey:@"product_ID"]
                     ];
                    thisMethodCurrency =  [[SettingDataClass instance] getCurrencySymbol];
                }
            }
            else
            {
                NSDictionary *productInfo = [[incart objectAtIndex:i] objectAtIndex:3];
                NSDictionary *parentInfo = [[incart objectAtIndex:i] objectAtIndex:5];
                
                //Check Variable Featured Image. If not available use parent featured image
                NSString *featuredImage;
                if([[productInfo objectForKey:@"featured_images"] isEqualToString:@"0"])
                {
                    
                    featuredImage = [NSString stringWithFormat:@"%@",[[parentInfo objectForKey:@"product_gallery"] objectForKey:@"featured_images"]];
                }
                else
                {
                    featuredImage = [productInfo objectForKey:@"featured_images"];
                }
                
                NSNumber *boolean = (NSNumber *)[[[productInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"is_on_sale"];
                if([boolean boolValue] == FALSE)
                {
                    [self
                     cartItem:featuredImage
                     productTitle:[[parentInfo objectForKey:@"general"] objectForKey:@"title"]
                     currency: [[SettingDataClass instance] getCurrencySymbol]
                     price:[[[productInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"regular_price"]
                     quantity:[[incart objectAtIndex:i] objectAtIndex:2]
                     productID:[productInfo objectForKey:@"product_ID"]
                     ];
                    
                    thisMethodCurrency =  [[SettingDataClass instance] getCurrencySymbol];
                }
                else
                {
                    [self
                     cartItem:featuredImage
                     productTitle:[[parentInfo objectForKey:@"general"] objectForKey:@"title"]
                     currency: [[SettingDataClass instance] getCurrencySymbol]
                     price:[[productInfo  objectForKey:@"pricing"] objectForKey:@"sale_price"]
                     quantity:[[incart objectAtIndex:i] objectAtIndex:2]
                     productID:[productInfo objectForKey:@"product_ID"]
                     ];
                    
                    thisMethodCurrency =  [[SettingDataClass instance] getCurrencySymbol];
                }
            }
            
        }
        [self preTotalPrice:thisMethodCurrency];
    }
    [scroller layoutWithSpeed:0.3 completion:nil];
    
}

-(void)cartItem:(NSString*)featuredImage productTitle:(NSString*)title currency:(NSString*)currency price:(NSString*)price quantity:(NSString*)quantity productID:(NSString*)productID{
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    MyCartBox *box = [MyCartBox cartItem:featuredImage productTitle:title currency:currency price:price quantity:quantity];
    
    [section.topLines addObject:box];
    
    UIImageView *deleteIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"deleteIcon.png"]];
    deleteIcon.frame = CGRectMake(257, 10, 30, 30);
    deleteIcon.hidden = YES;
    deleteIcon.userInteractionEnabled = YES;
    [section addSubview:deleteIcon];
    
    UserDataTapGestureRecognizer *singleTap = [[UserDataTapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteExe:)];
    singleTap.userData = productID;
    [deleteIcon addGestureRecognizer:singleTap];
    
    box.swiper.direction = UISwipeGestureRecognizerDirectionLeft;
    MyCartBox *box2 = box;
    box.onSwipe = ^{
        if(box2.swiper.direction == UISwipeGestureRecognizerDirectionLeft)
        {
            
            box2.swiper.direction = UISwipeGestureRecognizerDirectionRight;
            
            deleteIcon.hidden = NO;
            deleteIcon.alpha = 0;
            [UIView animateWithDuration:0.2 animations:^{
                box2.x = -60;
                deleteIcon.alpha = 100;
            }];
        }
        else
        {
            
            
            box2.swiper.direction = UISwipeGestureRecognizerDirectionLeft;
            [UIView animateWithDuration:0.2 animations:^{
                box2.x = 0;
            } completion:^ (BOOL finished)
             {
                 deleteIcon.hidden = YES;
                 
             }];
        }
    };
    
    
    box.onTap = ^{
        
        NSArray *productInfo =[[MyCartClass instance] getProductInCartInfo:productID];
        
        DetailViewController *detail = [[DetailViewController alloc] init];
        
        if([[productInfo objectAtIndex:0] isEqualToString:@"simple"])
        {
            [detail setProductInfo:[productInfo objectAtIndex:3]];
            detail.title  = [[[productInfo objectAtIndex:3] objectForKey:@"general"] objectForKey:@"title"];
        }
        else
        {
            [detail setProductInfo:[productInfo objectAtIndex:5]];
            detail.title  = [[[productInfo objectAtIndex:5] objectForKey:@"general"] objectForKey:@"title"];
        }
        
        [self.navigationController pushViewController:detail animated:YES];
        
    };
}

-(void)emptyCart:(NSString*)msg{
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    
    MyCartBox *box = [MyCartBox coupon:msg couponCode:@""];
    
    [section.topLines addObject:box];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    initialContentOffset = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[SettingDataClass instance] autoHideGlobal:scrollView navigationView:self.navigationController contentOffset:initialContentOffset];
}

-(void)deleteExe:(UserDataTapGestureRecognizer*)tap{
    
    NSString *productID = [NSString stringWithFormat:@"%@",tap.userData];
    [[MyCartClass instance] removeCartByProductID:productID];
    [scroller.boxes removeAllObjects];
    [self setCartItemView];
    
    [[MyCartClass instance] countCartTabBar];
    
}

-(void)preTotalPrice:(NSString*)currency{
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    MyCartBox *box = [MyCartBox preTotal:NSLocalizedString(@"cart_label_pre_total", nil) currency:currency totalPrice:[[MyCartClass instance] getTotalCartPrice]];
    
    [section.topLines addObject:box];
    
}


#pragma mark FPPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(FPPopoverController *)popoverController {
    
}

- (void) didSelectBuyMethod:(NSString*)type {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:type forKey:BUY_METHOD];
    if ([type isEqualToString:@"guest"]) {
        NSLog(@"guest");
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_queue_t queue = dispatch_queue_create("com.nhuanquang.autoLoginExe", NULL);
        dispatch_async(queue, ^(void) {
            NSDictionary * user_data = [[DataService instance] user_login:GUEST_USER password:GUEST_PASS];
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                if([[user_data objectForKey:@"status"] intValue] == 0)
                {
                    //Successful Logged
//                    [[UserAuth instance] setUserDatas:[user_data objectForKey:@"user"]];
                    [[UserAuth instance] setUserDatas:nil];
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        BillingCheckOutViewController *billing = [[BillingCheckOutViewController alloc] init];
                        [self.navigationController pushViewController:billing animated:YES];
                    });
                }
                
                [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
                popover.view.hidden = YES;
            });
        });

    }
    else {
        //buy as user
        NSLog(@"user");
    }
}

@end
