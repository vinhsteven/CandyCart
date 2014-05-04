

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "MyPlace.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
#import "UserDetailViewController.h"
@interface mapViewViewController : UIViewController<UIActionSheetDelegate,CLLocationManagerDelegate,MBProgressHUDDelegate> {
    
    IBOutlet MKMapView *myMapView;
    NSArray *places;
    CLLocationDegrees zoomLevel;
    IBOutlet UISegmentedControl *segment;
    CLLocationManager *locationManager;
    double Currentlatitude;
    double Currentlongtitude;
    BOOL startUpdating;
    NSArray *allArray;
    MBProgressHUD *HUD;
    NSArray *findNearestArray;

}
@property(nonatomic,retain) IBOutlet UIToolbar *toolbar;
@property(nonatomic,retain) IBOutlet UISegmentedControl *segment;
@property(nonatomic,retain) IBOutlet MKMapView *myMapView;
-(void)addMultiAnnotation:(NSArray*)ary;
-(void)loadPlaces:(NSArray*)ary;
-(float)RandomFloatStart:(float)a end:(float)b;
-(void)filterAnnotations:(NSArray *)placesToFilter;
@end
