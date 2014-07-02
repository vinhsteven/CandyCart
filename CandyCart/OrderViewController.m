//
//  OrderViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/13/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "OrderViewController.h"

@interface OrderViewController ()

@end

@implementation OrderViewController

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
    
    self.title = NSLocalizedString(@"order_title_label", nil);
    
    scroller = [[MGScrollView alloc] initWithFrame:[[DeviceClass instance] getResizeScreen:NO]];
    scroller.bottomPadding = 8;
    scroller.contentLayoutMode = MGLayoutGridStyle;
    scroller.delegate = self;
    scroller.alwaysBounceVertical = YES;
    
    [self.view addSubview:scroller];
    
    if(noCloseBtn == YES)
    {
    }
    else
    {
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(self.view.frame.size.width - 69, 8, 63, 30);
        closeBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [closeBtn setTitle:NSLocalizedString(@"order_close_btn", nil) forState:UIControlStateNormal];
        [closeBtn addTarget:self
                     action:@selector(closeBtnExe)
           forControlEvents:UIControlEventTouchDown];
        
        [closeBtn setNuiClass:@"UiBarButtonItem"];
        [closeBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        
        UIBarButtonItem *button = [[UIBarButtonItem alloc]
                                   initWithCustomView:closeBtn];
        self.navigationItem.leftBarButtonItem = button;
    }
    
    payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(self.view.frame.size.width - 69, 8, 63, 30);
    payBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [payBtn setTitle:NSLocalizedString(@"order_pay_btn", nil) forState:UIControlStateNormal];
    [payBtn addTarget:self
               action:@selector(payBtnExe)
     forControlEvents:UIControlEventTouchDown];
    
    [payBtn setNuiClass:@"UiBarButtonItem"];
    [payBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    payBtnItem = [[UIBarButtonItem alloc]
                  initWithCustomView:payBtn];
    
    
    orderNotes = [UIButton buttonWithType:UIButtonTypeCustom];
    orderNotes.frame = CGRectMake(self.view.frame.size.width - 69, 8, 63, 30);
    orderNotes.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [orderNotes setTitle:NSLocalizedString(@"orderViewController_order_notes_btn_title", nil) forState:UIControlStateNormal];
    [orderNotes addTarget:self
                   action:@selector(notesAction)
         forControlEvents:UIControlEventTouchDown];
    
    [orderNotes setNuiClass:@"UiBarButtonItem"];
    [orderNotes.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    orderNotesBtnItems = [[UIBarButtonItem alloc]
                          initWithCustomView:orderNotes];
    
    
}



-(void)notesAction
{
    OrderNotesViewController *notes = [[OrderNotesViewController alloc] init];
    [self.navigationController pushViewController:notes animated:YES];
}


-(void)noCloseBtn{
    noCloseBtn = YES;
}

-(void)closeBtnExe{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [[[MainViewClass instance] cartNav] popToRootViewControllerAnimated:YES];
    }];
}

-(void)payBtnExe{
    
    PaymentWebViewController *payment = [[PaymentWebViewController alloc] init];
    [payment setOrderViewController:self];
    UINavigationController *paymentNav = [[UINavigationController alloc] initWithRootViewController:payment];
    NSLog(@"post = %@",[NSString stringWithFormat:@"%@/?candycart=json-api&type=mobile-payment-redirect-api&orderKey=%@&orderID=%@&paymentMethodID=%@",[[AppDelegate instance] getUrl],
                        [[[MyOrderClass instance] getMyOrder] objectForKey:@"order_key"],
                        [[[MyOrderClass instance] getMyOrder] objectForKey:@"orderID"],
                        [[[MyOrderClass instance] getMyOrder] objectForKey:@"payment_method_id"]
                        ]);
    [payment loadUrlInWebView:[NSString stringWithFormat:@"%@/?candycart=json-api&type=mobile-payment-redirect-api&orderKey=%@&orderID=%@&paymentMethodID=%@",[[AppDelegate instance] getUrl],
                               [[[MyOrderClass instance] getMyOrder] objectForKey:@"order_key"],
                               [[[MyOrderClass instance] getMyOrder] objectForKey:@"orderID"],
                               [[[MyOrderClass instance] getMyOrder] objectForKey:@"payment_method_id"]
                               ]];
    [self presentViewController:paymentNav animated:YES completion:nil];
    
}


-(void)viewDidAppear:(BOOL)animated{
    
    [self viewCompile];
    [self.view setNeedsDisplay];
}


-(void)viewCompile{
    
    [scroller.boxes removeAllObjects];
    [payBtn removeFromSuperview];
    
    NSDictionary *status = [[MyOrderClass instance] getMyOrder];
    
    [self date:[status objectForKey:@"orderDate"]];
    [self setPaymentMethod];
    
    if([[status objectForKey:@"status"] isEqualToString:@"on-hold"])
    {
        NSString *paymentDesc;
        if ([[status objectForKey:@"payment_desc"] isKindOfClass:[NSNull class]])
            paymentDesc = @"";
        else
            paymentDesc = [status objectForKey:@"payment_desc"];
        //        [self shortDesc:[status objectForKey:@"payment_desc"]];
        [self shortDesc:paymentDesc];
    }
    [self lblBox:NSLocalizedString(@"order_id_label", nil) value:[NSString stringWithFormat:@"#%@",[status objectForKey:@"orderID"]]];
    
    //change language for status
    NSString *statusStr = [status objectForKey:@"status"];
    if ([statusStr isEqualToString:@"All"])
        statusStr = NSLocalizedString(@"status_list.all", nil);
    else if ([statusStr isEqualToString:@"pending"])
        statusStr = NSLocalizedString(@"status_list.pending", nil);
    else if ([statusStr isEqualToString:@"failed"])
        statusStr = NSLocalizedString(@"status_list.failed", nil);
    else if ([statusStr isEqualToString:@"on-hold"])
        statusStr = NSLocalizedString(@"status_list.on-hold", nil);
    else if ([statusStr isEqualToString:@"processing"])
        statusStr = NSLocalizedString(@"status_list.processing", nil);
    else if ([statusStr isEqualToString:@"completed"])
        statusStr = NSLocalizedString(@"status_list.completed", nil);
    else if ([statusStr isEqualToString:@"refunded"])
        statusStr = NSLocalizedString(@"status_list.refunded", nil);
    else if ([statusStr isEqualToString:@"cancelled"])
        statusStr = NSLocalizedString(@"status_list.cancelled", nil);
    
    [self lblBox:NSLocalizedString(@"order_status_label", nil) value:statusStr];
    
    [self lblBox:NSLocalizedString(@"order_email_label", nil) value:[status objectForKey:@"billing_email"]];
    [self lblBox:NSLocalizedString(@"order_phone_label", nil) value:[status objectForKey:@"billing_phone"]];
    [self lblBoxAddress:NSLocalizedString(@"order_billing_address_label", nil) value:[NSString stringWithFormat:@"%@",[status objectForKey:@"billing_address"]]];
    [self lblBoxAddress:NSLocalizedString(@"order_shipping_address_label", nil) value:[NSString stringWithFormat:@"%@",[status objectForKey:@"shipping_address"]]];
    
    NSString *orderNotess = [NSString stringWithFormat:@"%@",[status objectForKey:@"order_note"]];
    if([orderNotess length] > 0)
    {
        [self shortDesc:orderNotess];
    }
    
    [self setCartItemView];
    [self totalBox];
    [self totalPrice];
    
    [scroller layoutWithSpeed:0.3 completion:nil];
    
    if([[status objectForKey:@"status"] isEqualToString:@"pending"] || [[status objectForKey:@"status"] isEqualToString:@"failed"])
    {
        
        //self.navigationItem.rightBarButtonItem = payBtnItem;
    }
    else
    {
        
        self.navigationItem.rightBarButtonItem = orderNotesBtnItems;
        
    }
    
}

-(void)lblBoxAddress:(NSString*)lbl value:(NSString*)value{
    
    MGBox *section =  MGBox.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    MyCartBox *box = [MyCartBox halfAddressBox:CGSizeMake(145, 150) lbl:lbl value:value];
    
    [section.boxes addObject:box];
}

-(void)lblBox:(NSString*)lbl value:(NSString*)value{
    
    MGBox *section =  MGBox.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    MyCartBox *box = [MyCartBox halfBox:CGSizeMake(145, 50) lbl:lbl value:value];
    
    [section.boxes addObject:box];
}

-(void)setCartItemView{
    
    NSDictionary *order = [[MyOrderClass instance] getMyOrder];
    
    NSArray *incart = [[[MyOrderClass instance] getMyOrder] objectForKey:@"items"];
    
    for(int i=0;i<[incart count];i++)
    {
        NSDictionary *product = [incart objectAtIndex:i];
        __block NSString *productPrice;
        __block NSString *totalPrice;
        __block BOOL hasTax;
        
        //kiem tra co phai la item co' attribute hay ko? Neu phai, thi hien thi them ten attribute trong title
        
        NSString *variationId = [product objectForKey:@"variation_id"];
        if (variationId != nil) {
            NSString *attributeValue = @"";
            NSArray *attributeInfo = [product objectForKey:@"product_attribute"];
            
            if (attributeInfo != nil) {
                for (int i=0;i < [attributeInfo count];i++) {
                    NSDictionary *attributeDict = [attributeInfo objectAtIndex:i];
                    attributeValue = [attributeValue stringByAppendingFormat:@"%@,",[attributeDict objectForKey:@"value"]];
                }
                attributeValue = [attributeValue substringToIndex:attributeValue.length-1];
            }
            
            if([[order objectForKey:@"tax_total"] floatValue] > 0)
            {
                if([[order objectForKey:@"display-price-during-cart-checkout"] isEqualToString:@"incl"])
                {
                    productPrice = [NSString stringWithFormat:@"%.2f",[[product objectForKey:@"product_price"] floatValue]];
                    
                    totalPrice = [NSString stringWithFormat:@"%.2f",[[product objectForKey:@"total_price"] floatValue]];
                    hasTax = NO;
                }
                else
                {
                    productPrice = [NSString stringWithFormat:@"%.2f",[[product objectForKey:@"product_price_ex_tax"] floatValue]];
                    
                    totalPrice = [NSString stringWithFormat:@"%.2f",[[product objectForKey:@"total_price_ex_tax"] floatValue]];
                    hasTax = YES;
                    
                }
            }
            else
            {
                productPrice = [NSString stringWithFormat:@"%.2f",[[product objectForKey:@"product_price"] floatValue]];
                totalPrice = [NSString stringWithFormat:@"%.2f",[[product objectForKey:@"total_price"] floatValue]];
                hasTax = NO;
            }
            
            [self
             cartItem:[[product objectForKey:@"product_info"] objectForKey:@"featuredImages"]
             productTitle:[NSString stringWithFormat:@"(%@) %@",attributeValue,[[product objectForKey:@"product_info"] objectForKey:@"productName"]]
             currency: [[SettingDataClass instance] getCurrencySymbol]
             price:productPrice
             quantity:[product objectForKey:@"quantity"]
             totalPrice:totalPrice
             has_tax:hasTax
             productID:[product objectForKey:@"product_id"]
             ];
        }
    }
    
    NSArray *couponArray = [[[MyOrderClass instance] getMyOrder] objectForKey:@"used_coupon"];
    
    for(int i=0;i<[couponArray count];i++)
    {
        NSString *ser = [NSString stringWithFormat:@"%@",[couponArray objectAtIndex:i]] ;
        
        [self coupon:[NSString stringWithFormat:@"%@",ser]];
    }
}


-(void)totalBox{
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    [scroller.boxes addObject:section];
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    MGLineStyled *cutSubTotal;
    
    NSDictionary *order = [[MyOrderClass instance] getMyOrder];
    BOOL hasTax;
    NSString *lineWithLeft;
    NSString *subtotal;
    
    NSString *currency =  [[SettingDataClass instance] getCurrencySymbol];
    
    if([[order objectForKey:@"tax_total"] floatValue] > 0)
    {
        if([[order objectForKey:@"display-price-during-cart-checkout"] isEqualToString:@"incl"])
        {
            hasTax = NO;
            lineWithLeft = NSLocalizedString(@"checkout_label_subtotal", nil);
            subtotal = [order objectForKey:@"subtotalWithTax"];
        }
        else
        {   
            hasTax = YES;
            lineWithLeft = NSLocalizedString(@"checkout_label_subtotal_without_tax", nil);
            subtotal = [order objectForKey:@"subtotalExTax"];
        }
    }
    else
    {
        hasTax = NO;
        lineWithLeft = NSLocalizedString(@"checkout_label_subtotal", nil);
        subtotal = [order objectForKey:@"subtotalWithTax"];
    }
    
    cutSubTotal = [MGLineStyled lineWithLeft:lineWithLeft
                                       right:[NSString stringWithFormat:@"%@ %@",currency,[[AppDelegate instance] convertToThousandSeparator:[NSString stringWithFormat:@"%f",[subtotal floatValue]]]] size:CGSizeMake(300, 29)];
    
    
    cutSubTotal.font = [UIFont fontWithName:PRIMARYFONT size:12];
    [section.topLines addObject:cutSubTotal];
    
    
    MGLineStyled
    *shipping = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"%@",NSLocalizedString(@"checkout_label_shipping_method_and_cost", nil)]
                                     right:[NSString stringWithFormat:@"%@ : %@ %@",[order objectForKey:@"shipping_method"],currency,[[AppDelegate instance] convertToThousandSeparator:[NSString stringWithFormat:@"%f",[[order objectForKey:@"shipping_cost"] floatValue]]]] size:CGSizeMake(300, 29)];
    shipping.font = [UIFont fontWithName:PRIMARYFONT size:12];
    [section.topLines addObject:shipping];
    
    
    if(hasTax == YES)
    {
        float price = [[order objectForKey:@"tax_total"] floatValue];
        MGLineStyled *tax;
        tax = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"%@",NSLocalizedString(@"checkout_label_tax", nil)]
                                   right:[NSString stringWithFormat:@"%@ %@",currency,[[AppDelegate instance] convertToThousandSeparator:[NSString stringWithFormat:@"%f",price]]] size:CGSizeMake(300, 29)];
        tax.font = [UIFont fontWithName:PRIMARYFONT size:12];
        [section.topLines addObject:tax];
    }
    
    float price = [[order objectForKey:@"discount_total"] floatValue];
    if(price != 0)
    {
        MGLineStyled *discount;
        discount = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"%@",NSLocalizedString(@"checkout_label_discount", nil)]
                                        right:[NSString stringWithFormat:@"- %@ %@",currency,[[AppDelegate instance] convertToThousandSeparator:[NSString stringWithFormat:@"%f",price]]] size:CGSizeMake(300, 29)];
        discount.font = [UIFont fontWithName:PRIMARYFONT size:12];
        [section.topLines addObject:discount];
    }
}

-(void)date:(NSString*)date{
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    MyCartBox *box;
    
    box = [MyCartBox date:NSLocalizedString(@"order_date_label", nil) date:date];
    [section.topLines addObject:box];
}




-(void)totalPrice{
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    MyCartBox *box;
    
    NSDictionary *order = [[MyOrderClass instance] getMyOrder];
    
    NSString *currency =  [[SettingDataClass instance] getCurrencySymbol];
    
    if([[order objectForKey:@"tax_total"] floatValue] > 0)
    {
        if([[order objectForKey:@"display-price-during-cart-checkout"] isEqualToString:@"incl"])
        {
            
            box = [MyCartBox totalPrice:NSLocalizedString(@"checkout_label_grand_total", nil) currency:currency totalPrice:[[order objectForKey:@"order_total"] floatValue] include_tax:YES tax:[NSString stringWithFormat:@"%@ %@ %.2f %@",NSLocalizedString(@"checkout_label_grand_total_with_include_tax_below_1", nil),currency,[[order objectForKey:@"tax_total"] floatValue],NSLocalizedString(@"checkout_label_grand_total_with_include_tax_below_2", nil)]];
            
        }
        else
        {
            box = [MyCartBox preTotal:NSLocalizedString(@"checkout_label_grand_total", nil) currency:currency totalPrice:[[order objectForKey:@"order_total"] floatValue]];
        }
    }
    else
    {
        box = [MyCartBox preTotal:NSLocalizedString(@"checkout_label_grand_total", nil) currency:currency totalPrice:[[order objectForKey:@"order_total"] floatValue]];
    }
    
    [section.topLines addObject:box];
}


-(void)setPaymentMethod{
    
    // NSDictionary *reviewData = [[MyCartClass instance] getServerCart];
    
    //NSArray *paymentMethod = [reviewData objectForKey:@"payment-method"];
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    
    MyCartBox *box = [MyCartBox paymentMethodNoArrow:CGSizeMake(300, 34)];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, box.size.width, box.size.height)];
    
    [lbl setNuiClass:@"inventory"];
    
    NSDictionary *order = [[MyOrderClass instance] getMyOrder];
    
    lbl.text = [NSString stringWithFormat:@"%@ : %@",NSLocalizedString(@"order_label_payment_method", nil),[order objectForKey:@"payment_method_title"]];
    lbl.textAlignment = NSTextAlignmentLeft;
    
    [box addSubview:lbl];
    
    [section.topLines addObject:box];
}

-(void)shortDesc:(NSString*)desc
{
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    [scroller.boxes addObject:section];
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    
    id body = [NSString stringWithFormat:@"%@",[[ToolClass instance] decodeHTMLCharacterEntities:desc]];
    
    // stuff
    MGLineStyled *line = [MGLineStyled multilineWithText:body font:nil width:300
                                                 padding:UIEdgeInsetsMake(10, 10, 10.0, 10.0)];
    line.backgroundColor = [UIColor clearColor];
    line.font = [UIFont fontWithName:PRIMARYFONT size:11];
    [section.topLines addObject:line];
}

-(void)cartItem:(NSString*)featuredImage productTitle:(NSString*)title currency:(NSString*)currency price:(NSString*)price quantity:(NSString*)quantity totalPrice:(NSString*)totalPrice has_tax:(BOOL)has_tax productID:(NSString*)productID{
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    
    MyCartBox *box = [MyCartBox cartItemServer:featuredImage productTitle:title currency:currency price:price quantity:quantity totalPrice:totalPrice has_tax:has_tax];
    
    [section.topLines addObject:box];
}



-(void)coupon:(NSString*)couponCode{
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    MyCartBox *box = [MyCartBox coupon:NSLocalizedString(@"checkout_label_coupon", nil) couponCode:couponCode];
    
    [section.topLines addObject:box];
    
    UIImageView *deleteIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NSLocalizedString(@"image_delete_icon", nil)]];
    deleteIcon.frame = CGRectMake(277, 5, 20, 20);
    deleteIcon.hidden = YES;
    deleteIcon.userInteractionEnabled = YES;
    [section addSubview:deleteIcon];
    
    UserDataTapGestureRecognizer *singleTap = [[UserDataTapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteCouponExe:)];
    singleTap.userData = couponCode;
    [deleteIcon addGestureRecognizer:singleTap];
}

-(void)succsessfulMsg:(NSString*)msg{
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    MyCartBox *box = [MyCartBox coupon:msg couponCode:@""];
    
    [section.topLines addObject:box];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollViews
{
    initialContentOffset = scrollViews.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollViews
{
    
    [[SettingDataClass instance] autoHideGlobal:scrollViews navigationView:self.navigationController contentOffset:initialContentOffset];
}


-(void)refreshOrderPaymentSuccessful{
    NSLog(@"Successful");
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD showWhileExecuting:@selector(refreshOrderPaymentSuccessfulExe) onTarget:self withObject:nil animated:YES];
    
}

-(void)refreshOrderFailed{
    NSLog(@"Failed");
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD showWhileExecuting:@selector(refreshOrderFailedExe) onTarget:self withObject:nil animated:YES];
}

-(void)refreshOrderFailedExe{
    NSDictionary *statusTemp = [[MyOrderClass instance] getMyOrder];
    NSDictionary *newData = [[DataService instance] get_single_order:[UserAuth instance].username password:[UserAuth instance].password orderID:[NSString stringWithFormat:@"%@",[statusTemp objectForKey:@"orderID"]]];
    
    [[MyOrderClass instance] setMyOrder:newData];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        
        [self viewCompile];
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)
                                                       message: NSLocalizedString(@"order_fail_payment", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil)
                              ,nil];
        
        
        [alert show];
        
    });
}


-(void)refreshOrderPaymentSuccessfulExe{
    NSDictionary *statusTemp = [[MyOrderClass instance] getMyOrder];
    NSDictionary *newData = [[DataService instance] get_single_order:[UserAuth instance].username password:[UserAuth instance].password orderID:[NSString stringWithFormat:@"%@",[statusTemp objectForKey:@"orderID"]]];
    
    [[MyOrderClass instance] setMyOrder:newData];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self viewCompile];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)
                                                       message: NSLocalizedString(@"order_successful_payment", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil)
                              ,nil];
        
        
        [alert show];
    });
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
