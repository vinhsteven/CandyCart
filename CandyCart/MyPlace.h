

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyPlace : NSObject <MKAnnotation>{
    CLLocationCoordinate2D coordinate;
	NSString *currentSubTitle;
	NSString *currentTitle;
    NSMutableArray *places;
    NSString *postID;
}



@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *currentTitle;
@property (nonatomic, retain) NSString *currentSubTitle;
@property (nonatomic, retain) NSString *postID;
@property (nonatomic, retain) NSDictionary *post;
- (NSString *)title;
- (NSString *)subtitle;
-(id)initWithCoordinate:(CLLocationCoordinate2D) c;
-(CLLocationCoordinate2D)getCoordinate;
-(void)addPlace:(MyPlace *)place;
-(int)placesCount;
-(NSString *)getPostID;

@end
