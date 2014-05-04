//
//  MyOrderClass.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/13/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderClass : NSObject
{
    NSDictionary *myOrder;
    NSDictionary *listOfMyOrder;
}
+ (MyOrderClass *) instance;
-(void)setMyOrder:(NSDictionary*)myOrderEx;
-(NSDictionary*)getMyOrder;

-(void)setListOfMyOrder:(NSDictionary*)listOfMyOrders;
-(NSDictionary*)getListOfMyOrder;
@end
