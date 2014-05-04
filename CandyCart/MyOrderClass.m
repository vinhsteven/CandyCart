//
//  MyOrderClass.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/13/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "MyOrderClass.h"

@implementation MyOrderClass
+ (MyOrderClass *) instance {
    static MyOrderClass *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(void)setMyOrder:(NSDictionary*)myOrderEx
{
    myOrder = myOrderEx;
    
}

-(NSDictionary*)getMyOrder{
    
    return myOrder;
    
}

-(void)setListOfMyOrder:(NSDictionary*)listOfMyOrders
{
    
    listOfMyOrder = listOfMyOrders;
}

-(NSDictionary*)getListOfMyOrder
{
    
    return listOfMyOrder;
}

@end
