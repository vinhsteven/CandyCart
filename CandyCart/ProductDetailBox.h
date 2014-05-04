//
//  ProductDetailBox.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/16/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "MGBox.h"
#import "UserDataTapGestureRecognizer.h"
#import "MZTimerLabel.h"
@interface ProductDetailBox : MGBox<MZTimerLabelDelegate>
{
    ProductDetailBox *addToCartBox;
}
@property(nonatomic,retain) UILabel *addToCartLbl;
- (ProductDetailBox *)addToCartBtn:(BOOL)outOfStock;
+ (ProductDetailBox *)inventory:(NSString*)stock allowedBackOrderNotification:(BOOL)backorder;
+ (ProductDetailBox *)productYouMayLike:(NSArray*)upsale_data detail:(DetailViewController*)det;
+ (ProductDetailBox *)option:(CGSize)size;
- (void)addToCartBtnInCart:(int)incartquantity;
- (void)addToCartBtnIfVariableNoIventory;
- (void)addToCartBtnIfVariableQuantityAppear:(NSString*)quantity;
+ (ProductDetailBox *)groupItem:(NSString*)featuredImgUrl productTitle:(NSString*)title currency:(NSString*)currency price:(NSString*)regul salePrice:(NSString*)salePrices isOnSale:(BOOL)onSale;
+ (ProductDetailBox *)desc:(CGSize)size;
+ (ProductDetailBox *)countDownTimer:(CGSize)size leftSmall:(NSString*)text;
@end
