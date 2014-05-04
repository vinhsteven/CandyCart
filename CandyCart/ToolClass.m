//
//  ToolClass.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/6/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "ToolClass.h"

@implementation ToolClass

+ (ToolClass *) instance {
    static ToolClass *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize source:(UIImage*)sourceImages
{
	UIImage *sourceImage = sourceImages;
	UIImage *newImage = nil;
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (CGSizeEqualToSize(imageSize, targetSize) == NO)
	{
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
		
        if (widthFactor > heightFactor)
			scaleFactor = widthFactor; // scale to fit height
        else
			scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
		
        // center the image
        if (widthFactor > heightFactor)
		{
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
		}
        else
			if (widthFactor < heightFactor)
			{
				thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
			}
	}
	
	UIGraphicsBeginImageContext(targetSize); // this will crop
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	if(newImage == nil)
        NSLog(@"could not scale image");
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	return newImage;
}



-(UIImage*)cropRect:(CGRect)targetSize source:(UIImage*)sourceImages{
    
    
    
    // Create a new UIImage
    CGImageRef imageRef = CGImageCreateWithImageInRect(sourceImages.CGImage, targetSize);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return croppedImage;
}

-(UIImage *) ChangeViewToImage : (UIView *) view{
    
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (NSDictionary *) indexKeyedDictionaryFromArray:(NSMutableArray *)array
{
    id objectInstance;
    NSUInteger indexKey = 0;
    
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    for (objectInstance in array)
        [mutableDictionary setObject:objectInstance forKey:[NSNumber numberWithUnsignedInt:indexKey++]];
    
    return [mutableDictionary copy];
}

- (NSString *)decodeHTMLCharacterEntities:(NSString*)str {
    if ([str rangeOfString:@"&"].location == NSNotFound) {
        return str;
    } else {
        NSMutableString *escaped = [NSMutableString stringWithString:str];
        NSArray *codes = [NSArray arrayWithObjects:
                          @"&nbsp;", @"&iexcl;", @"&cent;", @"&pound;", @"&curren;", @"&yen;", @"&brvbar;",
                          @"&sect;", @"&uml;", @"&copy;", @"&ordf;", @"&laquo;", @"&not;", @"&shy;", @"&reg;",
                          @"&macr;", @"&deg;", @"&plusmn;", @"&sup2;", @"&sup3;", @"&acute;", @"&micro;",
                          @"&para;", @"&middot;", @"&cedil;", @"&sup1;", @"&ordm;", @"&raquo;", @"&frac14;",
                          @"&frac12;", @"&frac34;", @"&iquest;", @"&Agrave;", @"&Aacute;", @"&Acirc;",
                          @"&Atilde;", @"&Auml;", @"&Aring;", @"&AElig;", @"&Ccedil;", @"&Egrave;",
                          @"&Eacute;", @"&Ecirc;", @"&Euml;", @"&Igrave;", @"&Iacute;", @"&Icirc;", @"&Iuml;",
                          @"&ETH;", @"&Ntilde;", @"&Ograve;", @"&Oacute;", @"&Ocirc;", @"&Otilde;", @"&Ouml;",
                          @"&times;", @"&Oslash;", @"&Ugrave;", @"&Uacute;", @"&Ucirc;", @"&Uuml;", @"&Yacute;",
                          @"&THORN;", @"&szlig;", @"&agrave;", @"&aacute;", @"&acirc;", @"&atilde;", @"&auml;",
                          @"&aring;", @"&aelig;", @"&ccedil;", @"&egrave;", @"&eacute;", @"&ecirc;", @"&euml;",
                          @"&igrave;", @"&iacute;", @"&icirc;", @"&iuml;", @"&eth;", @"&ntilde;", @"&ograve;",
                          @"&oacute;", @"&ocirc;", @"&otilde;", @"&ouml;", @"&divide;", @"&oslash;", @"&ugrave;",
                          @"&uacute;", @"&ucirc;", @"&uuml;", @"&yacute;", @"&thorn;", @"&yuml;",@"&rarr;", nil];
        
        NSUInteger i, count = [codes count];
        
        // Html
        for (i = 0; i < count; i++) {
            NSRange range = [str rangeOfString:[codes objectAtIndex:i]];
            if (range.location != NSNotFound) {
                unichar codeValue0 = 160 + i;
                [escaped replaceOccurrencesOfString:[codes objectAtIndex:i]
                                         withString:[NSString stringWithFormat:@"%C", codeValue0]
                                            options:NSLiteralSearch
                                              range:NSMakeRange(0, [escaped length])];
            }
        }
        
        // The following five are not in the 160+ range
        
        // @"&amp;"
        NSRange range = [str rangeOfString:@"&amp;"];
        if (range.location != NSNotFound) {
            unichar codeValue1 = 38;
            [escaped replaceOccurrencesOfString:@"&amp;"
                                     withString:[NSString stringWithFormat:@"%C", codeValue1]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&lt;"
        range = [str rangeOfString:@"&lt;"];
        if (range.location != NSNotFound) {
            unichar codeValue2 = 60;
            [escaped replaceOccurrencesOfString:@"&lt;"
                                     withString:[NSString stringWithFormat:@"%C", codeValue2]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&gt;"
        range = [str rangeOfString:@"&gt;"];
        if (range.location != NSNotFound) {
            unichar codeValue3 = 62;
            [escaped replaceOccurrencesOfString:@"&gt;"
                                     withString:[NSString stringWithFormat:@"%C", codeValue3]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&apos;"
        range = [str rangeOfString:@"&apos;"];
        if (range.location != NSNotFound) {
            unichar codeValue4 = 39;
            [escaped replaceOccurrencesOfString:@"&apos;"
                                     withString:[NSString stringWithFormat:@"%C", codeValue4]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&quot;"
        range = [str rangeOfString:@"&quot;"];
        if (range.location != NSNotFound) {
            unichar codeValue5 = 34;
            [escaped replaceOccurrencesOfString:@"&quot;"
                                     withString:[NSString stringWithFormat:@"%C", codeValue5]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&hellip;"
        range = [str rangeOfString:@"&hellip;"];
        if (range.location != NSNotFound) {
            
            [escaped replaceOccurrencesOfString:@"&hellip;"
                                     withString:[NSString stringWithFormat:@"%@", @"..."]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // Decimal & Hex
        NSRange start, finish, searchRange = NSMakeRange(0, [escaped length]);
        i = 0;
        
        while (i < [escaped length]) {
            start = [escaped rangeOfString:@"&#"
                                   options:NSCaseInsensitiveSearch
                                     range:searchRange];
            
            finish = [escaped rangeOfString:@";"
                                    options:NSCaseInsensitiveSearch
                                      range:searchRange];
            
            if (start.location != NSNotFound && finish.location != NSNotFound &&
                finish.location > start.location) {
                NSRange entityRange = NSMakeRange(start.location, (finish.location - start.location) + 1);
                NSString *entity = [escaped substringWithRange:entityRange];
                NSString *value = [entity substringWithRange:NSMakeRange(2, [entity length] - 2)];
                
                [escaped deleteCharactersInRange:entityRange];
                
                if ([value hasPrefix:@"x"]) {
                    unsigned tempInt = 0;
                    unichar se = tempInt;
                    NSScanner *scanner = [NSScanner scannerWithString:[value substringFromIndex:1]];
                    [scanner scanHexInt:&tempInt];
                    [escaped insertString:[NSString stringWithFormat:@"%C", se] atIndex:entityRange.location];
                } else {
                    unichar se2 = [value intValue];
                    [escaped insertString:[NSString stringWithFormat:@"%C", se2] atIndex:entityRange.location];
                } i = start.location;
            } else { i++; }
            searchRange = NSMakeRange(i, [escaped length] - i);
        }
        
        return escaped;    // Note this is autoreleased
    }
}

- (NSString *)stringForTimeIntervalSinceCreated:(NSDate *)dateTime serverTime:(NSDate *)serverDateTime{
    NSInteger MinInterval;
    NSInteger HourInterval;
    NSInteger DayInterval;
    NSInteger DayModules;
    
    NSInteger interval = abs((NSInteger)[dateTime timeIntervalSinceDate:serverDateTime]);
    if(interval >= 86400)
    {
        DayInterval  = interval/86400;
        DayModules = interval%86400;
        if(DayModules!=0)
        {
            if(DayModules>=3600){
                //HourInterval=DayModules/3600;
                return [NSString stringWithFormat:@"%i days", DayInterval];
            }
            else {
                if(DayModules>=60){
                    //MinInterval=DayModules/60;
                    return [NSString stringWithFormat:@"%i days", DayInterval];
                }
                else {
                    return [NSString stringWithFormat:@"%i days", DayInterval];
                }
            }
        }
        else
        {
            return [NSString stringWithFormat:@"%i days", DayInterval];
        }
        
    }
    
    else{
        
        if(interval>=3600)
        {
            
            HourInterval= interval/3600;
            return [NSString stringWithFormat:@"%i hours", HourInterval];
            
        }
        
        else if(interval>=60){
            
            MinInterval = interval/60;
            
            return [NSString stringWithFormat:@"%i minutes", MinInterval];
        }
        else{
            return [NSString stringWithFormat:@"%i Sec", interval];
        }
        
    }
    
}

- (BOOL) validateEmail: (NSString *) emailaddress {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailaddress];
}



- (UIImage *)changeImageColor:(NSString *)name withColor:(UIColor *)color{
    
    // load the image
    
    UIImage *img = [UIImage imageNamed:name];
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}


-(void)checkLink:(NSString*)str navigation:(UINavigationController*)nav{
    
    int indicator=0;
    
    NSDictionary *checkLink = [[DataService instance] qrcodescanner:str];
    NSString *checkLinkResult = [checkLink objectForKey:@"post_type"];
    
    NSDictionary *linkPostResult;
    
    if([checkLinkResult isEqualToString:@"link"])
    {
        indicator = 0;
        
    }
    else if([checkLinkResult isEqualToString:@"page"])
    {
        indicator = 1;
        linkPostResult = [[DataService instance] getWpPostByPostID:[checkLink objectForKey:@"postID"]];
    }
    else if([checkLinkResult isEqualToString:@"post"])
    {
        indicator = 2;
        linkPostResult = [[DataService instance] getWpPostByPostID:[checkLink objectForKey:@"postID"]];
    }
    else if([checkLinkResult isEqualToString:@"product"])
    {
        indicator = 3;
        linkPostResult = [[DataService instance] getSingleProduct:[checkLink objectForKey:@"postID"]];
    }
    else
    {
        indicator = 0;
    }
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if(indicator == 0)
            {
                iPhoneWebView *ip = [[iPhoneWebView alloc] init];
                [ip loadUrlInWebView:[checkLink objectForKey:@"link"]];
                [nav pushViewController:ip animated:YES];
            }
            else if(indicator == 1)
            {
                NSString *pageTem = [linkPostResult objectForKey:@"page_template_type"];
                
                if([pageTem isEqualToString:@"PlainPageWithoutFeaturedImage"])
                {
                    PlainPostDetailViewController *pDetail = [[PlainPostDetailViewController alloc] init];
                    pDetail.title = [linkPostResult objectForKey:@"title"];
                    [pDetail setPostInfo:linkPostResult];
                    [nav pushViewController:pDetail animated:YES];
                }
                else
                {
                    PostDetailViewController *pDetail = [[PostDetailViewController alloc] init];
                    [pDetail setPostDictionary:linkPostResult];
                    [nav pushViewController:pDetail animated:YES];
                }
            }
            else if(indicator == 2)
            {
                NSString *pageTem = [linkPostResult objectForKey:@"page_template_type"];
                
                if([pageTem isEqualToString:@"PlainPageWithoutFeaturedImage"])
                {
                    PlainPostDetailViewController *pDetail = [[PlainPostDetailViewController alloc] init];
                    pDetail.title = [linkPostResult objectForKey:@"title"];
                    [pDetail setPostInfo:linkPostResult];
                    [nav pushViewController:pDetail animated:YES];
                }
                else
                {
                    PostDetailViewController *pDetail = [[PostDetailViewController alloc] init];
                    [pDetail setPostDictionary:linkPostResult];
                    [nav pushViewController:pDetail animated:YES];
                    
                }
            }
            else if(indicator == 3)
            {
                DetailViewController *productDetail = [[DetailViewController alloc] init];
                [productDetail setProductInfo:linkPostResult];
                [nav pushViewController:productDetail animated:YES];
                
            }
            else
            {
                iPhoneWebView *ip = [[iPhoneWebView alloc] init];
                [ip loadUrlInWebView:[checkLink objectForKey:@"link"]];
                [nav pushViewController:ip animated:YES];
            }
        });
    });
}



@end
