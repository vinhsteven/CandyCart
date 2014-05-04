

#import "MGBox.h"
#import "DLStarRatingControl.h"
@interface PhotoBox : MGBox<UIScrollViewDelegate>
{
    UILabel *subCategoryTitle;
    
}



+(PhotoBox *)fullImageBox:(CGSize)size pictureURL:(NSString*)url title:(NSString*)pTitle currency:(NSString*)currency regularPrice:(NSString*)productPrice salePrice:(NSString*)salePrice isOnSale:(BOOL)onSale notSimple:(BOOL)notSimple;

+(PhotoBox *)fullImageBox:(CGSize)size pictureURL:(NSString*)url title:(NSString*)pTitle currency:(NSString*)currency regularPrice:(NSString*)productPrice salePrice:(NSString*)salePrice isOnSale:(BOOL)onSale notSimple:(BOOL)notSimple displayPrice:(BOOL)isDisplayPrice;

+ (PhotoBox *)chooseSubCategory:(CGSize)size;

// GridStyle Box
+ (PhotoBox *)gridStyleOnSale:(CGSize)size img:(NSString*)url title:(NSString*)str priceRegular:(NSString*)regularPrice salePrice:(NSString*)salePrice;
+ (PhotoBox *)gridStyleNormal:(CGSize)size img:(NSString*)url title:(NSString*)str priceRegular:(NSString*)regularPrice;
+ (PhotoBox *)gridStyleNormal:(CGSize)size img:(NSString*)url title:(NSString*)str priceRegular:(NSString*)regularPrice displayPrice:(BOOL)isDisplayPrice;

//Mics Box
+ (PhotoBox *)loadMore:(CGSize)size;

//Misc
+(UILabel*)getUILabelForSubCategoryLabel;

//Review Box
+ (PhotoBox *)reviewHeader:(CGSize)size username:(NSString*)username imgUrl:(NSString*)url rating:(float)rate;

@end
