

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MapViewAnnotation.h"
#import <MapKit/MapKit.h>

#ifndef ANDROID
#import "FXBlurView.h"
#endif
@interface ContactUsViewController : UIViewController<UIActionSheetDelegate,MFMailComposeViewControllerDelegate,MKMapViewDelegate,MKAnnotation>
{
  
    double lat;
    double longti;
    NSArray *places;
    CLLocationDegrees zoomLevel;
    NSArray *dataSent;
    NSString *email;
    NSString *pNumber;
    NSDictionary *contactInfo;
}
@property(nonatomic,retain) IBOutlet MKMapView *mapView;
@property(nonatomic,retain) IBOutlet UILabel *titleName;
@property(nonatomic,retain) IBOutlet UILabel *address;

#ifndef ANDROID
@property(nonatomic,retain) IBOutlet FXBlurView *blackBack;
#endif
@property(nonatomic,retain) IBOutlet UIButton *emailNow;
@property(nonatomic,retain) IBOutlet UIButton *callNow;
-(void)initContactUsTemplate:(NSArray*)ary;
-(void)initContactUsTemplateDictionary:(NSDictionary*)ary;
-(IBAction)emailNow:(id)sender;
-(IBAction)callNow:(id)sender;
@end
