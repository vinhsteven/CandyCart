

#import "ContactUsViewController.h"



#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360
@interface ContactUsViewController ()

@end

@implementation ContactUsViewController
@synthesize mapView,titleName,address,emailNow,callNow;
#ifndef ANDROID
@synthesize blackBack;
#endif

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
               
       
    }
    return self;
}


-(IBAction)emailNow:(id)sender{
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    
    
    [mailer setToRecipients:[NSArray arrayWithObject:email]];
    [self presentViewController:mailer animated:YES completion:nil];
    
   
    
}

-(IBAction)callNow:(id)sender{
    
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",pNumber]]];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)initContactUsTemplate:(NSArray*)ary{
    
    NSLog(@"Init ContactUsTemplate %@",[ary objectAtIndex:3]);
    dataSent = ary;
    
    
}


-(void)initContactUsTemplateDictionary:(NSDictionary*)ary{
    
   
    contactInfo = ary;
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString* BridgeAnnotationIdentifier = @"bridgeAnnotationIdentifier";
    
    MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                          initWithAnnotation:annotation reuseIdentifier:BridgeAnnotationIdentifier];
    
    customPinView.animatesDrop = YES;
    customPinView.canShowCallout = YES;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton setTitle:annotation.title forState:UIControlStateNormal];
    [customPinView setRightCalloutAccessoryView:rightButton];
    
    return customPinView;//[kml viewForAnnotation:annotation];
}


- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    [self openActionSheet];
}

-(void)openActionSheet{
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Open Using" delegate:self cancelButtonTitle:@"Cancel Button" destructiveButtonTitle:nil otherButtonTitles:@"Apple Map", @"Google Map",@"Waze", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showInView:self.view];
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		NSLog(@"Apple Map");
        
        
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat,longti);
        
        //create MKMapItem out of coordinates
        MKPlacemark* placeMark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
        MKMapItem* destination =  [[MKMapItem alloc] initWithPlacemark:placeMark];
        
        if([destination respondsToSelector:@selector(openInMapsWithLaunchOptions:)])
        {
            //using iOS6 native maps app
            [destination openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
            
        } else{
            
            //using iOS 5 which has the Google Maps application
            NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?q=%f,%f", lat, longti];
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
        }
        
        
	} else if (buttonIndex == 1) {
        NSLog(@"Google Map");
        NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?q=%f,%f", lat, longti];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
        
	} else if (buttonIndex == 2) {
		NSLog(@"Waze");
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"waze://"]]) {
            //Waze is installed. Launch Waze and start navigation
            NSString *urlStr = [NSString stringWithFormat:@"waze://?ll=%f,%f&navigate=yes", lat, longti];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        } else {
            //Waze is not installed. Launch AppStore to install Waze app
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/id323229106"]];
        }
        
        
	}
    else{
        NSLog(@"Cancel");
        
    }
    
}



- (void)zoomMapViewToFitAnnotations:(MKMapView *)mapViews animated:(BOOL)animated
{
    NSArray *annotations = mapViews.annotations;
    int count = [mapViews.annotations count];
    if ( count == 0) { return; } //bail if no annotations
    
    //convert NSArray of id <MKAnnotation> into an MKCoordinateRegion that can be used to set the map size
    //can't use NSArray with MKMapPoint because MKMapPoint is not an id
    MKMapPoint points[count]; //C array of MKMapPoint struct
    for( int i=0; i<count; i++ ) //load points C array by converting coordinates to points
    {
        CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] = MKMapPointForCoordinate(coordinate);
    }
    //create MKMapRect from array of MKMapPoint
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
    //convert MKCoordinateRegion from MKMapRect
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    
    //add padding so pins aren't scrunched on the edges
    region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    //but padding can't be bigger than the world
    if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }
    
    //and don't zoom in stupid-close on small samples
    if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
    //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
    if( count == 1 )
    {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [mapViews setRegion:region animated:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
#ifndef ANDROID
    blackBack.blurEnabled = YES;
    blackBack.blurRadius = 9;
    blackBack.dynamic = YES;
    blackBack.tintColor = [UIColor blackColor];
#endif
   [titleName setNuiClass:@"contactUsViewController_titleName"];
    
    [address setNuiClass:@"contactUsViewController_address"];
    [emailNow setNuiClass:@"contactUsViewController_btn"];
    
    [callNow setNuiClass:@"contactUsViewController_btn"];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    if([[DeviceClass instance] getDevice] == IPHONE_5)
    {
        CGRect blac;
#ifndef ANDROID
        blac = blackBack.frame;
        blac.origin.y = 450;
        blackBack.frame = blac;
#endif
        
        blac = titleName.frame;
        blac.origin.y = 460;
        titleName.frame = blac;
        
        blac = address.frame;
        blac.origin.y = 475;
        address.frame = blac;
        
        blac = emailNow.frame;
        blac.origin.y = 415;
        emailNow.frame = blac;
        
        blac = callNow.frame;
        blac.origin.y = 415;
        callNow.frame = blac;
        
    }
    else
    {
        CGRect blac;
#ifndef ANDROID
        blac = blackBack.frame;
        blac.origin.y = 362;
        blackBack.frame = blac;
#endif
        
        blac = titleName.frame;
        blac.origin.y = 372;
        titleName.frame = blac;
        
        blac = address.frame;
        blac.origin.y = 387;
        address.frame = blac;
        
        blac = emailNow.frame;
        blac.origin.y = 330;
        emailNow.frame = blac;
        
        blac = callNow.frame;
        blac.origin.y = 330;
        callNow.frame = blac;
    }

    emailNow.titleLabel.text = NSLocalizedString(@"contactus_template_emailNow_btn", nil);
    callNow.titleLabel.text = NSLocalizedString(@"contactus_template_callNow_btn", nil);
    
    titleName.text = [contactInfo objectForKey:@"candyStoreName"];
    address.text = [contactInfo objectForKey:@"candyStoreAddress"];
    pNumber = [contactInfo objectForKey:@"candyLocPhone"];
    email = [contactInfo objectForKey:@"candyLocEmail"];
    
    lat = [[contactInfo objectForKey:@"candyLat"] doubleValue];
    longti = [[contactInfo objectForKey:@"candyLong"] doubleValue];
    
    
    CLLocationCoordinate2D location;
	location.latitude = lat;
	location.longitude = longti;
    
    
	// Add the annotation to our map view
	MapViewAnnotation *newAnnotation = [[MapViewAnnotation alloc] initWithTitle:[NSString stringWithFormat:@"%@",[contactInfo objectForKey:@"candyStoreName"]] andCoordinate:location];
	[mapView addAnnotation:newAnnotation];
    
    [self zoomMapViewToFitAnnotations:mapView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
