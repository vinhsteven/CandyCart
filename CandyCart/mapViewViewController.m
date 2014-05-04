

#import "mapViewViewController.h"

//mapview starting points
#define kCenterPointLatitude  44.691058
#define kCenterPointLongitude 16.382895
#define kSpanDeltaLatitude    5.263112
#define kSpanDeltaLongitude   5.697419

#define iphoneScaleFactorLatitude   9.0    
#define iphoneScaleFactorLongitude  11.0  

#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360

@implementation mapViewViewController
@synthesize myMapView,segment,toolbar;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}



-(void)loadPlaces:(NSArray*)ary{
    
    NSLog(@"Sekali");
    srand((unsigned)time(0));
    allArray = ary;
    NSMutableArray *tempPlaces=[[NSMutableArray alloc] init];
   
    
     for (NSDictionary *result in allArray) {
       
         NSString *title = [result objectForKey:@"title"];
         NSString *latitude = [[[result objectForKey:@"page_template_meta"] objectForKey:@"if_businessDirectoryPlugin"] objectForKey:@"latitude"];
         
          NSString *longtitude = [[[result objectForKey:@"page_template_meta"] objectForKey:@"if_businessDirectoryPlugin"] objectForKey:@"longtitude"];
         
         
         NSString *address = [[[result objectForKey:@"page_template_meta"] objectForKey:@"if_businessDirectoryPlugin"] objectForKey:@"address"];
         
         MyPlace *place=[[MyPlace alloc] initWithCoordinate:CLLocationCoordinate2DMake([latitude doubleValue],[longtitude doubleValue])];
        [place setPost:result];
         [place setCurrentTitle:[NSString stringWithFormat:@"%@",[self decodeHTMLCharacterEntities:title]]];
         [place setCurrentSubTitle:address];
         [place addPlace:place];
         [tempPlaces addObject:place];
     }
    
    
    places=[[NSArray alloc] initWithArray:tempPlaces];
    
    [myMapView addAnnotations:places];
    [self zoomMapViewToFitAnnotations:myMapView animated:YES];
}



-(float)RandomFloatStart:(float)a end:(float)b {
    float random = ((float) rand()) / (float) RAND_MAX;
    float diff = b - a;
    float r = random * diff;
    return a + r;
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [self.view setNuiClass:@"ViewInit"];
    
    if([[DeviceClass instance] getDevice] == IPHONE_5)
    {
        myMapView.frame = CGRectMake(0, 0, 320, 470+40+40+20);
        
    }
    else
    {
        myMapView.frame = CGRectMake(0, 0, 320, 420+40+40+20+40+10);
        
    }
    
    
    
    
    
   
  
    
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self
	                     action:@selector(pickOne:)
	           forControlEvents:UIControlEventValueChanged];
 
    
     locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    startUpdating = NO;
    [super viewDidLoad];
      [self zoomMapViewToFitAnnotations:myMapView animated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self zoomMapViewToFitAnnotations:myMapView animated:YES];
}

-(void)openActionSheet{
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"map_actionsheet_findnearme_title", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"map_actionsheet_findnearme_cancel_btn", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"map_actionsheet_findnearme_100km", nil), NSLocalizedString(@"map_actionsheet_findnearme_50km", nil),NSLocalizedString(@"map_actionsheet_findnearme_25km", nil), nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showInView:self.view];
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		NSLog(@"100 KM");
        
        myMapView.showsUserLocation = YES;
        places = [[NSArray alloc] init];
        [myMapView removeAnnotations:myMapView.annotations];
        
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.delegate = self;
        HUD.labelText = NSLocalizedString(@"loading", nil);
        HUD.detailsLabelText = NSLocalizedString(@"Please_wait", nil);
        
        [self.view addSubview:HUD];
        
       
            
        
	} else if (buttonIndex == 1) {
        NSLog(@"50 KM");
        myMapView.showsUserLocation = YES;
        places = [[NSArray alloc] init];
        [myMapView removeAnnotations:myMapView.annotations];
        
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.delegate = self;
        HUD.labelText = NSLocalizedString(@"loading", nil);
        HUD.detailsLabelText = NSLocalizedString(@"Please_wait", nil);
        
        [self.view addSubview:HUD];
        
       

        
        

	} else if (buttonIndex == 2) {
		
        NSLog(@"25 KM");
        myMapView.showsUserLocation = YES;
        places = [[NSArray alloc] init];
        [myMapView removeAnnotations:myMapView.annotations];
        
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.delegate = self;
        HUD.labelText = NSLocalizedString(@"loading", nil);
        HUD.detailsLabelText = NSLocalizedString(@"Please_wait", nil);
        
        [self.view addSubview:HUD];
        
        
     
        
        
      
        
	}
    else{
        NSLog(@"Cancel");
        segment.selectedSegmentIndex = 0;
    }
    
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



- (void) pickOne:(id)sender{
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    segment.selectedSegmentIndex = [segmentedControl selectedSegmentIndex];
   if([segmentedControl selectedSegmentIndex] == 0)
   {
       NSLog(@"All");
      
       [self performSelectorOnMainThread:@selector(backToAllPlace) withObject:nil waitUntilDone:TRUE];
  
       [locationManager stopUpdatingLocation];
       startUpdating = NO;
   }
    else if([segmentedControl selectedSegmentIndex] == 1)
    {
        NSLog(@"Find Near Me");
        
       [locationManager startUpdatingLocation];
        
        [self openActionSheet];
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        Currentlatitude = currentLocation.coordinate.latitude;
        Currentlongtitude = currentLocation.coordinate.longitude;
        startUpdating = YES;
        
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    segment.selectedSegmentIndex = 0;
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

-(void)addMultiAnnotation:(NSArray*)ary{
    
    [self loadPlaces:ary];
    
    CLLocationCoordinate2D centerPoint = {kCenterPointLatitude, kCenterPointLongitude};
	MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(kSpanDeltaLatitude, kSpanDeltaLongitude);
	MKCoordinateRegion coordinateRegion = MKCoordinateRegionMake(centerPoint, coordinateSpan);
    
	[myMapView setRegion:coordinateRegion];
	[myMapView regionThatFits:coordinateRegion];
    [self filterAnnotations:places];
    
    
   
}

#pragma mark - mapView


- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation{
	
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        NSLog(@"User Location");
        return nil;
    }
	else{
        MKAnnotationView *annotationView = nil;        
        static NSString *StartPinIdentifier = @"PinIdentifier";
        MKPinAnnotationView *startPin = (id)[mV dequeueReusableAnnotationViewWithIdentifier:StartPinIdentifier];
		if (startPin == nil) {
            startPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:StartPinIdentifier];
            startPin.animatesDrop = YES;
            startPin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];            
            startPin.canShowCallout = YES;
            startPin.enabled = YES;
        }
        annotationView = startPin;
        return annotationView;
	}   
}



- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if ([view.annotation isKindOfClass:[MKUserLocation class]]){
        
    }
    else
    {
    NSLog(@"Did Tapped");
    MyPlace *annView = view.annotation;
    
    NSString *se = annView.postID;
    NSLog(@"%@",se);
    
        UserDetailViewController *detail = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
        detail.title = [annView.post objectForKey:@"title"];
        [detail getData:annView.post];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if ([view.annotation isKindOfClass:[MKUserLocation class]]){
      
    }
    else
    {
    NSLog(@"Did select %@",view.annotation.title);
    MyPlace *annView = view.annotation;
    
    NSLog(@"%d",[annView placesCount]);
    
    
    
    
    if([annView placesCount] == 1)
    {
        view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    else
    {
        view.rightCalloutAccessoryView.hidden = YES;
    }
    }
    
        
  
}


-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (zoomLevel!=mapView.region.span.longitudeDelta) {     
        [self filterAnnotations:places];
        zoomLevel=mapView.region.span.longitudeDelta;
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
    [myMapView setRegion:region animated:animated];
}



-(void)filterAnnotations:(NSArray *)placesToFilter{
    float latDelta=myMapView.region.span.latitudeDelta/iphoneScaleFactorLatitude;
    float longDelta=myMapView.region.span.longitudeDelta/iphoneScaleFactorLongitude;
    [placesToFilter makeObjectsPerformSelector:@selector(cleanPlaces)];
    NSMutableArray *shopsToShow=[[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i=0; i<[placesToFilter count]; i++) {
        MyPlace *checkingLocation=[placesToFilter objectAtIndex:i];
        CLLocationDegrees latitude = [checkingLocation getCoordinate].latitude;
        CLLocationDegrees longitude = [checkingLocation getCoordinate].longitude;

        bool found=FALSE;
        for (MyPlace *tempPlacemark in shopsToShow) {
            if(fabs([tempPlacemark getCoordinate].latitude-latitude) < latDelta && fabs([tempPlacemark getCoordinate].longitude-longitude)<longDelta ){
                [myMapView removeAnnotation:checkingLocation];
                found=TRUE;
                [tempPlacemark addPlace:checkingLocation];
                break;
            }
        }
        if (!found) {
            [shopsToShow addObject:checkingLocation];
            [myMapView addAnnotation:checkingLocation];
        }
        
    }
   
}


- (void)viewDidUnload
{
    
    
    myMapView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
