

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation
@synthesize title, coordinate;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d {
	
	title = ttl;
	coordinate = c2d;
    
	return self;
}

@end
