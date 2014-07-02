//
//  ReviewCheckOutViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/10/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "ReviewCheckOutViewController.h"

@interface ReviewCheckOutViewController ()

@end

@implementation ReviewCheckOutViewController

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
    self.title = NSLocalizedString(@"checkout_review_title", nil);
    scroller = [[MGScrollView alloc] initWithFrame:[[DeviceClass instance] getResizeScreen:NO]];
    scroller.bottomPadding = 8;
    
    scroller.delegate = self;
    scroller.alwaysBounceVertical = YES;
    
    [self.view addSubview:scroller];
    [self addCouponTextField];
    [self setCartItemView];
    [self totalBox];
    [self totalPrice];
    [self setPaymentMethod];
    [scroller layoutWithSpeed:0.3 completion:nil];
    
    already_choose_payment_method = NO;
    
    
    [[TempVariables instance] setReview_checkout:self];
    
    UIButton *order = [UIButton buttonWithType:UIButtonTypeCustom];
    order.frame = CGRectMake(self.view.frame.size.width - 69, 8, 100, 30);
    order.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [order setTitle:NSLocalizedString(@"checkout_review_order_now_btn_title", nil) forState:UIControlStateNormal];
    [order addTarget:self
              action:@selector(orderExe)
    forControlEvents:UIControlEventTouchDown];
    
    [order setNuiClass:@"UiBarButtonItem"];
    [order.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithCustomView:order];
    self.navigationItem.rightBarButtonItem = button;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.view setNeedsDisplay];
}

-(void)orderExe
{
    if(already_choose_payment_method == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)
                                                       message:NSLocalizedString(@"checkout_review_error_payment_method", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil)
                              ,nil];
        
        
        [alert show];
        
    }
    else
    {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.delegate = self;
        [HUD showWhileExecuting:@selector(placeAnOrderExe) onTarget:self withObject:nil animated:YES];
        
    }
    
}

-(void)placeAnOrderExe{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *orderStatus;
    NSLog(@"Order Notes : %@",[[MyCartClass instance] getOrderNotes]);
    
    if ([[userDefaults objectForKey:BUY_METHOD] isEqualToString:@"guest"]) {
        orderStatus = [[DataService instance] placeAnOrder:GUEST_USER password:GUEST_PASS productInJsonString:[[MyCartClass instance] productIDToJsonString] coupon:[[MyCartClass instance] couponToJsonString] paymentMethodID:paymentMethodID orderNotes:[[MyCartClass instance] getOrderNotes]];
    }
    else {
        orderStatus = [[DataService instance] placeAnOrder:[UserAuth instance].username password:[UserAuth instance].password productInJsonString:[[MyCartClass instance] productIDToJsonString] coupon:[[MyCartClass instance] couponToJsonString] paymentMethodID:paymentMethodID orderNotes:[[MyCartClass instance] getOrderNotes]];
    }

    NSLog(@"Order Notes : %@",[[MyCartClass instance] getOrderNotes]);
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        //Set Result data into My Order Class
        [[MyOrderClass instance] setMyOrder:orderStatus];
        
        //Init Our Cart
        [[[MyCartClass instance] getMyCartArray] removeAllObjects];
        [[[MyCartClass instance] getCouponCode] removeAllObjects];
        
        
        //[self.navigationController popToRootViewControllerAnimated:YES];
        //Call Order ViewController From Tab Bar
        
        [[MainViewClass instance] popupOrderViewController];
    });
}

-(void)setCartItemView{
    
    NSMutableArray *incart = [[MyCartClass instance] getMyCartArray];
    NSString *thisMethodCurrency;
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
                 price:[[MyCartClass instance] getProductCartInServerPrice:[productInfo objectForKey:@"product_ID"]]
                 quantity:[[incart objectAtIndex:i] objectAtIndex:2]
                 totalPrice:[[MyCartClass instance] getProductCartInServerTotalPrice:[productInfo objectForKey:@"product_ID"]] has_tax:[[MyCartClass instance] checkServerHasTax]
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
                 price:[[MyCartClass instance] getProductCartInServerPrice:[productInfo objectForKey:@"product_ID"]]
                 quantity:[[incart objectAtIndex:i] objectAtIndex:2]
                 totalPrice:[[MyCartClass instance] getProductCartInServerTotalPrice:[productInfo objectForKey:@"product_ID"]] has_tax:[[MyCartClass instance] checkServerHasTax]
                 productID:[productInfo objectForKey:@"product_ID"]
                 ];
                thisMethodCurrency =  [[SettingDataClass instance] getCurrencySymbol];
            }
        }
        else
        {
            NSDictionary *productInfo = [[incart objectAtIndex:i] objectAtIndex:3];
            NSDictionary *parentInfo = [[incart objectAtIndex:i] objectAtIndex:5];
            
            //kiem tra co phai la item co' attribute hay ko? Neu phai, thi hien thi them ten attribute trong title
            NSArray *attributeInfo = [productInfo objectForKey:@"product_attribute"];
            NSString *attributeValue = @"";
            if (attributeInfo != nil) {
                for (int i=0;i < [attributeInfo count];i++) {
                    NSDictionary *attributeDict = [attributeInfo objectAtIndex:i];
                    attributeValue = [attributeValue stringByAppendingFormat:@"%@,",[attributeDict objectForKey:@"value"]];
                }
                attributeValue = [attributeValue substringToIndex:attributeValue.length-1];
            }
            
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
                 productTitle:[NSString stringWithFormat:@"(%@) %@",attributeValue,[[parentInfo objectForKey:@"general"] objectForKey:@"title"]]
                 currency: [[SettingDataClass instance] getCurrencySymbol]
                 price:[[MyCartClass instance] getProductCartInServerPrice:[productInfo objectForKey:@"product_ID"]]
                 quantity:[[incart objectAtIndex:i] objectAtIndex:2]
                 totalPrice:[[MyCartClass instance] getProductCartInServerTotalPrice:[productInfo objectForKey:@"product_ID"]] has_tax:[[MyCartClass instance] checkServerHasTax]
                 productID:[productInfo objectForKey:@"product_ID"]
                 ];
                
                thisMethodCurrency =  [[SettingDataClass instance] getCurrencySymbol];
            }
            else
            {
                [self
                 cartItem:featuredImage
                 productTitle:[NSString stringWithFormat:@"(%@) %@",attributeValue,[[parentInfo objectForKey:@"general"] objectForKey:@"title"]]
                 currency: [[SettingDataClass instance] getCurrencySymbol]
                 price:[[MyCartClass instance] getProductCartInServerPrice:[productInfo objectForKey:@"product_ID"]]
                 quantity:[[incart objectAtIndex:i] objectAtIndex:2]
                 totalPrice:[[MyCartClass instance] getProductCartInServerTotalPrice:[productInfo objectForKey:@"product_ID"]] has_tax:[[MyCartClass instance] checkServerHasTax]
                 productID:[productInfo objectForKey:@"product_ID"]
                 ];
                
                thisMethodCurrency =  [[SettingDataClass instance] getCurrencySymbol];
            }
        }
    }
    
    NSMutableArray *couponArray = [[MyCartClass instance] getCouponCode];
    
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
    
    if([[MyCartClass instance] checkServerHasTax] == YES)
    {
        cutSubTotal = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"%@",NSLocalizedString(@"checkout_label_subtotal_without_tax", nil)]
                       right:[NSString stringWithFormat:@"%@ %@", [[SettingDataClass instance] getCurrencySymbol],[[AppDelegate instance] convertToThousandSeparator:[NSString stringWithFormat:@"%f",[[[MyCartClass instance] getServerCartValueByObjectKey:@"cart-subtotal-ex-tax"] floatValue]]]] size:CGSizeMake(300, 29)];
//                                           right:[NSString stringWithFormat:@"%@ %.2f", [[SettingDataClass instance] getCurrencySymbol],[[[MyCartClass instance] getServerCartValueByObjectKey:@"cart-subtotal-ex-tax"] floatValue]] size:CGSizeMake(300, 29)];
        
    }
    else
    {
        cutSubTotal = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"%@",NSLocalizedString(@"checkout_label_subtotal", nil)]
                       right:[NSString stringWithFormat:@"%@ %@", [[SettingDataClass instance] getCurrencySymbol],[[AppDelegate instance] convertToThousandSeparator:[NSString stringWithFormat:@"%f",[[[MyCartClass instance] getServerCartValueByObjectKey:@"cart-subtotal"] floatValue]]]] size:CGSizeMake(300, 29)];
//                                           right:[NSString stringWithFormat:@"%@ %.2f", [[SettingDataClass instance] getCurrencySymbol],[[[MyCartClass instance] getServerCartValueByObjectKey:@"cart-subtotal"] floatValue]] size:CGSizeMake(300, 29)];
    }
    cutSubTotal.font = [UIFont fontWithName:PRIMARYFONT size:12];
    [section.topLines addObject:cutSubTotal];
    
    
    //get shipping method
    NSString *shippingMethod = [[MyCartClass instance] getServerCartValueByObjectKey:@"shipping-method"];
    if ([shippingMethod isKindOfClass:[NSNull class]] )
        shippingMethod = @"Free Shipping";
    if ([shippingMethod isEqualToString:@"Free Shipping"]) {
        shippingMethod = NSLocalizedString(@"cart_review_free_shipping", nil);
    }
    
    MGLineStyled *shipping = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"%@",NSLocalizedString(@"checkout_label_shipping_method_and_cost", nil)]
                                     right:[NSString stringWithFormat:@"%@ : %@ %@",shippingMethod, [[SettingDataClass instance] getCurrencySymbol],[[AppDelegate instance] convertToThousandSeparator:[NSString stringWithFormat:@"%f",[[[MyCartClass instance] getServerCartValueByObjectKey:@"shipping-cost"] floatValue]]]] size:CGSizeMake(300, 29)];
    shipping.font = [UIFont fontWithName:PRIMARYFONT size:12];
    [section.topLines addObject:shipping];
    
    
    if([[MyCartClass instance] checkServerHasTax] == YES)
    {
        float price = [[[MyCartClass instance] getServerCartValueByObjectKey:@"cart-tax-total"] floatValue];
        MGLineStyled *tax;
        tax = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"%@",NSLocalizedString(@"checkout_label_tax", nil)]
               right:[NSString stringWithFormat:@"%@ %@",[[SettingDataClass instance] getCurrencySymbol],[[AppDelegate instance] convertToThousandSeparator:[NSString stringWithFormat:@"%f",price]]] size:CGSizeMake(300, 29)];
//                                   right:[NSString stringWithFormat:@"%@ %.2f",[[SettingDataClass instance] getCurrencySymbol],price] size:CGSizeMake(300, 29)];
        tax.font = [UIFont fontWithName:PRIMARYFONT size:12];
        [section.topLines addObject:tax];
    }
    
    float price = [[[MyCartClass instance] getServerCartValueByObjectKey:@"discount"] floatValue];
    if(price != 0)
    {
        MGLineStyled *discount;
        discount = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"%@",NSLocalizedString(@"checkout_label_discount", nil)]
                    right:[NSString stringWithFormat:@"- %@ %@", [[SettingDataClass instance] getCurrencySymbol],[[AppDelegate instance] convertToThousandSeparator:[NSString stringWithFormat:@"%f",price]]] size:CGSizeMake(300, 29)];
//                                        right:[NSString stringWithFormat:@"- %@ %.2f", [[SettingDataClass instance] getCurrencySymbol],price] size:CGSizeMake(300, 29)];
        discount.font = [UIFont fontWithName:PRIMARYFONT size:12];
        [section.topLines addObject:discount];
    }
}

-(void)totalPrice{
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    MyCartBox *box;
    if([[[MyCartClass instance] getServerCartValueByObjectKey:@"display-price-during-cart-checkout"] isEqualToString:@"incl"])
    {
        if([[[MyCartClass instance] getServerCartValueByObjectKey:@"has_tax"] isEqualToString:@"no"])
        {
            
            box = [MyCartBox preTotal:NSLocalizedString(@"checkout_label_grand_total", nil) currency: [[SettingDataClass instance] getCurrencySymbol] totalPrice:[[[MyCartClass instance] getServerCartValueByObjectKey:@"grand-total"] floatValue]];
        }
        else
        {
            box = [MyCartBox totalPrice:NSLocalizedString(@"checkout_label_grand_total", nil) currency: [[SettingDataClass instance] getCurrencySymbol] totalPrice:[[[MyCartClass instance] getServerCartValueByObjectKey:@"grand-total"] floatValue] include_tax:YES tax:[NSString stringWithFormat:@"%@ %@ %.2f %@",NSLocalizedString(@"checkout_label_grand_total_with_include_tax_below_1", nil), [[SettingDataClass instance] getCurrencySymbol],[[[MyCartClass instance] getServerCartValueByObjectKey:@"cart-tax-total"] floatValue],NSLocalizedString(@"checkout_label_grand_total_with_include_tax_below_2", nil)]];
        }
    }
    else
    {
        box = [MyCartBox preTotal:NSLocalizedString(@"checkout_label_grand_total", nil) currency: [[SettingDataClass instance] getCurrencySymbol] totalPrice:[[[MyCartClass instance] getServerCartValueByObjectKey:@"grand-total"] floatValue]];
    }
    
    [section.topLines addObject:box];
}


-(void)setPaymentMethod{
    
    NSDictionary *reviewData = [[MyCartClass instance] getServerCart];
    
    NSMutableArray *paymentMethod = [[reviewData objectForKey:@"payment-method"] mutableCopy];
    
    if ([paymentMethod count] == 0 || paymentMethod == nil) {
        NSDictionary *metaDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"hideit",[NSNumber numberWithInt:0],@"safari", nil];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"cart_review_cash_on_delivery_message",nil),@"Description",@"cod",@"id",metaDict,@"meta_key",NSLocalizedString(@"cart_review_cash_on_delivery_title",nil),@"title", nil];
        [paymentMethod addObject:dict];
    }
    
    NSMutableArray *arrayNew = [[NSMutableArray alloc] init];
    
    for(int i=0;i<[paymentMethod count];i++)
    {
        int hideit = [[[[paymentMethod objectAtIndex:i] objectForKey:@"meta_key"] objectForKey:@"hideit"] intValue];
        if(hideit == 0)
        {
            [arrayNew addObject:[paymentMethod objectAtIndex:i]];
        }
    }
    
    NSArray *paymentMethodNew = [arrayNew copy];
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    MyCartBox *box = [MyCartBox paymentMethod:CGSizeMake(300, 34)];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, box.size.width, box.size.height)];
    
    [lbl setNuiClass:@"inventory"];
    
    lbl.text = NSLocalizedString(@"checkout_error_choose_payment_method", nil);
    lbl.textAlignment = NSTextAlignmentLeft;
    
    [box addSubview:lbl];
    paymentMethodLabel = lbl;
    
    box.onTap = ^{
        MenuViewController *menu = [[MenuViewController alloc] init];
        [menu setArray:paymentMethodNew];
        [menu setTermNa:@"title"];
        [menu setLabelToSend:lbl];
        [menu setReviewController:self];
        
        pop = [[FPPopoverController alloc] initWithViewController:menu];
        
        
        pop.border = NO;
        
        [pop.view setNuiClass:@"DropDownView"];
        
        [pop presentPopoverFromView:lbl];
    };
    
    [section.topLines addObject:box];
}

-(void)choosePaymentMethodOnChoose:(NSDictionary*)info
{
    if(already_choose_payment_method == NO)
    {
        [self shortDesc:[info objectForKey:@"Description"]];
        [scroller layoutWithSpeed:0.3 completion:nil];
        already_choose_payment_method = YES;
        paymentMethodID =[info objectForKey:@"id"];
        
        
        if([paymentMethodID isEqualToString:@"authorize_net_cim"])
        {
            NSArray *user_payment = [[[UserAuth instance] userData] objectForKey:@"credit_card_management_aut_net"];
            
            if([user_payment count] > 0)
            {
                
                ChooseCreditCardController *creditCard = [[ChooseCreditCardController alloc] init];
                [creditCard getPaymentMethodLabel:paymentMethodLabel];
                
                [creditCard use_as_return_customer];
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:creditCard];
                [self presentViewController:nav animated:YES completion:^{
                    [pop dismissPopoverAnimated:YES];
                }];
            }
            else
            {
                CreditCardController *creditCard = [[CreditCardController alloc] init];
                [creditCard use_as_new];
                [creditCard setpaymentMethodLabel:paymentMethodLabel];
                creditCard.title = @"New";
                //[creditCard getPaymentMethodLabel:paymentMethodLabel];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:creditCard];
                
                [self presentViewController:nav animated:YES completion:^{
                    [pop dismissPopoverAnimated:YES];
                }];
            }
        }
    }
    else
    {
        [scroller.boxes removeObjectAtIndex:[scroller.boxes count]-1];
        [self shortDesc:[info objectForKey:@"Description"]];
        [scroller layoutWithSpeed:0.3 completion:nil];
        paymentMethodID = [info objectForKey:@"id"];
        
        if([paymentMethodID isEqualToString:@"authorize_net_cim"])
        {
            NSArray *user_payment = [[[UserAuth instance] userData] objectForKey:@"credit_card_management_aut_net"];
            
            if([user_payment count] > 0)
            {
                
                ChooseCreditCardController *creditCard = [[ChooseCreditCardController alloc] init];
                
                [creditCard getPaymentMethodLabel:paymentMethodLabel];
                [creditCard use_as_return_customer];
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:creditCard];
                [self presentViewController:nav animated:YES completion:^{
                    [pop dismissPopoverAnimated:YES];
                }];
                
            }
            else
            {
                CreditCardController *creditCard = [[CreditCardController alloc] init];
                [creditCard use_as_new];
                [creditCard setpaymentMethodLabel:paymentMethodLabel];
                creditCard.title = @"New";
                //[creditCard getPaymentMethodLabel:paymentMethodLabel];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:creditCard];
                
                [self presentViewController:nav animated:YES completion:^{
                    [pop dismissPopoverAnimated:YES];
                }];
            }
        }
    }
    
    [pop dismissPopoverAnimated:YES];
}




-(void)cancelBtn{
    
    paymentMethodLabel.text = NSLocalizedString(@"checkout_error_choose_payment_method", nil);
    paymentMethodID = @"";
    already_choose_payment_method = NO;
    
    [scroller.boxes removeObjectAtIndex:[scroller.boxes count]-1];
    
    [scroller layoutWithSpeed:0.3 completion:nil];
}


-(void)shortDesc:(NSString*)desc
{
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    [scroller.boxes addObject:section];
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    section.backgroundColor = [UIColor clearColor];
    section.layer.shadowColor = nil;
    section.layer.shadowOffset = CGSizeMake(0, 0);
    section.layer.shadowRadius = 0;
    section.layer.shadowOpacity = 0;
    section.layer.borderWidth = 0;
    section.layer.borderColor = nil;
    id body = [NSString stringWithFormat:@"%@",[[ToolClass instance] decodeHTMLCharacterEntities:desc]];
    
    
    
    // stuff
    MGLineStyled *line = [MGLineStyled multilineWithText:body font:nil width:300
                                                 padding:UIEdgeInsetsMake(2, 2, 0.0, 0.0)];
    line.backgroundColor = [UIColor clearColor];
    [section.topLines addObject:line];
    
    
    
}

-(void)cartItem:(NSString*)featuredImage productTitle:(NSString*)title currency:(NSString*)currency price:(NSString*)price quantity:(NSString*)quantity totalPrice:(NSString*)totalPrice has_tax:(BOOL)has_tax productID:(NSString*)productID{
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    
    MyCartBox *box = [MyCartBox cartItemServer:featuredImage productTitle:title currency:currency price:price quantity:quantity totalPrice:totalPrice has_tax:has_tax];
    
    
    [section.topLines addObject:box];
    
    
    UIImageView *deleteIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NSLocalizedString(@"image_delete_icon", nil)]];
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

-(void)deleteExe:(UserDataTapGestureRecognizer*)tap{
    
    
    NSString *productID = [NSString stringWithFormat:@"%@",tap.userData];
    [[MyCartClass instance] removeCartByProductID:productID];
    [scroller.boxes removeAllObjects];
    [self setCartItemView];
    
    [[MyCartClass instance] countCartTabBar];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    [HUD showWhileExecuting:@selector(addCouponOnReturnExe:) onTarget:self withObject:[NSArray arrayWithObjects:@"", nil] animated:YES];
    
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
    
    box.swiper.direction = UISwipeGestureRecognizerDirectionLeft;
    MyCartBox *box2 = box;
    box.onSwipe = ^{
        if(box2.swiper.direction == UISwipeGestureRecognizerDirectionLeft)
        {
            
            box2.swiper.direction = UISwipeGestureRecognizerDirectionRight;
            deleteIcon.hidden = NO;
            deleteIcon.alpha = 0;
            [UIView animateWithDuration:0.2 animations:^{
                box2.x = -30;
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
}


-(void)deleteCouponExe:(UserDataTapGestureRecognizer*)tap{
    NSString *couponCode = [NSString stringWithFormat:@"%@",tap.userData];
    [[MyCartClass instance] removeCouponByCouponCode:couponCode];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    [HUD showWhileExecuting:@selector(addCouponOnReturnExe:) onTarget:self withObject:[NSArray arrayWithObjects:@"", nil] animated:YES];
}

-(void)addCouponTextField{
    
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    couponBox = [[MyCartBox alloc] init];
    
    [couponBox setReviewCheckOutController:self];
    
    [section.topLines addObject:[couponBox addCouponTextField]];
}


-(void)addCouponOnReturn:(NSString*)code{
    
    [[MyCartClass instance] addCoupon:code];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    [HUD showWhileExecuting:@selector(addCouponOnReturnExe:) onTarget:self withObject:[NSArray arrayWithObjects:code, nil] animated:YES];
    
    
}

-(void)addCouponOnReturnExe:(NSArray*)ary{
    
    NSString *justInsertedCode = [ary objectAtIndex:0];
    NSDictionary *reviewData = [[DataService instance] reviewCartWithCoupon:[UserAuth instance].username password:[UserAuth instance].password productInJsonString:[[MyCartClass instance] productIDToJsonString] coupon:[[MyCartClass instance] couponToJsonString]];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [[MyCartClass instance] setServerCart:reviewData];
        
        NSArray *insertedCouponArray =[[reviewData objectForKey:@"coupon"] objectForKey:@"coupon-array-inserted"];
        for(int i=0; i< [insertedCouponArray count];i++)
        {
            NSDictionary *dic = [[[reviewData objectForKey:@"coupon"] objectForKey:@"coupon-array-inserted"] objectAtIndex:i];
            NSString *couponCode = [dic objectForKey:@"coupon_code"];
            
            if([justInsertedCode isEqualToString:couponCode])
            {
                
                if([dic objectForKey:@"error_message"] == [NSNull null])
                {
                    
                }
                else
                {
                    NSString *errorMessage = [dic objectForKey:@"error_message"];
                    if ([errorMessage isEqualToString:@"Coupon usage limit has been reached."]) {
                        errorMessage = NSLocalizedString(@"order.coupon_limit_reached", nil);
                    }
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)
                                                                   message: [NSString stringWithFormat:@"%@ : %@",couponCode,errorMessage]
                                                                  delegate: nil
                                                         cancelButtonTitle:nil
                                                         otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
                    
                    
                    [alert show];
                }
                
                
                break;
            }
        }
        
        [[[MyCartClass instance] getCouponCode] removeAllObjects];
        NSArray *couponServer = [[reviewData objectForKey:@"coupon"] objectForKey:@"applied-coupon"];
        
        for(int i=0;i<[couponServer count];i++)
        {
            
            [[MyCartClass instance] addCoupon:[couponServer objectAtIndex:i]];
        }
        
        [scroller.boxes removeAllObjects];
        
        [self addCouponTextField];
        [self setCartItemView];
        [self totalBox];
        [self totalPrice];
        [self setPaymentMethod];
        [scroller layoutWithSpeed:0.3 completion:nil];
        
        
        if([[[MyCartClass instance] getMyCartArray] count] == 0)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    });
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollViews
{
    initialContentOffset = scrollViews.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollViews
{
    
    [[SettingDataClass instance] autoHideGlobal:scrollViews navigationView:self.navigationController contentOffset:initialContentOffset];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
