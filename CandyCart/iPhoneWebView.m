
#import "iPhoneWebView.h"

@interface iPhoneWebView ()<UIWebViewDelegate>

@end

@implementation iPhoneWebView

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
    
     
    
   
    
    UIButton *safari = [UIButton buttonWithType:UIButtonTypeCustom];
    safari.frame = CGRectMake(self.view.frame.size.width - 69, 8, 83, 30);
    safari.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [safari setTitle:NSLocalizedString(@"inappwebview_safari_button", nil) forState:UIControlStateNormal];
    [safari addTarget:self
             action:@selector(gotosafari)
   forControlEvents:UIControlEventTouchDown];
    
    [safari setNuiClass:@"UiBarButtonItem"];
    [safari.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithCustomView:safari];
    self.navigationItem.rightBarButtonItem = button;
}


-(void)gotosafari{
   
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urls]];
}

-(void)loadUrlInWebView:(NSString*)url{
    NSLog(@"Open Url : %@",url);
    urls = url;
    CGRect webFrame;
    
   
      webFrame = [[DeviceClass instance] getResizeScreen:NO];
    webViewSe = [[UIWebView alloc] initWithFrame:webFrame];
    
    webViewSe.delegate = self;
    webViewSe.scalesPageToFit = YES;
    webViewSe.scrollView.delegate = self;
    NSString *urlAddress = url;
    urls = url;
    NSURL *urlss = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:urlss];
    [webViewSe loadRequest:requestObj];
    
    [self.view addSubview:webViewSe];
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.title = NSLocalizedString(@"inappwebview_loading", nil)
;
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    initialContentOffset = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
    [[SettingDataClass instance] autoHideGlobal:scrollView navigationView:self.navigationController contentOffset:initialContentOffset];
    
   
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.title = NSLocalizedString(@"inappwebview_done", nil);
}
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

-(BOOL)shouldAutorotate{
    return NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
