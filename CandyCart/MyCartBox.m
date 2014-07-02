//
//  MyCartBox.m
//  Candy Cart
//
//  Created by Mr Kruk (kruk8989@gmail.com)  http://codecanyon.net/user/kruk8989 on 8/8/13.
//  Copyright (c) 2013 kruk. All rights reserved.
//

#import "MyCartBox.h"
#import "ReviewCheckOutViewController.h"
@interface MyCartBox ()

@end

@implementation MyCartBox
@synthesize couponTextField;
- (void)setup {
    // background
    self.backgroundColor = [UIColor whiteColor];
    
    // shadow
    //self.layer.shadowColor = [UIColor colorWithWhite:0.12 alpha:0.3].CGColor;
    //self.layer.shadowOffset = CGSizeMake(0, 0.5);
    //self.layer.shadowRadius = 1;
    //self.layer.shadowOpacity = 0.3;
    //self.layer.cornerRadius = 0;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

+ (MyCartBox *)preTotal:(NSString*)label currency:(NSString*)currency totalPrice:(float)price
{
    MyCartBox *box = [MyCartBox boxWithSize:CGSizeMake(300, 30)];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 280, 30)];
    lbl.text = label;
    lbl.font = [UIFont fontWithName:PRIMARYFONT size:14];
    lbl.backgroundColor = [UIColor clearColor];
    [box addSubview:lbl];
    
    
    UILabel *totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 30)];
    //    totalPrice.text = [NSString stringWithFormat:@"%@ %.2f",currency,price];
    totalPrice.text = [NSString stringWithFormat:@"%@ %@",currency,[[AppDelegate instance] convertToThousandSeparator:[NSString stringWithFormat:@"%f",price]]];
    totalPrice.textAlignment = NSTextAlignmentRight;
    totalPrice.font = [UIFont fontWithName:BOLDFONT size:14];
    totalPrice.backgroundColor = [UIColor clearColor];
    [box addSubview:totalPrice];
    
    return box;
    
}


+ (MyCartBox *)coupon:(NSString*)label couponCode:(NSString*)couponCode
{
    
    MyCartBox *box = [MyCartBox boxWithSize:CGSizeMake(300, 30)];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 280, 30)];
    lbl.text = label;
    lbl.font = [UIFont fontWithName:PRIMARYFONT size:14];
    lbl.backgroundColor = [UIColor clearColor];
    [box addSubview:lbl];
    
    
    UILabel *totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 30)];
    totalPrice.text = [NSString stringWithFormat:@"%@",couponCode];
    totalPrice.textAlignment = NSTextAlignmentRight;
    totalPrice.font = [UIFont fontWithName:BOLDFONT size:14];
    totalPrice.backgroundColor = [UIColor clearColor];
    [box addSubview:totalPrice];
    
    return box;
}

+ (MyCartBox *)date:(NSString*)label date:(NSString*)dateString
{
    MyCartBox *box = [MyCartBox boxWithSize:CGSizeMake(300, 30)];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 280, 30)];
    lbl.text = label;
    lbl.font = [UIFont fontWithName:PRIMARYFONT size:10];
    lbl.backgroundColor = [UIColor clearColor];
    [box addSubview:lbl];
    
    
    UILabel *value = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 30)];
    value.text = [NSString stringWithFormat:@"%@",dateString];
    value.textAlignment = NSTextAlignmentRight;
    value.font = [UIFont fontWithName:BOLDFONT size:14];
    value.backgroundColor = [UIColor clearColor];
    [box addSubview:value];
    
    return box;
    
}


+ (MyCartBox *)totalPrice:(NSString*)label currency:(NSString*)currency totalPrice:(float)price include_tax:(BOOL)include_tax tax:(NSString*)taxText
{
    
    MyCartBox *box = [MyCartBox boxWithSize:CGSizeMake(300, 45)];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 280, 30)];
    lbl.text = label;
    lbl.font = [UIFont fontWithName:PRIMARYFONT size:14];
    lbl.backgroundColor = [UIColor clearColor];
    [box addSubview:lbl];
    
    
    UILabel *totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 30)];
    //    totalPrice.text = [NSString stringWithFormat:@"%@ %.2f",currency,price];
    totalPrice.text = [NSString stringWithFormat:@"%@ %@",currency,[[AppDelegate instance] convertToThousandSeparator:[NSString stringWithFormat:@"%f",price]]];
    totalPrice.textAlignment = NSTextAlignmentRight;
    totalPrice.font = [UIFont fontWithName:BOLDFONT size:14];
    totalPrice.backgroundColor = [UIColor clearColor];
    [box addSubview:totalPrice];
    
    if(include_tax == YES)
    {
        UILabel *tax = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 290, 15)];
        tax.text = taxText;
        tax.textAlignment = NSTextAlignmentRight;
        tax.font = [UIFont fontWithName:PRIMARYFONT size:12];
        tax.backgroundColor = [UIColor clearColor];
        [box addSubview:tax];
    }
    
    return box;
    
}

+ (MyCartBox *)cartItem:(NSString*)featuredImgUrl productTitle:(NSString*)title currency:(NSString*)currency price:(NSString*)price quantity:(NSString*)quantity{
    
    MyCartBox *box = [MyCartBox boxWithSize:CGSizeMake(300, 50)];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    UIImageView *img2 = [[UIImageView alloc] init];
    
    
    [imgView setImageWithURL:[NSURL URLWithString:featuredImgUrl]
            placeholderImage:[UIImage imageNamed:NSLocalizedString(@"image_loading_placeholder", nil)]
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                       
                       img2.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(100, 100) source:image];
                       
                   }];
    
    imgView.image = img2.image;
    
    
    [box addSubview:imgView];
    
    UILabel *productTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 8, 170, 20)];
    productTitle.text = title;
    productTitle.font = [UIFont fontWithName:PRIMARYFONT size:13];
    productTitle.backgroundColor = [UIColor clearColor];
    [box addSubview:productTitle];
    
    UILabel *priceAndQuantity = [[UILabel alloc] initWithFrame:CGRectMake(60, 24, 130, 20)];
    //    priceAndQuantity.text = [NSString stringWithFormat:@"%@ %@ x %@",currency,price,quantity];
    priceAndQuantity.text = [NSString stringWithFormat:@"%@ %@ x %@",currency,[[AppDelegate instance] convertToThousandSeparator:price],quantity];
    priceAndQuantity.backgroundColor = [UIColor clearColor];
    priceAndQuantity.font = [UIFont fontWithName:PRIMARYFONT size:10];
    [box addSubview:priceAndQuantity];
    
    
    UILabel *totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 280, 50)];
    float total = [price floatValue]*[quantity intValue];
    totalPrice.textAlignment = NSTextAlignmentRight;
    totalPrice.backgroundColor = [UIColor clearColor];
    totalPrice.font = [UIFont fontWithName:PRIMARYFONT size:14];
    //    totalPrice.text = [NSString stringWithFormat:@"%@ %.2f",currency,total];
    totalPrice.text = [NSString stringWithFormat:@"%@ %@",currency,[[AppDelegate instance] convertToThousandSeparator:[NSString stringWithFormat:@"%f",total]]];
    [box addSubview:totalPrice];
    return box;
}


+ (MyCartBox *)cartItemServer:(NSString*)featuredImgUrl productTitle:(NSString*)title currency:(NSString*)currency price:(NSString*)price quantity:(NSString*)quantity totalPrice:(NSString*)totalPriceServer has_tax:(BOOL)has_tax{
    
    MyCartBox *box = [MyCartBox boxWithSize:CGSizeMake(300, 50)];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    UIImageView *img2 = [[UIImageView alloc] init];
    
    
    [imgView setImageWithURL:[NSURL URLWithString:featuredImgUrl]
            placeholderImage:[UIImage imageNamed:NSLocalizedString(@"image_loading_placeholder", nil)]
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                       
                       img2.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(100, 100) source:image];
                       
                   }];
    
    imgView.image = img2.image;
    
    
    [box addSubview:imgView];
    
    UILabel *productTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 8, 170, 20)];
    productTitle.text = title;
    productTitle.font = [UIFont fontWithName:PRIMARYFONT size:13];
    productTitle.backgroundColor = [UIColor clearColor];
    [box addSubview:productTitle];
    
    UILabel *priceAndQuantity = [[UILabel alloc] initWithFrame:CGRectMake(60, 24, 130, 20)];
    //    priceAndQuantity.text = [NSString stringWithFormat:@"%@ %@ x %@",currency,price,quantity];
    priceAndQuantity.text = [NSString stringWithFormat:@"%@ %@ x %@",currency,[[AppDelegate instance] convertToThousandSeparator:price],quantity];
    priceAndQuantity.backgroundColor = [UIColor clearColor];
    priceAndQuantity.font = [UIFont fontWithName:PRIMARYFONT size:10];
    [box addSubview:priceAndQuantity];
    
    
    UILabel *totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 280, 50)];
    
    totalPrice.textAlignment = NSTextAlignmentRight;
    totalPrice.backgroundColor = [UIColor clearColor];
    totalPrice.font = [UIFont fontWithName:PRIMARYFONT size:14];
    //    totalPrice.text = [NSString stringWithFormat:@"%@ %@",currency,totalPriceServer];
    totalPrice.text = [NSString stringWithFormat:@"%@ %@",currency,[[AppDelegate instance] convertToThousandSeparator:totalPriceServer]];
    [box addSubview:totalPrice];
    
    if(has_tax == YES)
    {
        totalPrice.frame = CGRectMake(10, 0, 280, 35);
        UILabel *hasTax = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 50)];
        hasTax.textAlignment = NSTextAlignmentRight;
        hasTax.backgroundColor = [UIColor clearColor];
        hasTax.font = [UIFont fontWithName:PRIMARYFONT size:10];
        hasTax.text = NSLocalizedString(@"myCartBox_exclude_tax_title", nil);
        [box addSubview:hasTax];
    }
    return box;
}


- (MyCartBox *)credit_card
{
    
    MyCartBox *box = [MyCartBox boxWithSize:CGSizeMake(300, 40)];
    
    couponTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    couponTextField.returnKeyType = UIReturnKeyDone;
    [couponTextField setKeyboardType:UIKeyboardTypeDefault];
    couponTextField.placeholder = @"Credit Card Number Visa,MasterCard,Amex,JCB";
    couponTextField.delegate = self;
    [couponTextField setNuiClass:@"AddCouponTextField"];
    [box addSubview:couponTextField];
    
    return box;
    
}

- (MyCartBox *)credit_card_expired
{
    
    MyCartBox *box = [MyCartBox boxWithSize:CGSizeMake(300, 40)];
    
    couponTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    couponTextField.returnKeyType = UIReturnKeyDone;
    [couponTextField setKeyboardType:UIKeyboardTypeDefault];
    couponTextField.placeholder = @"Card expiration date : MonthYear e.g 0418 ";
    couponTextField.delegate = self;
    [couponTextField setNuiClass:@"AddCouponTextField"];
    [box addSubview:couponTextField];
    
    return box;
    
}

- (MyCartBox *)addCouponTextField
{
    
    MyCartBox *box = [MyCartBox boxWithSize:CGSizeMake(300, 40)];
    
    couponTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    couponTextField.returnKeyType = UIReturnKeyDone;
    [couponTextField setKeyboardType:UIKeyboardTypeDefault];
    couponTextField.placeholder = NSLocalizedString(@"mycartbox.add-coupon", nil);
    couponTextField.delegate = self;
    [couponTextField setNuiClass:@"AddCouponTextField"];
    [box addSubview:couponTextField];
    
    return box;
    
}

+ (MyCartBox *)paymentMethod:(CGSize)size{
    
    MyCartBox *box = [MyCartBox boxWithSize:CGSizeMake(size.width, size.height)];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    img.frame = CGRectMake(size.width-27, size.height/4.6, 18, 18);
    
    img.transform = CGAffineTransformMakeRotation(1.5707963267949);
    
    
    [box addSubview:img];
    
    return box;
}


+ (MyCartBox *)pass_credit_card:(CGSize)size{
    
    MyCartBox *box = [MyCartBox boxWithSize:CGSizeMake(size.width, size.height)];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    img.frame = CGRectMake(size.width-27, size.height/4.6, 18, 18);
    
    [box addSubview:img];
    
    return box;
}


+ (MyCartBox *)paymentMethodNoArrow:(CGSize)size{
    
    MyCartBox *box = [MyCartBox boxWithSize:CGSizeMake(size.width, size.height)];
    
    return box;
}

-(void)setReviewCheckOutController:(ReviewCheckOutViewController*)re
{
    reviewCheckOut = re;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if([couponTextField.text length] == 0)
    {
        [couponTextField resignFirstResponder];
    }
    else
    {
        [reviewCheckOut addCouponOnReturn:couponTextField.text];
        [couponTextField resignFirstResponder];
    }
    
    return NO;
}

//OrderView Controller
+(MyCartBox*)halfBox:(CGSize)size lbl:(NSString*)str value:(NSString*)value{
    
    MyCartBox *box = [MyCartBox boxWithSize:size];
    
    // style and tag
    //box.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    box.tag = -1;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, size.width-20, size.height/2)];
    lbl.text = str;
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont fontWithName:PRIMARYFONT size:10];
    [box addSubview:lbl];
    
    UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(10, size.height/2-5, size.width-20, size.height/2)];
    lbl2.text = [NSString stringWithFormat:@"%@",value];
    lbl2.backgroundColor = [UIColor clearColor];
    lbl2.font = [UIFont fontWithName:BOLDFONT size:14];
    lbl2.adjustsFontSizeToFitWidth = YES;
    lbl2.lineBreakMode = YES;
    
    [box addSubview:lbl2];
    
    return box;
}

+(MyCartBox*)halfBox:(CGSize)size lbl:(NSString*)str value:(NSString*)value tag:(int)_tag {
    
    MyCartBox *box = [MyCartBox boxWithSize:size];
    
    // style and tag
    //box.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    box.tag = -1;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, size.width-20, size.height/2)];
    lbl.text = str;
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont fontWithName:PRIMARYFONT size:10];
    [box addSubview:lbl];
    
    UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(10, size.height/2-5, size.width-20, size.height/2)];
    lbl2.text = [NSString stringWithFormat:@"%@",value];
    lbl2.backgroundColor = [UIColor clearColor];
    lbl2.font = [UIFont fontWithName:BOLDFONT size:14];
    lbl2.adjustsFontSizeToFitWidth = YES;
    lbl2.lineBreakMode = YES;
    lbl2.tag = _tag;
    
    [box addSubview:lbl2];
    
    return box;
}

+(MyCartBox*)halfAddressBox:(CGSize)size lbl:(NSString*)str value:(NSString*)value{
    
    MyCartBox *box = [MyCartBox boxWithSize:size];
    
    // style and tag
    //box.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    box.tag = -1;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, size.width-20, 20)];
    lbl.text = str;
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont fontWithName:PRIMARYFONT size:10];
    [box addSubview:lbl];
    
    UITextView *lbl2 = [[UITextView alloc] initWithFrame:CGRectMake(3, 20, size.width, size.height-20)];
    lbl2.text = [NSString stringWithFormat:@"%@",value];
    lbl2.backgroundColor = [UIColor clearColor];
    lbl2.font = [UIFont fontWithName:BOLDFONT size:11];
    lbl2.editable = NO;
    
    [box addSubview:lbl2];
    
    return box;
}

@end
