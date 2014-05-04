//
//  ChooseCreditCardController.m
//  Mindful Minerals
//
//  Created by Dead Mac on 1/29/14.
//  Copyright (c) 2014 Dead Mac. All rights reserved.
//

#import "ChooseCreditCardController.h"

@interface ChooseCreditCardController ()

@end

@implementation ChooseCreditCardController

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
   
    
    
    scroller = [[MGScrollView alloc] initWithFrame:[[DeviceClass instance] getResizeScreen:NO]];
    scroller.bottomPadding = 8;
    
    scroller.delegate = self;
    scroller.alwaysBounceVertical = YES;
    
    [self.view addSubview:scroller];
    
    if(returnCustomer == YES)
    {
    [self if_returned_customer];
    }
    else
    {
        [self insert_new_credit_card_form];
    }
    [scroller layoutWithSpeed:0.3 completion:nil];
    
    if(returnCustomer == YES)
    {
    UIButton *order = [UIButton buttonWithType:UIButtonTypeCustom];
    order.frame = CGRectMake(0, 8, 60, 30);
    [order setTitle:@"Cancel" forState:UIControlStateNormal];
    [order addTarget:self
              action:@selector(backExe)
    forControlEvents:UIControlEventTouchDown];
    
    [order setNuiClass:@"UiBarButtonItem"];
    [order.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithCustomView:order];
    self.navigationItem.leftBarButtonItem = button;
         self.title = @"Credit Card";
    }
}

-(void)insert_new_credit_card_form{
 
    UITextField * billing_state = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, 300, 40)];
    billing_state.placeholder = NSLocalizedString(@"profile_billing_placeholder_state", nil);
    billing_state.delegate = self;
   
    [scroller addSubview:billing_state];
    
    
    
    UITextField *billing_phone = [[UITextField alloc] initWithFrame:CGRectMake(10, 70, 145, 40)];
    billing_phone.placeholder = NSLocalizedString(@"profile_billing_placeholder_phone", nil);
    billing_phone.delegate = self;
    [billing_phone setKeyboardType:UIKeyboardTypePhonePad];
    
    [scroller addSubview:billing_phone];
    
    UITextField * billing_email = [[UITextField alloc] initWithFrame:CGRectMake(165, 70, 145, 40)];
    [billing_email setKeyboardType:UIKeyboardTypeEmailAddress];
    billing_email.placeholder = NSLocalizedString(@"profile_billing_placeholder_email", nil);
    billing_email.delegate = self;
   
    [scroller addSubview:billing_email];
    
}



-(void)if_returned_customer{
    user_payment = [[[UserAuth instance] userData] objectForKey:@"credit_card_management_aut_net"];
    
    NSLog(@"user %@",user_payment);
    
    for(int i=0;i<[user_payment count];i++)
    {
        NSDictionary *attributes = [user_payment objectAtIndex:i];
        [self pass_credit_card:[NSString stringWithFormat:@"%@ ending in %@ (Expires %@)",[attributes objectForKey:@"type"],[attributes objectForKey:@"last_four"],[attributes objectForKey:@"exp_date"]] index:i];
    }
    
    
    [self new_credit_card:@"Use a new credit card"];
    
}

-(void)getPaymentMethodLabel:(UILabel*)lbl{
    paymentMethodLabel = lbl;
    
}

-(void)use_as_return_customer{
    returnCustomer = YES;
    
}

-(void)pass_credit_card:(NSString*)pass_credit_card index:(int)index{
    
   
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    
    MyCartBox *box = [MyCartBox pass_credit_card:CGSizeMake(300, 34)];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, box.size.width, box.size.height)];
    
    [lbl setNuiClass:@"inventory"];
    
    lbl.text = pass_credit_card;
    lbl.textAlignment = NSTextAlignmentLeft;
    
    [box addSubview:lbl];
    
    
    
    
    [section.topLines addObject:box];
    
    
    box.onTap = ^{
        
          NSDictionary *attributes = [user_payment objectAtIndex:index];
        
        paymentMethodLabel.text = [NSString stringWithFormat:@"%@ ending in %@ (Expires %@)",[attributes objectForKey:@"type"],[attributes objectForKey:@"last_four"],[attributes objectForKey:@"exp_date"]];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [[TempVariables instance] setAutNet:@"" expired_year:@"" expired_month:@"" cvv:@""  profileID:[attributes objectForKey:@"profile_id"]];
    };
    
    
}

-(void)new_credit_card:(NSString*)pass_credit_card{
    
    
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    
    MyCartBox *box = [MyCartBox pass_credit_card:CGSizeMake(300, 34)];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, box.size.width, box.size.height)];
    
    [lbl setNuiClass:@"inventory"];
    
    lbl.text = pass_credit_card;
    lbl.textAlignment = NSTextAlignmentLeft;
    
    [box addSubview:lbl];
    
    
    
    
    [section.topLines addObject:box];
    
    box.onTap = ^{
        
        CreditCardController *creditCard = [[CreditCardController alloc] init];
        [creditCard setpaymentMethodLabel:paymentMethodLabel];
        creditCard.title = @"New";
        //[creditCard getPaymentMethodLabel:paymentMethodLabel];
        
       
        [self.navigationController pushViewController:creditCard animated:YES];

    };
}

-(void)backExe
{
    [self dismissViewControllerAnimated:YES completion:^{
        ReviewCheckOutViewController *re = [[TempVariables instance] review_checkout];
        [re cancelBtn];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
