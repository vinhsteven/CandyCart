//
//  AddToCartQuantity.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/7/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetailViewController;
@interface AddToCartQuantity : UITableViewController
{
    NSMutableArray *array;
    DetailViewController *detailController;
}
-(void)setTotalQuantity:(int)quantity setCurrentDetail:(DetailViewController*)det;
@end
