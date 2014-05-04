//
//  MyCartClass.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/7/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "MyCartClass.h"

@implementation MyCartClass
+ (MyCartClass *) instance {
    static MyCartClass *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}


-(void)initMyCart{
    
    globalcart = [[NSMutableArray alloc] init];
    counponCode = [[NSMutableArray alloc] init];
}

-(NSMutableArray*)getMyCartArray{
    
    return globalcart;
}

-(NSMutableArray*)getCouponCode{
    
    return counponCode;
}

-(NSDictionary*)getServerCart{
    
    return serverCart;
}

-(NSString*)getOrderNotes{
    
    return orderNotes;
}

-(void)setOrderNotes:(NSString*)note{
    
    orderNotes = note;
}

-(void)addCoupon:(NSString*)couponCode{
    [counponCode addObject:couponCode];
}

-(int)findCouponIndex:(NSString*)couponCode{
    
    
    int objectIndex = 0;
    for(int i=0;i<[counponCode count];i++)
    {
        if([[counponCode objectAtIndex:i] isEqualToString:couponCode])
        {
            
            objectIndex = i;
            break;
        }
    }
    
    return objectIndex;
}

-(NSArray*)getProductInCartInfo:(NSString*)productID{
    
    
    NSArray *productInfo;
    productInfo = [globalcart objectAtIndex:[self findCartIndex:productID]];
    
    return productInfo;
}

-(void)removeCouponByCouponCode:(NSString*)couponCode{
    
    [counponCode removeObjectAtIndex:[self findCouponIndex:couponCode]];
}

-(int)findCartIndex:(NSString*)productID{
    
    int objectIndex = 0;
    for(int i=0;i<[globalcart count];i++)
    {
        if([[[globalcart objectAtIndex:i] objectAtIndex:1] intValue] == [productID intValue])
        {
            
            objectIndex = i;
            break;
        }
    }
    
    return objectIndex;
}


-(void)removeCartByProductID:(NSString*)productID{
    
    [globalcart removeObjectAtIndex:[self findCartIndex:productID]];
}


-(int)countProduct{
    
    return [globalcart count];
}

-(BOOL)checkInCart:(NSString*)productID{
    BOOL insideCart = NO;
    
    for(int i=0;i<[globalcart count];i++)
    {
        if([[[globalcart objectAtIndex:i] objectAtIndex:1] intValue] == [productID intValue])
        {
            insideCart = YES;
            
            break;
        }
        else
        {
            insideCart = NO;
        }
        
    }
    return insideCart;
}

-(float)getTotalCartPrice{
    float total = 0;
    
    NSMutableArray *incart = [self getMyCartArray];
    
    for(int i=0;i<[incart count];i++)
    {
        
        if([[[incart objectAtIndex:i] objectAtIndex:0] isEqualToString:@"simple"])
        {
            NSDictionary *productInfo = [[incart objectAtIndex:i] objectAtIndex:3];
            
            NSNumber *boolean = (NSNumber *)[[[productInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"is_on_sale"];
            if([boolean boolValue] == FALSE)
            {
                total = total + [[[[productInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"regular_price"] floatValue]*[[[globalcart objectAtIndex:i] objectAtIndex:2] intValue];
                
            }
            else
            {
                total = total + [[[[productInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"sale_price"] floatValue]*[[[globalcart objectAtIndex:i] objectAtIndex:2] intValue];
            }
        }
        else
        {
            NSDictionary *productInfo = [[incart objectAtIndex:i] objectAtIndex:3];
            
            NSNumber *boolean = (NSNumber *)[[[productInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"is_on_sale"];
            if([boolean boolValue] == FALSE)
            {
                total = total + [[[productInfo  objectForKey:@"pricing"] objectForKey:@"regular_price"] floatValue]*[[[globalcart objectAtIndex:i] objectAtIndex:2] intValue];
            }
            else
            {
                total = total + [[[productInfo  objectForKey:@"pricing"] objectForKey:@"sale_price"] floatValue]*[[[globalcart objectAtIndex:i] objectAtIndex:2] intValue];
            }
        }
    }
    
    return total;
}


-(NSString*)productIDToJsonString{
    
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSMutableDictionary *command = [[NSMutableDictionary alloc] init];
    for(int i=0;i<[globalcart count];i++)
    {
        
        [command setValue:[NSString stringWithFormat:@"%@",[[globalcart objectAtIndex:i] objectAtIndex:2]] forKey:[NSString stringWithFormat:@"%@",[[globalcart objectAtIndex:i] objectAtIndex:1]]];
        //[command addObject:[NSArray arrayWithObjects:[[globalcart objectAtIndex:i] objectAtIndex:1],[[globalcart objectAtIndex:i] objectAtIndex:2], nil]];
        
    }
    
    NSDictionary *dic = [command copy];
    
    NSError *error;
    NSString *jsonString = [writer stringWithObject:dic error:&error];
    
    return jsonString;
}

-(NSString*)couponToJsonString{
    
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSMutableDictionary *command = [[NSMutableDictionary alloc] init];
    for(int i=0;i<[counponCode count];i++)
    {
        
        [command setValue:[NSString stringWithFormat:@"%@",[counponCode objectAtIndex:i]] forKey:[NSString stringWithFormat:@"%d",i]];
    }
    
    NSDictionary *dic = [command copy];
    
    NSError *error;
    NSString *jsonString = [writer stringWithObject:dic error:&error];
    
    return jsonString;
}

-(int)productQuantityInsideCart:(NSString*)productID
{
    int quantity=0;
    for(int i=0;i<[globalcart count];i++)
    {
        if([[[globalcart objectAtIndex:i] objectAtIndex:1] intValue] == [productID intValue])
        {
            quantity = [[[globalcart objectAtIndex:i] objectAtIndex:2] intValue];
            
            break;
        }
        else
        {
            quantity = 0;
        }
    }
    
    return quantity;
}

-(void)addToCart:(NSString*)productType productID:(NSString*)productID productQuantity:(NSString*)quantity fullProductInfo:(NSDictionary*)productInfo ifVariableParentInfo:(NSMutableDictionary*)array{
    
    BOOL insideCart = NO;
    int objectIndex=0;
    for(int i=0;i<[globalcart count];i++)
    {
        if([[[globalcart objectAtIndex:i] objectAtIndex:1] intValue] == [productID intValue])
        {
            insideCart = YES;
            objectIndex = i;
            break;
        }
        else
        {
            insideCart = NO;
        }
        
    }
    
    if(insideCart == YES)
    {
        
        if([productType isEqualToString:@"simple"])
        {
            
            [globalcart replaceObjectAtIndex:objectIndex withObject:[NSArray arrayWithObjects:@"simple",productID,quantity,productInfo, nil]];
        }
        else {
            
            [globalcart replaceObjectAtIndex:objectIndex withObject:[NSArray arrayWithObjects:@"variable",productID,quantity,productInfo,[array objectForKey:@"parentID"],[array objectForKey:@"parentInfo"], nil]];
        }
    }
    else
    {
        if([productType isEqualToString:@"simple"])
        {
            [globalcart addObject:[NSArray arrayWithObjects:@"simple",productID,quantity,productInfo, nil]];
            
        }
        else{
            
            [globalcart addObject:[NSArray arrayWithObjects:@"variable",productID,quantity,productInfo,[array objectForKey:@"parentID"],[array objectForKey:@"parentInfo"], nil]];
            
        }
    }
}

-(void)setServerCart:(NSDictionary*)serverCartP{
    
    serverCart = serverCartP;
}

-(int)getServerCartIndex:(NSString*)productID
{
    
    BOOL insideCart = NO;
    int objectKey = 0;
    for(int i=0;i<[(NSArray*)[serverCart objectForKey:@"cart"] count];i++)
    {
        NSString *serverProductID = [[[serverCart objectForKey:@"cart"] objectAtIndex:i] objectForKey:@"id"];
        
        if([serverProductID intValue] == [productID intValue])
        {
            insideCart = YES;
            objectKey = i;
            break;
        }
        else
        {
            insideCart = NO;
        }
    }
    
    return objectKey;
}

-(BOOL)checkServerHasTax
{
    BOOL value;
    if([[serverCart objectForKey:@"has_tax"] isEqualToString:@"no"])
    {
        
        value = NO;
    }
    else
    {
        if([[serverCart objectForKey:@"display-price-during-cart-checkout"] isEqualToString:@"excl"])
        {
            value = YES;
        }
        else
        {
            value = NO;
        }
    }
    
    return value;
}



-(NSString*)getProductCartInServerTotalPrice:(NSString*)productID
{
    NSString *value;
    if([[serverCart objectForKey:@"has_tax"] isEqualToString:@"no"])
    {
        value = [[[serverCart objectForKey:@"cart"] objectAtIndex:[self getServerCartIndex:productID]] objectForKey:@"total-price"];
    }
    else
    {
        if([[serverCart objectForKey:@"display-price-during-cart-checkout"] isEqualToString:@"excl"])
        {
            float val = [[[[serverCart objectForKey:@"cart"] objectAtIndex:[self getServerCartIndex:productID]] objectForKey:@"total-price"] floatValue];
            value = [NSString stringWithFormat:@"%.2f",val];
        }
        else
        {
            float val = [[[[serverCart objectForKey:@"cart"] objectAtIndex:[self getServerCartIndex:productID]] objectForKey:@"total-price"] floatValue] + [[[[serverCart objectForKey:@"cart"] objectAtIndex:[self getServerCartIndex:productID]] objectForKey:@"total-price-tax"] floatValue];
            value = [NSString stringWithFormat:@"%.2f",val];
        }
    }
    
    return value;
}


-(NSString*)getProductCartInServerPrice:(NSString*)productID
{
    NSString *value;
    if([[serverCart objectForKey:@"has_tax"] isEqualToString:@"no"])
    {
        value = [[[serverCart objectForKey:@"cart"] objectAtIndex:[self getServerCartIndex:productID]] objectForKey:@"product-price"];
    }
    else
    {
        
        if([[serverCart objectForKey:@"display-price-during-cart-checkout"] isEqualToString:@"excl"])
        {
            float val = [[[[serverCart objectForKey:@"cart"] objectAtIndex:[self getServerCartIndex:productID]] objectForKey:@"product-price"] floatValue];
            value = [NSString stringWithFormat:@"%.2f",val];
        }
        else
        {
            float val = [[[[serverCart objectForKey:@"cart"] objectAtIndex:[self getServerCartIndex:productID]] objectForKey:@"product-price"] floatValue] + [[[[serverCart objectForKey:@"cart"] objectAtIndex:[self getServerCartIndex:productID]] objectForKey:@"product-price-tax"] floatValue];
            value = [NSString stringWithFormat:@"%.2f",val];
        }
    }
    
    return value;
}


-(NSString*)getProductCartInServerAttribute:(NSString*)objectKey productID:(NSString*)productID
{
    
    NSString *value = [[[serverCart objectForKey:@"cart"] objectAtIndex:[self getServerCartIndex:productID]] objectForKey:objectKey];
    
    return value;
}


-(NSString*)getServerCartValueByObjectKey:(NSString*)objectKey{
    
    NSString *value = [serverCart objectForKey:objectKey];
    
    return value;
}

-(void)countCartTabBar
{
    
    [[MainViewClass instance] countCartTabbarBadge];
}

@end
