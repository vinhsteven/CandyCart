

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MapViewAnnotation : NSObject<MKAnnotation>
{
    NSString *title;
	CLLocationCoordinate2D coordinate;
    
}
- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d;
@end
