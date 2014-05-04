

#import <UIKit/UIKit.h>

@interface iPhoneWebView : UIViewController<UIScrollViewDelegate>
{
    UIWebView *webViewSe;
    NSString *urls;
     CGPoint initialContentOffset;
}
-(void)loadUrlInWebView:(NSString*)url;
@end
